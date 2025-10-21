# Implementation Tasks: Rails Tutoring Platform Rewrite

**Feature**: 001-rails-tutoring-platform  
**Branch**: `001-rails-tutoring-platform`  
**Generated**: 2025-10-20  
**Total Tasks**: 147

## Overview

This document provides a complete, dependency-ordered task breakdown for implementing the Rails tutoring platform rewrite. Tasks are organized by user story priority (P1, P2, P3) following TDD principles with tests written before implementation.

## Implementation Strategy

**MVP Scope**: User Stories 1-2 (Public Site + Authentication)  
**Incremental Delivery**: Each user story is independently testable  
**TDD Approach**: Write tests before implementation for all features

## Task Phases

- **Phase 1**: Setup & Infrastructure (Tasks T001-T015)
- **Phase 2**: Foundational (Tasks T016-T025)
- **Phase 3**: User Story 1 - Public Marketing Site (Tasks T026-T040) [P1]
- **Phase 4**: User Story 2 - User Authentication (Tasks T041-T055) [P1]
- **Phase 5**: User Story 9 - Administrator User Management (Tasks T056-T075) [P2]
- **Phase 6**: User Story 3 - Tutor Student Management (Tasks T076-T085) [P2]
- **Phase 7**: User Story 4 - Class Scheduling with Google Calendar (Tasks T086-T105) [P2]
- **Phase 8**: User Story 5 - Homework Assignment and Submission (Tasks T106-T125) [P2]
- **Phase 9**: User Story 6 - Tutor Feedback to Parents (Tasks T126-T135) [P3]
- **Phase 10**: User Story 7 - Student Class Access (Tasks T136-T140) [P3]
- **Phase 11**: User Story 8 - Parent Dashboard Overview (Tasks T141-T145) [P3]
- **Phase 12**: Polish & Cross-Cutting Concerns (Tasks T146-T147)

---

## Phase 1: Setup & Infrastructure

**Goal**: Initialize Rails 8 project with all required dependencies and configuration

### Tasks

- [X] T001 Initialize new Rails 8.0 application with SQLite3 database
- [X] T002 Add vite_rails gem to Gemfile and run bundle install
- [X] T003 Run vite_rails installer: `bundle exec vite install`
- [X] T004 Install Vite and frontend dependencies: `npm install -D vite @tailwindcss/vite tailwindcss@latest daisyui@latest`
- [X] T005 Install Alpine.js and alpine-ajax: `npm install alpinejs @imacrayon/alpine-ajax`
- [X] T006 Configure vite.config.ts with RubyPlugin and tailwindcss plugin
- [X] T007 Create app/frontend/stylesheets/application.css with Tailwind CSS 4 imports and DaisyUI plugin
- [X] T008 Create app/frontend/entrypoints/application.js with Alpine.js initialization
- [X] T009 Update app/views/layouts/application.html.erb with vite_client_tag, vite_stylesheet_tag, and vite_javascript_tag helpers
- [X] T010 Add RSpec, FactoryBot, Capybara, and related testing gems to Gemfile
- [X] T011 Run RSpec installer: `rails generate rspec:install`
- [X] T012 Configure RSpec with FactoryBot support in spec/rails_helper.rb
- [X] T013 Add Devise gem to Gemfile and run bundle install
- [X] T014 Add Pundit gem to Gemfile and run bundle install
- [X] T015 Create .gitignore with Rails, Node.js, and IDE patterns

---

## Phase 2: Foundational

**Goal**: Set up core infrastructure needed by all user stories

### Tasks

- [X] T016 Run Devise generator: `rails generate devise:install`
- [X] T017 Configure Devise in config/initializers/devise.rb
- [X] T018 Generate User model with Devise: `rails generate devise User`
- [X] T019 Add role enum, first_name, last_name, phone_number, active, deleted_at columns to users migration
- [X] T020 Add indexes for email, role, deleted_at to users migration
- [X] T021 Run database migration: `rails db:migrate`
- [X] T022 Add role enum to app/models/user.rb with values: parent(0), student(1), tutor(2), administrator(3)
- [X] T023 Add validations to app/models/user.rb for first_name, last_name, email, role
- [X] T024 Add full_name method to app/models/user.rb returning "#{first_name} #{last_name}"
- [X] T025 [P] Create CSS component classes in app/assets/stylesheets/components/ (buttons.css, cards.css, forms.css, badges.css, dashboard.css)

---

## Phase 3: User Story 1 - Public Marketing Site (P1)

**Goal**: Create public marketing site with contact form that sends WhatsApp messages

