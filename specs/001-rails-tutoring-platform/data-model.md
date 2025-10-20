# Data Model: Rails Tutoring Platform

**Feature**: 001-rails-tutoring-platform  
**Date**: 2025-10-20  
**Phase**: 1 - Design & Contracts

## Overview

This document defines the database schema, entity relationships, validations, and state transitions for the Rails tutoring platform.

## Entity Relationship Diagram

```
┌─────────────┐
│    User     │
└──────┬──────┘
       │
       ├──────────────────────────────────────┐
       │                                      │
       ▼                                      ▼
┌─────────────┐                      ┌──────────────┐
│   Student   │◄─────────────────────┤    Parent    │
│  (role=1)   │  parent_students     │   (role=0)   │
└──────┬──────┘                      └──────────────┘
       │
       │ student_tutors
       │
       ▼
┌─────────────┐
│    Tutor    │
│  (role=2)   │
└──────┬──────┘
       │
       ├──────────────┐
       │              │
       ▼              ▼
┌─────────────┐  ┌──────────────┐
│    Class    │  │   Homework   │
└──────┬──────┘  └──────┬───────┘
       │                │
       │                ├──────────────┐
       │                │              │
       ▼                ▼              ▼
┌─────────────┐  ┌──────────────┐  ┌──────────────────┐
│ Notification│  │   Homework   │  │  FileAttachment  │
└─────────────┘  │  Submission  │  └──────────────────┘
                 └──────────────┘

┌──────────────┐
│   Feedback   │◄───── Tutor
└──────┬───────┘
       │
       └──────► Student

┌──────────────┐
│   Message    │◄───── Parent/Tutor
└──────────────┘

┌──────────────────────┐
│ ContactFormSubmission│
└──────────────────────┘
```

## Core Entities

### User

**Purpose**: Base model for all system users with role-based access

**Table**: `users`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| email | string | NOT NULL, UNIQUE, indexed | User email address |
| encrypted_password | string | NOT NULL | Devise encrypted password |
| role | integer | NOT NULL, default: 0 | User role enum |
| first_name | string | NOT NULL | User first name |
| last_name | string | NOT NULL | User last name |
| phone_number | string | NULL | Contact phone number |
| active | boolean | NOT NULL, default: true | Account active status |
| deleted_at | datetime | NULL, indexed | Soft delete timestamp |
| reset_password_token | string | UNIQUE, indexed | Devise password reset |
| reset_password_sent_at | datetime | NULL | Devise password reset timestamp |
| remember_created_at | datetime | NULL | Devise remember me |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_users_on_email` (UNIQUE)
- `index_users_on_reset_password_token` (UNIQUE)
- `index_users_on_deleted_at`
- `index_users_on_role`

**Enums**:
```ruby
enum role: {
  parent: 0,
  student: 1,
  tutor: 2,
  administrator: 3
}
```

**Validations**:
- `email`: presence, uniqueness, format (email regex)
- `first_name`: presence, length (2-50)
- `last_name`: presence, length (2-50)
- `phone_number`: format (international phone), allow_blank
- `role`: presence, inclusion in enum values

**Associations**:
- `has_many :student_tutors` (as student)
- `has_many :tutors, through: :student_tutors`
- `has_many :parent_students` (as student)
- `has_many :parents, through: :parent_students`
- `has_many :classes` (as student or tutor, polymorphic)
- `has_many :homework_assignments` (as student or tutor)
- `has_many :notifications` (as recipient)
- `has_many :feedbacks` (as student or tutor)
- `has_many :messages` (as sender or recipient)

**Scopes**:
- `active`: where(active: true, deleted_at: nil)
- `deleted`: where.not(deleted_at: nil)
- `by_role(role)`: where(role: role)

**Methods**:
- `full_name`: "#{first_name} #{last_name}"
- `soft_delete`: Update deleted_at timestamp
- `restore`: Clear deleted_at timestamp

---

### StudentTutor (Join Table)

**Purpose**: Many-to-many relationship between students and tutors

**Table**: `student_tutors`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Student reference |
| tutor_id | bigint | NOT NULL, FK → users.id, indexed | Tutor reference |
| assigned_at | datetime | NOT NULL, default: now | Assignment timestamp |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_student_tutors_on_student_id`
- `index_student_tutors_on_tutor_id`
- `index_student_tutors_on_student_id_and_tutor_id` (UNIQUE)