**Independent Test**: Navigate to public website, view marketing content, submit contact form, verify WhatsApp message sent

### Tests

- [X] T026 [US1] Write request spec for GET / (homepage) in spec/requests/public/pages_spec.rb
- [X] T027 [US1] Write request spec for GET /about in spec/requests/public/pages_spec.rb
- [X] T028 [US1] Write request spec for GET /services in spec/requests/public/pages_spec.rb
- [X] T029 [US1] Write request spec for GET /contact in spec/requests/public/pages_spec.rb
- [X] T030 [US1] Write request spec for POST /contact with valid data in spec/requests/public/contact_forms_spec.rb
- [X] T031 [US1] Write service spec for WhatsApp message sending in spec/services/whatsapp/send_message_service_spec.rb

### Implementation

- [X] T032 [US1] Create Public::PagesController in app/controllers/public/pages_controller.rb with actions: home, about, services, contact
- [X] T033 [US1] Create routes for public pages in config/routes.rb (root, about, services, contact)
- [X] T034 [US1] Create view app/views/public/pages/home.html.erb with marketing content
- [X] T035 [US1] Create view app/views/public/pages/about.html.erb
- [X] T036 [US1] Create view app/views/public/pages/services.html.erb
- [X] T037 [US1] Create view app/views/public/pages/contact.html.erb with contact form
- [X] T038 [US1] Create ContactFormSubmission model with migration in app/models/contact_form_submission.rb
- [X] T039 [US1] Create Public::ContactFormsController in app/controllers/public/contact_forms_controller.rb with create action
- [X] T040 [US1] Create Whatsapp::SendMessageService in app/services/whatsapp/send_message_service.rb to send WhatsApp messages via Twilio API

---

## Phase 4: User Story 2 - User Authentication (P1)

**Goal**: Implement role-based authentication with role-specific dashboards

**Independent Test**: Admin creates user, user logs in with credentials, redirected to role-appropriate dashboard

### Tests

- [X] T041 [US2] Write request spec for GET /login in spec/requests/auth/sessions_spec.rb
- [X] T042 [US2] Write request spec for POST /login with valid credentials in spec/requests/auth/sessions_spec.rb
- [X] T043 [US2] Write request spec for POST /login with invalid credentials in spec/requests/auth/sessions_spec.rb
- [X] T044 [US2] Write request spec for DELETE /logout in spec/requests/auth/sessions_spec.rb
- [X] T045 [US2] Write request spec for accessing protected page without authentication in spec/requests/auth/authorization_spec.rb
- [X] T046 [US2] Write Pundit policy spec for User in spec/policies/user_policy_spec.rb

### Implementation

- [X] T047 [US2] Generate Devise views: `rails generate devise:views`
- [X] T048 [US2] Customize app/views/devise/sessions/new.html.erb with DaisyUI styling
- [X] T049 [US2] Create ApplicationController concern for role-based redirects in app/controllers/concerns/role_redirectable.rb
- [X] T050 [US2] Override after_sign_in_path_for in ApplicationController to redirect based on user role
- [X] T051 [US2] Create Tutors::DashboardController in app/controllers/tutors/dashboard_controller.rb with index action
- [X] T052 [US2] Create Students::DashboardController in app/controllers/students/dashboard_controller.rb with index action
- [X] T053 [US2] Create Parents::DashboardController in app/controllers/parents/dashboard_controller.rb with index action
- [X] T054 [US2] Create Admin::DashboardController in app/controllers/admin/dashboard_controller.rb with index action
- [X] T055 [US2] Create dashboard views for each role (tutors, students, parents, admin) with placeholder content

---

## Phase 5: User Story 9 - Administrator User Management (P2)

**Goal**: Admins can create users, assign roles, manage relationships

**Independent Test**: Admin logs in, creates users of different types, assigns relationships, new users can log in

### Tests

- [ ] T056 [US9] Write request spec for GET /admin/users in spec/requests/admin/users_spec.rb
- [ ] T057 [US9] Write request spec for GET /admin/users/new in spec/requests/admin/users_spec.rb
- [ ] T058 [US9] Write request spec for POST /admin/users with valid data in spec/requests/admin/users_spec.rb
- [ ] T059 [US9] Write request spec for PATCH /admin/users/:id in spec/requests/admin/users_spec.rb
- [ ] T060 [US9] Write request spec for DELETE /admin/users/:id (soft delete) in spec/requests/admin/users_spec.rb
- [ ] T061 [US9] Write request spec for POST /admin/student_tutors in spec/requests/admin/student_tutors_spec.rb
- [ ] T062 [US9] Write request spec for POST /admin/parent_students in spec/requests/admin/parent_students_spec.rb
- [ ] T063 [US9] Write factory for User in spec/factories/users.rb with traits for each role
- [ ] T064 [US9] Write model spec for StudentTutor in spec/models/student_tutor_spec.rb
- [ ] T065 [US9] Write model spec for ParentStudent in spec/models/parent_student_spec.rb

### Implementation

- [ ] T066 [US9] Create StudentTutor join model with migration in app/models/student_tutor.rb
- [ ] T067 [US9] Create ParentStudent join model with migration in app/models/parent_student.rb
- [ ] T068 [US9] Add has_many associations to User model for student_tutors, parent_students, tutors, students, parents
- [ ] T069 [US9] Create Admin::UsersController in app/controllers/admin/users_controller.rb with CRUD actions
- [ ] T070 [US9] Create Admin::StudentTutorsController in app/controllers/admin/student_tutors_controller.rb
- [ ] T071 [US9] Create Admin::ParentStudentsController in app/controllers/admin/parent_students_controller.rb
- [ ] T072 [US9] Create views for admin user management in app/views/admin/users/
- [ ] T073 [US9] Create UserPolicy in app/policies/user_policy.rb with role-based authorization
- [ ] T074 [US9] Create SendCredentialsJob in app/jobs/send_credentials_job.rb for email notifications
- [ ] T075 [US9] Create UserMailer in app/mailers/user_mailer.rb with credentials_email method

---

## Phase 6: User Story 3 - Tutor Student Management (P2)

**Goal**: Tutors can view assigned students and their information

**Independent Test**: Log in as tutor, view list of assigned students, see student details

### Tests

- [ ] T076 [US3] Write request spec for GET /tutors/students in spec/requests/tutors/students_spec.rb
- [ ] T077 [US3] Write request spec for GET /tutors/students/:id in spec/requests/tutors/students_spec.rb

### Implementation

- [ ] T078 [US3] Create Tutors::StudentsController in app/controllers/tutors/students_controller.rb with index and show actions
- [ ] T079 [US3] Update Tutors::DashboardController to load assigned students
- [ ] T080 [US3] Create view app/views/tutors/students/index.html.erb to list assigned students
- [ ] T081 [US3] Create view app/views/tutors/students/show.html.erb for student details
- [ ] T082 [US3] Create student card component CSS in app/assets/stylesheets/components/cards.css
- [ ] T083 [US3] Update tutors dashboard view to display assigned students
- [ ] T084 [US3] Add authorization check in Tutors::StudentsController to ensure tutor can only view assigned students
- [ ] T085 [US3] Create StudentPolicy in app/policies/student_policy.rb

---

## Phase 7: User Story 4 - Class Scheduling with Google Calendar (P2)

**Goal**: Tutors schedule classes with Google Calendar sync, Meet links, and notifications

**Independent Test**: Tutor views Google Calendar, creates class without conflicts, verifies sync and Meet link, students/parents see class, email notifications sent

### Tests

- [ ] T086 [US4] Write request spec for GET /tutors/classes in spec/requests/tutors/classes_spec.rb
- [ ] T087 [US4] Write request spec for GET /tutors/classes/new in spec/requests/tutors/classes_spec.rb
- [ ] T088 [US4] Write request spec for POST /tutors/classes with valid data in spec/requests/tutors/classes_spec.rb
- [ ] T089 [US4] Write request spec for PATCH /tutors/classes/:id in spec/requests/tutors/classes_spec.rb
- [ ] T090 [US4] Write request spec for DELETE /tutors/classes/:id in spec/requests/tutors/classes_spec.rb
- [ ] T091 [US4] Write model spec for Class in spec/models/class_spec.rb
- [ ] T092 [US4] Write service spec for GoogleCalendar::CreateEventService in spec/services/google_calendar/create_event_service_spec.rb
- [ ] T093 [US4] Write service spec for GoogleCalendar::UpdateEventService in spec/services/google_calendar/update_event_service_spec.rb
- [ ] T094 [US4] Write service spec for GoogleCalendar::DeleteEventService in spec/services/google_calendar/delete_event_service_spec.rb
- [ ] T095 [US4] Write factory for Class in spec/factories/classes.rb

### Implementation