**Validations**:
- `student_id`: presence, uniqueness scoped to tutor_id
- `tutor_id`: presence
- Validate student has role 'student'
- Validate tutor has role 'tutor'

**Associations**:
- `belongs_to :student, class_name: 'User'`
- `belongs_to :tutor, class_name: 'User'`

---

### ParentStudent (Join Table)

**Purpose**: Many-to-many relationship between parents and students

**Table**: `parent_students`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| parent_id | bigint | NOT NULL, FK → users.id, indexed | Parent reference |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Student reference |
| relationship | string | NULL | Relationship type (mother, father, guardian) |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_parent_students_on_parent_id`
- `index_parent_students_on_student_id`
- `index_parent_students_on_parent_id_and_student_id` (UNIQUE)

**Validations**:
- `parent_id`: presence, uniqueness scoped to student_id
- `student_id`: presence
- Validate parent has role 'parent'
- Validate student has role 'student'

**Associations**:
- `belongs_to :parent, class_name: 'User'`
- `belongs_to :student, class_name: 'User'`

---

### Class

**Purpose**: Represents a scheduled tutoring session

**Table**: `classes`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| tutor_id | bigint | NOT NULL, FK → users.id, indexed | Tutor reference |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Student reference |
| subject | string | NOT NULL | Subject being taught |
| scheduled_at | datetime | NOT NULL, indexed | Class start time |
| duration_minutes | integer | NOT NULL, default: 60 | Class duration |
| status | integer | NOT NULL, default: 0 | Class status enum |
| google_calendar_event_id | string | NULL, indexed | Google Calendar event ID |
| google_meet_link | string | NULL | Google Meet URL |
| notes | text | NULL | Class notes |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_classes_on_tutor_id`
- `index_classes_on_student_id`
- `index_classes_on_scheduled_at`
- `index_classes_on_google_calendar_event_id`
- `index_classes_on_status`

**Enums**:
```ruby
enum status: {
  scheduled: 0,
  in_progress: 1,
  completed: 2,
  cancelled: 3
}
```

**Validations**:
- `tutor_id`: presence
- `student_id`: presence
- `subject`: presence, length (2-100)
- `scheduled_at`: presence, future date (on create)
- `duration_minutes`: presence, numericality (15-240)
- `status`: presence, inclusion in enum values
- Validate tutor has role 'tutor'
- Validate student has role 'student'
- Validate no scheduling conflicts for tutor

**Associations**:
- `belongs_to :tutor, class_name: 'User'`
- `belongs_to :student, class_name: 'User'`
- `has_many :notifications, as: :notifiable`

**Scopes**:
- `upcoming`: where(status: :scheduled).where('scheduled_at > ?', Time.current)
- `past`: where(status: [:completed, :cancelled]).or(where('scheduled_at < ?', Time.current))
- `for_tutor(tutor_id)`: where(tutor_id: tutor_id)
- `for_student(student_id)`: where(student_id: student_id)

**Methods**:
- `end_time`: scheduled_at + duration_minutes.minutes
- `can_cancel?`: scheduled_at > 24.hours.from_now
- `sync_to_google_calendar`: Service object call

---

### Homework

**Purpose**: Represents a homework assignment from tutor to student