- [ ] T096 [US4] Create Class model with migration in app/models/class.rb (tutor_id, student_id, subject, scheduled_at, duration_minutes, status, google_calendar_event_id, google_meet_link, notes)
- [ ] T097 [US4] Add validations and associations to Class model
- [ ] T098 [US4] Add status enum to Class model: scheduled(0), in_progress(1), completed(2), cancelled(3)
- [ ] T099 [US4] Create Tutors::ClassesController in app/controllers/tutors/classes_controller.rb with CRUD actions
- [ ] T100 [US4] Create GoogleCalendar::CreateEventService in app/services/google_calendar/create_event_service.rb
- [ ] T101 [US4] Create GoogleCalendar::UpdateEventService in app/services/google_calendar/update_event_service.rb
- [ ] T102 [US4] Create GoogleCalendar::DeleteEventService in app/services/google_calendar/delete_event_service.rb
- [ ] T103 [US4] Create views for class management in app/views/tutors/classes/
- [ ] T104 [US4] Create SendClassNotificationJob in app/jobs/send_class_notification_job.rb
- [ ] T105 [US4] Add Google Calendar OAuth configuration to config/credentials.yml.enc

---

## Phase 8: User Story 5 - Homework Assignment and Submission (P2)

**Goal**: Tutors assign homework with files, students submit with files, parents view, notifications sent

**Independent Test**: Tutor assigns homework with attachments, student uploads completed work, parent views both, all parties receive email notifications

### Tests

- [ ] T106 [US5] Write request spec for GET /tutors/homework in spec/requests/tutors/homework_spec.rb
- [ ] T107 [US5] Write request spec for POST /tutors/homework with file attachments in spec/requests/tutors/homework_spec.rb
- [ ] T108 [US5] Write request spec for POST /students/homework/:id/submit with files in spec/requests/students/homework_spec.rb
- [ ] T109 [US5] Write model spec for Homework in spec/models/homework_spec.rb
- [ ] T110 [US5] Write model spec for HomeworkSubmission in spec/models/homework_submission_spec.rb
- [ ] T111 [US5] Write factory for Homework in spec/factories/homework.rb
- [ ] T112 [US5] Write factory for HomeworkSubmission in spec/factories/homework_submissions.rb

### Implementation

- [ ] T113 [US5] Configure ActiveStorage: `rails active_storage:install` and run migration
- [ ] T114 [US5] Create Homework model with migration in app/models/homework.rb (tutor_id, student_id, title, description, due_date, status)
- [ ] T115 [US5] Add status enum to Homework model: pending(0), submitted(1), overdue(2)
- [ ] T116 [US5] Add has_many_attached :files to Homework model for tutor attachments
- [ ] T117 [US5] Create HomeworkSubmission model with migration in app/models/homework_submission.rb (homework_id, submitted_at, notes)
- [ ] T118 [US5] Add has_many_attached :files to HomeworkSubmission model for student uploads
- [ ] T119 [US5] Create Tutors::HomeworkController in app/controllers/tutors/homework_controller.rb
- [ ] T120 [US5] Create Students::HomeworkController in app/controllers/students/homework_controller.rb with submit action
- [ ] T121 [US5] Create views for homework management in app/views/tutors/homework/
- [ ] T122 [US5] Create views for homework submission in app/views/students/homework/
- [ ] T123 [US5] Create MarkHomeworkOverdueJob in app/jobs/mark_homework_overdue_job.rb (scheduled daily)
- [ ] T124 [US5] Create SendHomeworkNotificationJob in app/jobs/send_homework_notification_job.rb
- [ ] T125 [US5] Add file upload validation (size, type) to Homework and HomeworkSubmission models

---

## Phase 9: User Story 6 - Tutor Feedback to Parents (P3)

**Goal**: Tutors provide feedback, parents view and respond, notifications sent

**Independent Test**: Tutor submits feedback, parent views and responds, both receive email notifications

### Tests

- [ ] T126 [US6] Write request spec for POST /tutors/feedback in spec/requests/tutors/feedback_spec.rb
- [ ] T127 [US6] Write request spec for POST /parents/messages in spec/requests/parents/messages_spec.rb
- [ ] T128 [US6] Write model spec for Feedback in spec/models/feedback_spec.rb
- [ ] T129 [US6] Write model spec for Message in spec/models/message_spec.rb

### Implementation

- [ ] T130 [US6] Create Feedback model with migration in app/models/feedback.rb (tutor_id, student_id, content)
- [ ] T131 [US6] Create Message model with migration in app/models/message.rb (feedback_id, sender_id, recipient_id, student_id, content, read_at)
- [ ] T132 [US6] Create Tutors::FeedbackController in app/controllers/tutors/feedback_controller.rb
- [ ] T133 [US6] Create Parents::MessagesController in app/controllers/parents/messages_controller.rb
- [ ] T134 [US6] Create views for feedback and messaging in app/views/tutors/feedback/ and app/views/parents/messages/
- [ ] T135 [US6] Create SendFeedbackNotificationJob in app/jobs/send_feedback_notification_job.rb

---

## Phase 10: User Story 7 - Student Class Access (P3)

**Goal**: Students view classes and homework in their dashboard

**Independent Test**: Log in as student, view classes with Meet links, view homework

### Tests

- [ ] T136 [US7] Write request spec for GET /students/classes in spec/requests/students/classes_spec.rb
- [ ] T137 [US7] Write request spec for GET /students/homework in spec/requests/students/homework_spec.rb

### Implementation

- [ ] T138 [US7] Create Students::ClassesController in app/controllers/students/classes_controller.rb with index action
- [ ] T139 [US7] Create views for student class access in app/views/students/classes/
- [ ] T140 [US7] Update Students::DashboardController to show upcoming classes and homework

---

## Phase 11: User Story 8 - Parent Dashboard Overview (P3)

**Goal**: Parents view comprehensive child information

**Independent Test**: Log in as parent, view all child information (classes, homework, feedback)

### Tests

- [ ] T141 [US8] Write request spec for GET /parents/children/:id in spec/requests/parents/children_spec.rb
- [ ] T142 [US8] Write request spec for parent with multiple children in spec/requests/parents/children_spec.rb

### Implementation

- [ ] T143 [US8] Create Parents::ChildrenController in app/controllers/parents/children_controller.rb
- [ ] T144 [US8] Create views for parent child overview in app/views/parents/children/
- [ ] T145 [US8] Update Parents::DashboardController to support multiple children

---

## Phase 12: Polish & Cross-Cutting Concerns

**Goal**: Final touches, optimization, documentation

### Tasks

- [ ] T146 Create Notification model with migration for tracking all email notifications (notification_type, recipient_id, notifiable_type, notifiable_id, delivery_method, delivery_status, subject, body)
- [ ] T147 Add comprehensive error handling and logging throughout application

---

## Dependencies

### User Story Completion Order

```
Phase 1 (Setup) → Phase 2 (Foundational) → Phase 3 (US1) → Phase 4 (US2) → Phase 5 (US9)
                                                                              ↓
Phase 6 (US3) ← Phase 7 (US4) ← Phase 8 (US5) ← Phase 9 (US6) ← Phase 10 (US7) ← Phase 11 (US8)
     ↓
Phase 12 (Polish)
```

### Critical Path

1. **Setup & Foundational** (T001-T025) - Must complete before any user stories
2. **US1 + US2** (T026-T055) - MVP: Public site + Authentication
3. **US9** (T056-T075) - Required before users can be created
4. **US3** (T076-T085) - Required before tutors can manage students
5. **US4, US5** (T086-T125) - Core tutoring functionality
6. **US6, US7, US8** (T126-T145) - Enhanced features
7. **Polish** (T146-T147) - Final touches

### Parallel Opportunities

Within each phase, tasks marked [P] can be executed in parallel if they affect different files:

**Phase 1**: T001-T015 are mostly sequential (dependencies on previous steps)
**Phase 2**: T025 can run parallel with T016-T024
**Phase 3**: T026-T031 (tests) can all run in parallel, T032-T040 (implementation) are sequential
**Phase 4**: T041-T046 (tests) can all run in parallel
**Phase 5**: T056-T065 (tests) can all run in parallel
**Phase 6**: T076-T077 (tests) can run in parallel
**Phase 7**: T086-T095 (tests) can all run in parallel
**Phase 8**: T106-T112 (tests) can all run in parallel
**Phase 9**: T126-T129 (tests) can all run in parallel
**Phase 10**: T136-T137 (tests) can run in parallel
**Phase 11**: T141-T142 (tests) can run in parallel

---

## Execution Notes

1. **TDD Approach**: All test tasks must pass before proceeding to implementation tasks in the same phase
2. **Database Migrations**: Run `rails db:migrate` after creating each migration
3. **Credentials**: Configure Google Calendar API and Twilio WhatsApp API credentials before Phase 7 and Phase 3 respectively
4. **File Uploads**: Configure ActiveStorage before Phase 8
5. **Background Jobs**: Solid Queue runs automatically with Rails server in development
6. **Asset Compilation**: Run `bin/vite dev` for HMR during development

---

## Task Completion Tracking

Mark tasks as complete using `[X]` instead of `[ ]` as you finish them.

**Progress**: 0/147 tasks completed (0%)