**Table**: `homeworks`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| tutor_id | bigint | NOT NULL, FK → users.id, indexed | Tutor reference |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Student reference |
| title | string | NOT NULL | Homework title |
| description | text | NOT NULL | Homework description |
| due_date | date | NOT NULL, indexed | Due date |
| status | integer | NOT NULL, default: 0 | Homework status enum |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_homeworks_on_tutor_id`
- `index_homeworks_on_student_id`
- `index_homeworks_on_due_date`
- `index_homeworks_on_status`

**Enums**:
```ruby
enum status: {
  pending: 0,
  submitted: 1,
  overdue: 2
}
```

**Validations**:
- `tutor_id`: presence
- `student_id`: presence
- `title`: presence, length (2-200)
- `description`: presence
- `due_date`: presence, future date (on create)
- `status`: presence, inclusion in enum values
- Validate tutor has role 'tutor'
- Validate student has role 'student'

**Associations**:
- `belongs_to :tutor, class_name: 'User'`
- `belongs_to :student, class_name: 'User'`
- `has_one :homework_submission, dependent: :destroy`
- `has_many :file_attachments, as: :attachable, dependent: :destroy`
- `has_many :notifications, as: :notifiable`

**Scopes**:
- `pending`: where(status: :pending)
- `overdue`: where(status: :overdue)
- `submitted`: where(status: :submitted)
- `for_tutor(tutor_id)`: where(tutor_id: tutor_id)
- `for_student(student_id)`: where(student_id: student_id)
- `due_soon`: where('due_date <= ?', 3.days.from_now).pending

**Methods**:
- `mark_overdue!`: Update status to overdue if past due_date
- `days_until_due`: (due_date - Date.current).to_i

---

### HomeworkSubmission

**Purpose**: Represents a student's submission of completed homework

**Table**: `homework_submissions`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| homework_id | bigint | NOT NULL, FK → homeworks.id, indexed, UNIQUE | Homework reference |
| submitted_at | datetime | NOT NULL, default: now | Submission timestamp |
| notes | text | NULL | Student notes |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_homework_submissions_on_homework_id` (UNIQUE)

**Validations**:
- `homework_id`: presence, uniqueness

**Associations**:
- `belongs_to :homework`
- `has_many :file_attachments, as: :attachable, dependent: :destroy`

**Methods**:
- `submitted_on_time?`: submitted_at <= homework.due_date.end_of_day

---

### FileAttachment

**Purpose**: Represents a file uploaded by tutor or student

**Table**: `file_attachments`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| attachable_type | string | NOT NULL, indexed | Polymorphic type |
| attachable_id | bigint | NOT NULL, indexed | Polymorphic ID |
| uploader_id | bigint | NOT NULL, FK → users.id, indexed | User who uploaded |
| filename | string | NOT NULL | Original filename |
| file_size | bigint | NOT NULL | File size in bytes |
| content_type | string | NOT NULL | MIME type |
| created_at | datetime | NOT NULL | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_file_attachments_on_attachable` (type, id)
- `index_file_attachments_on_uploader_id`

**Validations**:
- `attachable`: presence
- `uploader_id`: presence
- `filename`: presence
- `file_size`: presence, numericality (> 0, <= configurable max)
- `content_type`: presence, inclusion in allowed types

**Associations**:
- `belongs_to :attachable, polymorphic: true`
- `belongs_to :uploader, class_name: 'User'`
- `has_one_attached :file` (ActiveStorage)

**Scopes**:
- `for_homework`: where(attachable_type: 'Homework')
- `for_submission`: where(attachable_type: 'HomeworkSubmission')

**Methods**:
- `human_file_size`: Format bytes as KB/MB
- `downloadable_by?(user)`: Authorization check

---

### Feedback

**Purpose**: Represents tutor feedback about a student

**Table**: `feedbacks`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| tutor_id | bigint | NOT NULL, FK → users.id, indexed | Tutor reference |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Student reference |
| content | text | NOT NULL | Feedback content |
| created_at | datetime | NOT NULL, indexed | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_feedbacks_on_tutor_id`
- `index_feedbacks_on_student_id`
- `index_feedbacks_on_created_at`

**Validations**:
- `tutor_id`: presence
- `student_id`: presence
- `content`: presence, length (10-5000)
- Validate tutor has role 'tutor'
- Validate student has role 'student'

**Associations**:
- `belongs_to :tutor, class_name: 'User'`
- `belongs_to :student, class_name: 'User'`
- `has_many :messages, dependent: :destroy`
- `has_many :notifications, as: :notifiable`

**Scopes**:
- `for_tutor(tutor_id)`: where(tutor_id: tutor_id)
- `for_student(student_id)`: where(student_id: student_id)
- `recent`: order(created_at: :desc)

---

### Message

**Purpose**: Represents communication between parents and tutors

**Table**: `messages`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| feedback_id | bigint | NULL, FK → feedbacks.id, indexed | Associated feedback |
| sender_id | bigint | NOT NULL, FK → users.id, indexed | Message sender |
| recipient_id | bigint | NOT NULL, FK → users.id, indexed | Message recipient |
| student_id | bigint | NOT NULL, FK → users.id, indexed | Related student |
| content | text | NOT NULL | Message content |
| read_at | datetime | NULL | Read timestamp |
| created_at | datetime | NOT NULL, indexed | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_messages_on_feedback_id`
- `index_messages_on_sender_id`
- `index_messages_on_recipient_id`
- `index_messages_on_student_id`
- `index_messages_on_created_at`

**Validations**:
- `sender_id`: presence
- `recipient_id`: presence
- `student_id`: presence
- `content`: presence, length (1-2000)
- Validate sender is parent or tutor
- Validate recipient is parent or tutor
- Validate sender != recipient

**Associations**:
- `belongs_to :feedback, optional: true`
- `belongs_to :sender, class_name: 'User'`
- `belongs_to :recipient, class_name: 'User'`
- `belongs_to :student, class_name: 'User'`
- `has_many :notifications, as: :notifiable`

**Scopes**:
- `unread`: where(read_at: nil)
- `for_user(user_id)`: where(sender_id: user_id).or(where(recipient_id: user_id))
- `between(user1_id, user2_id)`: Complex query for conversation thread

**Methods**:
- `mark_as_read!`: Update read_at timestamp
- `unread?`: read_at.nil?

---

### Notification

**Purpose**: Represents a notification sent to a user

**Table**: `notifications`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| recipient_id | bigint | NOT NULL, FK → users.id, indexed | Recipient user |
| notifiable_type | string | NOT NULL, indexed | Polymorphic type |
| notifiable_id | bigint | NOT NULL, indexed | Polymorphic ID |
| notification_type | integer | NOT NULL, indexed | Notification type enum |
| delivery_method | integer | NOT NULL, default: 0 | Delivery method enum |
| delivery_status | integer | NOT NULL, default: 0 | Delivery status enum |
| subject | string | NOT NULL | Notification subject |
| body | text | NOT NULL | Notification body |
| sent_at | datetime | NULL | Sent timestamp |
| delivered_at | datetime | NULL | Delivered timestamp |
| failed_at | datetime | NULL | Failed timestamp |
| error_message | text | NULL | Error details |
| created_at | datetime | NOT NULL, indexed | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_notifications_on_recipient_id`
- `index_notifications_on_notifiable` (type, id)
- `index_notifications_on_notification_type`
- `index_notifications_on_delivery_status`
- `index_notifications_on_created_at`

**Enums**:
```ruby
enum notification_type: {
  class_scheduled: 0,
  class_updated: 1,
  class_cancelled: 2,
  homework_assigned: 3,
  homework_submitted: 4,
  homework_overdue: 5,
  feedback_provided: 6,
  message_received: 7,
  user_created: 8
}

enum delivery_method: {
  email: 0,
  whatsapp: 1,
  sms: 2
}

enum delivery_status: {
  pending: 0,
  sent: 1,
  delivered: 2,
  failed: 3
}
```

**Validations**:
- `recipient_id`: presence
- `notifiable`: presence
- `notification_type`: presence, inclusion in enum values
- `delivery_method`: presence, inclusion in enum values
- `delivery_status`: presence, inclusion in enum values
- `subject`: presence, length (1-200)
- `body`: presence

**Associations**:
- `belongs_to :recipient, class_name: 'User'`
- `belongs_to :notifiable, polymorphic: true`

**Scopes**:
- `pending`: where(delivery_status: :pending)
- `failed`: where(delivery_status: :failed)
- `for_user(user_id)`: where(recipient_id: user_id)
- `by_type(type)`: where(notification_type: type)

**Methods**:
- `mark_as_sent!`: Update sent_at and status
- `mark_as_delivered!`: Update delivered_at and status
- `mark_as_failed!(error)`: Update failed_at, error_message, and status
- `retry!`: Reset status to pending for retry

---

### ContactFormSubmission

**Purpose**: Represents a submission from the public contact form

**Table**: `contact_form_submissions`

**Columns**:
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | bigint | PK, auto-increment | Primary key |
| name | string | NOT NULL | Visitor name |
| email | string | NOT NULL | Visitor email |
| phone | string | NULL | Visitor phone |
| message | text | NOT NULL | Message content |
| whatsapp_sent | boolean | NOT NULL, default: false | WhatsApp delivery status |
| whatsapp_sent_at | datetime | NULL | WhatsApp sent timestamp |
| whatsapp_error | text | NULL | WhatsApp error details |
| created_at | datetime | NOT NULL, indexed | Record creation timestamp |
| updated_at | datetime | NOT NULL | Record update timestamp |

**Indexes**:
- `index_contact_form_submissions_on_created_at`
- `index_contact_form_submissions_on_whatsapp_sent`

**Validations**:
- `name`: presence, length (2-100)
- `email`: presence, format (email regex)
- `phone`: format (international phone), allow_blank
- `message`: presence, length (10-2000)

**Associations**: None

**Scopes**:
- `pending_whatsapp`: where(whatsapp_sent: false)
- `recent`: order(created_at: :desc)

**Methods**:
- `mark_whatsapp_sent!`: Update whatsapp_sent and timestamp
- `mark_whatsapp_failed!(error)`: Update error message

---

## State Transitions

### Class Status Flow

```
scheduled → in_progress → completed
    ↓
cancelled
```

- **scheduled**: Initial state when class is created
- **in_progress**: When class start time arrives (optional manual trigger)
- **completed**: After class ends (manual or automatic)
- **cancelled**: Can cancel from scheduled state only

### Homework Status Flow

```
pending → submitted
   ↓
overdue
```

- **pending**: Initial state when homework is assigned
- **submitted**: When student submits homework
- **overdue**: Automatically set by background job if past due_date without submission

### Notification Delivery Flow

```
pending → sent → delivered
    ↓
  failed (can retry → pending)
```

- **pending**: Initial state when notification is created
- **sent**: After notification is sent to delivery service
- **delivered**: Confirmed delivery (if supported by service)
- **failed**: Delivery failed, can be retried

## Data Integrity Rules

### Database Constraints

1. **Foreign Keys**: All foreign keys have `ON DELETE` actions:
   - User deletions: `CASCADE` for owned records, `RESTRICT` for referenced records
   - Soft deletes preferred over hard deletes for users

2. **Unique Constraints**:
   - User email (case-insensitive)
   - Student-Tutor pairs
   - Parent-Student pairs
   - Homework submission per homework

3. **Check Constraints**:
   - Class duration: 15-240 minutes
   - File size: 0 < size <= configured max
   - Dates: scheduled_at, due_date must be valid dates

### Application-Level Validations

1. **Role Validations**:
   - Students can only be assigned to tutors
   - Parents can only be linked to students
   - Tutors can only create classes and homework

2. **Business Rules**:
   - No double-booking: Tutor cannot have overlapping classes
   - Homework due date must be future date on creation
   - File uploads must match allowed content types
   - Notifications must have valid recipient email

## Performance Considerations

### Indexes Strategy

- **Primary lookups**: id (automatic)
- **Foreign keys**: All foreign keys indexed
- **Common queries**: role, status, dates, email
- **Soft deletes**: deleted_at indexed
- **Polymorphic**: (type, id) composite indexes

### Query Optimization

- Use `includes` for N+1 prevention
- Implement counter caches for counts
- Use database views for complex reports
- Paginate large result sets
- Cache expensive queries (Redis)

### Data Volume Estimates

- **Users**: ~1000 (50 tutors, 500 students, 300 parents, 150 admins)
- **Classes**: ~50,000/year (50 tutors × 20 classes/week × 50 weeks)
- **Homework**: ~25,000/year (50 tutors × 10 assignments/week × 50 weeks)
- **Notifications**: ~500,000/year (10 notifications/class + homework)
- **Messages**: ~10,000/year (parent-tutor communication)
- **Files**: ~50,000/year (homework attachments)

## Migration Strategy

### Phase 1: Core Tables
1. users
2. student_tutors, parent_students
3. classes
4. homeworks, homework_submissions
5. file_attachments

### Phase 2: Communication
6. feedbacks
7. messages
8. notifications

### Phase 3: Public Site
9. contact_form_submissions

### Rollback Plan

- All migrations must be reversible
- Test rollback in development before production
- Keep data backups before major migrations
- Use database transactions for multi-step migrations

## Next Steps

Data model complete. Proceed to:
1. Generate API contracts (contracts/)
2. Create quickstart guide (quickstart.md)
3. Update agent context files
