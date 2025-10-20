# Feature Specification: Rails Tutoring Platform Rewrite

**Feature Branch**: `001-rails-tutoring-platform`  
**Created**: 2025-10-20  
**Status**: Ready for Planning  
**Input**: User description: "Using https://smarty-pants-tutoring.com This site needs to be rewritten in Ruby on Rails, and a new admin frontend added for both tutors and students. We will start by replicating the public pages, then move to adding missing functionality."

## Clarifications

### Session 2025-10-20

- Q: Can tutors attach files when creating homework assignments? → A: Yes, tutors may upload files as part of the homework assignment (User Story 5/6)
- Q: Should the system send notifications when actions are completed? → A: Yes, email notifications initially with future expansion to WhatsApp and other platforms for all completed actions
- Q: What visibility should tutors have of their Google Calendar when scheduling? → A: Tutors can view their current Google Calendar to avoid double-booking themselves

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Public Marketing Site Access (Priority: P1)

A prospective parent or student visits the Smarty Pants Tutoring website to learn about the tutoring services offered. They browse information about subjects (Mathematics, English, Afrikaans, Science), curriculum support (CAPS, IEB, Cambridge), and can submit a contact/feedback form to reach the tutoring company.

**Why this priority**: This is the primary entry point for all new customers. Without the public marketing site, the business cannot attract new clients. It represents the minimum viable product that delivers immediate value by establishing online presence.

**Independent Test**: Can be fully tested by navigating to the public website, viewing all marketing content, and successfully submitting a contact form that sends a WhatsApp message to the configured number.

**Acceptance Scenarios**:

1. **Given** a visitor lands on the homepage, **When** they view the page, **Then** they see information about tutoring services, subjects offered, and curriculum types supported
2. **Given** a visitor is on the contact page, **When** they fill out the contact form with their name, contact details, and message, **Then** a WhatsApp message is sent to the configured business number
3. **Given** a visitor browses the site, **When** they view any page, **Then** the content matches the existing site's marketing information and branding
4. **Given** a visitor wants to sign up, **When** they click the login/sign-up button, **Then** they are directed to an authentication page

---

### User Story 2 - User Authentication (Priority: P1)

Users (parents, students, tutors, administrators) can log into the system using credentials created by administrators. The system recognizes different user types and directs them to appropriate dashboards after successful authentication.

**Why this priority**: Authentication is the gateway to all personalized functionality. Without it, no role-specific features can be accessed. This is essential infrastructure that must be in place before any admin features can be used.

**Independent Test**: Can be fully tested by an administrator creating a user account, then that user logging in with their credentials and being directed to their role-appropriate dashboard.

**Acceptance Scenarios**:

1. **Given** a user has valid credentials, **When** they enter their username and password, **Then** they are authenticated and redirected to their role-specific dashboard
2. **Given** a user enters invalid credentials, **When** they attempt to login, **Then** they see an error message and remain on the login page
3. **Given** a user is authenticated, **When** they navigate to protected pages, **Then** they can access content appropriate to their role
4. **Given** an unauthenticated user, **When** they attempt to access protected pages, **Then** they are redirected to the login page

---

### User Story 3 - Tutor Student Management (Priority: P2)

A tutor logs into their dashboard and views all students assigned to them. They can see student information, upcoming classes, and access student-specific functions like assigning homework and providing feedback.

**Why this priority**: This is the core functionality for tutors to manage their teaching activities. It enables the primary business function of coordinating tutoring sessions and tracking student progress.

**Independent Test**: Can be fully tested by logging in as a tutor, viewing the list of assigned students, and verifying that all student information is displayed correctly.

**Acceptance Scenarios**:

1. **Given** a tutor is logged in, **When** they view their dashboard, **Then** they see a list of all students assigned to them
2. **Given** a tutor views their student list, **When** they select a student, **Then** they see detailed information about that student including upcoming classes and homework status
3. **Given** a tutor has no assigned students, **When** they view their dashboard, **Then** they see a message indicating no students are currently assigned

---

### User Story 4 - Class Scheduling with Google Calendar Integration (Priority: P2)

A tutor creates a new class/meeting on their calendar while viewing their existing Google Calendar events to avoid double-booking. The system integrates with their Google Calendar, and the class automatically creates a Google Meet link for online sessions. Students and parents receive email notifications and can see these scheduled classes in their respective dashboards.

**Why this priority**: Scheduling is essential for coordinating tutoring sessions. Google Calendar integration reduces duplicate data entry, prevents scheduling conflicts, and ensures tutors can manage their schedule from familiar tools.

**Independent Test**: Can be fully tested by a tutor viewing their Google Calendar, creating a class without conflicts, verifying it appears in their Google Calendar with a Meet link, confirming students/parents see the class in their dashboards, and verifying email notifications are sent.

**Acceptance Scenarios**:

1. **Given** a tutor is on the scheduling page, **When** they view the page, **Then** they can see their existing Google Calendar events to identify available time slots
2. **Given** a tutor is on the scheduling page, **When** they create a new class with date, time, and assigned student, **Then** the class is saved, appears in their dashboard, and an email notification is sent to the student and parent
3. **Given** a tutor creates a class, **When** the class is saved, **Then** it automatically syncs to their Google Calendar
4. **Given** a class is created with Google Calendar integration, **When** the class is saved, **Then** a Google Meet link is automatically generated and associated with the class
5. **Given** a class is scheduled for a student, **When** the student or their parent logs in, **Then** they see the upcoming class in their dashboard
6. **Given** a tutor modifies a scheduled class, **When** they save changes, **Then** the updates sync to Google Calendar, are reflected in student/parent dashboards, and email notifications are sent to affected parties

---

### User Story 5 - Homework Assignment and Submission (Priority: P2)

A tutor assigns homework to a student with description, due date, and optional file attachments (e.g., worksheets, reading materials). The student receives an email notification and can view assigned homework, upload completed work, and mark it as submitted. Parents can view their child's homework assignments and submission status, and receive notifications when homework is assigned or submitted.

**Why this priority**: Homework management is a key differentiator for the tutoring service, enabling asynchronous learning and progress tracking between sessions.

**Independent Test**: Can be fully tested by a tutor assigning homework with attachments, a student uploading completed work, and a parent viewing both the assignment and submission while verifying all parties receive appropriate email notifications.

**Acceptance Scenarios**:

1. **Given** a tutor is viewing a student's profile, **When** they create a homework assignment with description, due date, and optional file attachments, **Then** the homework is saved, visible to the student, and an email notification is sent to the student and parent
2. **Given** a student has assigned homework, **When** they log in, **Then** they see all pending and completed homework assignments with any tutor-provided attachments available for download
3. **Given** a student views a homework assignment, **When** they upload a file and mark it as complete, **Then** the submission is recorded, visible to the tutor and parent, and an email notification is sent to the tutor and parent
4. **Given** a parent logs in, **When** they view their child's profile, **Then** they see all homework assignments with tutor attachments and submission status
5. **Given** homework has a due date, **When** the due date passes without submission, **Then** the homework is marked as overdue in all relevant dashboards and an email notification is sent to the parent and tutor

---

### User Story 6 - Tutor Feedback to Parents (Priority: P3)

A tutor provides feedback about a student's progress, behavior, or session notes. Parents receive an email notification and can view this feedback in their dashboard and respond with messages to the tutor. The tutor receives email notifications when parents respond.

**Why this priority**: Feedback enables communication between tutors and parents, building trust and keeping parents informed about their child's progress. This is important for customer satisfaction but not critical for basic operations.

**Independent Test**: Can be fully tested by a tutor submitting feedback for a student, a parent viewing that feedback and responding, and verifying both parties receive appropriate email notifications.

**Acceptance Scenarios**:

1. **Given** a tutor is viewing a student's profile, **When** they write and submit feedback, **Then** the feedback is saved, visible to the student's parent, and an email notification is sent to the parent
2. **Given** a parent logs in, **When** they view their child's profile, **Then** they see all feedback provided by the tutor in chronological order
3. **Given** a parent views tutor feedback, **When** they write a response message, **Then** the message is delivered to the tutor, visible in the tutor's dashboard, and an email notification is sent to the tutor

---

### User Story 7 - Student Class Access and Homework View (Priority: P3)

A student logs into their dashboard to view upcoming classes. If a class has a Google Meet link, they can click to join the online session. They can also view all assigned homework and their submission history.

**Why this priority**: This provides students with autonomy to manage their own learning schedule and homework. While valuable, it's less critical than tutor and parent functionality since tutors can communicate class details directly.

**Independent Test**: Can be fully tested by logging in as a student, viewing upcoming classes, clicking a Google Meet link, and viewing homework assignments.

**Acceptance Scenarios**:

1. **Given** a student is logged in, **When** they view their dashboard, **Then** they see all upcoming classes with date, time, and subject
2. **Given** a class has a Google Meet link, **When** the student clicks on the class, **Then** they can access the Meet link to join the session
3. **Given** a student views their homework section, **When** they navigate to homework, **Then** they see all assigned homework with due dates and submission status
4. **Given** a student has uploaded homework, **When** they view the assignment, **Then** they can see their submitted files and submission timestamp

---

### User Story 8 - Parent Dashboard Overview (Priority: P3)

A parent logs in to view a comprehensive overview of their child's tutoring activities, including upcoming classes, homework assignments, homework submissions, and tutor feedback. They have full visibility without being intrusive.

**Why this priority**: This empowers parents to stay informed about their child's education while respecting the student's learning space. It's important for customer satisfaction but not critical for core tutoring operations.

**Independent Test**: Can be fully tested by logging in as a parent and verifying all child-related information (classes, homework, feedback) is visible and accurate.

**Acceptance Scenarios**:

1. **Given** a parent is logged in, **When** they view their dashboard, **Then** they see their child's upcoming classes, recent homework assignments, and latest tutor feedback
2. **Given** a parent views homework assignments, **When** they check submission status, **Then** they can see whether homework is pending, submitted, or overdue
3. **Given** a parent wants detailed information, **When** they click on a class or homework item, **Then** they see full details including descriptions, dates, and any associated files
4. **Given** a parent has multiple children enrolled, **When** they log in, **Then** they can switch between children's profiles to view each child's information separately

---

### User Story 9 - Administrator User Management (Priority: P2)

An administrator (or secretary) creates user accounts for parents, students, and tutors. They assign roles, set initial credentials, and manage user relationships (e.g., linking parents to students, assigning students to tutors). New users receive email notifications with their login credentials.

**Why this priority**: User management is essential infrastructure that enables all other functionality. Without it, no users can be onboarded. This must be available early but can be implemented after authentication is working.

**Independent Test**: Can be fully tested by logging in as an administrator, creating users of different types, assigning relationships, verifying those users can log in with their credentials, and confirming email notifications are sent.

**Acceptance Scenarios**:

1. **Given** an administrator is logged in, **When** they navigate to user management, **Then** they can create new user accounts with role selection (parent, student, tutor, administrator)
2. **Given** an administrator creates a user, **When** they save the user, **Then** the user receives credentials via email notification and can log into the system
3. **Given** an administrator is managing users, **When** they assign a student to a tutor, **Then** the student appears in the tutor's dashboard and both parties receive email notifications
4. **Given** an administrator is managing users, **When** they link a parent to a student, **Then** the parent can view that student's information in their dashboard and both parties receive email notifications
5. **Given** an administrator needs to modify user details, **When** they edit a user account, **Then** the changes are saved, reflected immediately in the system, and an email notification is sent to the affected user

---

### Edge Cases

- What happens when a tutor tries to schedule a class outside their Google Calendar availability?
- How does the system handle WhatsApp message delivery failures from the contact form?
- What happens when a student uploads a very large homework file (e.g., >50MB)?
- How does the system handle a parent linked to multiple students with different tutors?
- What happens when Google Calendar integration fails or loses authentication?
- How does the system handle timezone differences for international students?
- What happens when a tutor assigns homework to a student who is no longer assigned to them?
- How does the system handle duplicate class scheduling (same time, same tutor)?
- What happens when a user's role changes (e.g., student becomes tutor)?
- How does the system handle deleted Google Calendar events - should classes be automatically removed?
- What happens when email notification delivery fails? Should the system retry? How many times?
- How does the system handle file uploads with invalid or potentially malicious file types?
- What happens when a tutor uploads homework assignment files that exceed the size limit?
- How does the system handle concurrent file uploads from multiple users?
- What happens when a user's email address is invalid or bounces notifications?

## Requirements *(mandatory)*

### Functional Requirements

**Public Site**
- **FR-001**: System MUST display marketing content matching the existing Smarty Pants Tutoring website including services, subjects (Mathematics, English, Afrikaans, Science), and curriculum types (CAPS, IEB, Cambridge)
- **FR-002**: System MUST provide a contact/feedback form that collects visitor name, contact information, and message
- **FR-003**: System MUST send submitted contact form data as a WhatsApp message to a configurable business phone number
- **FR-004**: System MUST display a login/sign-up button that directs users to the authentication page
- **FR-005**: System MUST be responsive and accessible on mobile, tablet, and desktop devices

**Authentication & Authorization**
- **FR-006**: System MUST authenticate users with username and password credentials
- **FR-007**: System MUST support four distinct user roles: Parent, Student, Tutor, and Administrator
- **FR-008**: System MUST redirect authenticated users to role-appropriate dashboards
- **FR-009**: System MUST prevent unauthenticated users from accessing protected pages
- **FR-010**: System MUST prevent users from accessing functionality outside their role permissions
- **FR-011**: System MUST support administrator-only password reset functionality (with future expansion to email-based self-service planned)

**User Management (Administrator)**
- **FR-012**: Administrators MUST be able to create user accounts for all role types
- **FR-013**: Administrators MUST be able to assign students to tutors
- **FR-014**: Administrators MUST be able to link parents to students
- **FR-015**: Administrators MUST be able to edit user account details
- **FR-016**: Administrators MUST be able to deactivate user accounts using soft-delete with configurable data retention period (user marked inactive immediately, with data permanently deleted after specified retention period)
- **FR-017**: System MUST generate initial credentials for new users
- **FR-018**: System MUST support one parent being linked to multiple students
- **FR-019**: System MUST support one student being assigned to multiple tutors

**Class Scheduling (Tutor)**
- **FR-020**: Tutors MUST be able to view their existing Google Calendar events when scheduling classes to identify available time slots and prevent double-booking
- **FR-021**: Tutors MUST be able to create classes with date, time, duration, subject, and assigned student
- **FR-022**: System MUST integrate with Google Calendar to sync created classes
- **FR-023**: System MUST automatically generate Google Meet links for scheduled classes
- **FR-024**: Tutors MUST be able to view all their scheduled classes in a calendar view
- **FR-025**: Tutors MUST be able to edit scheduled classes
- **FR-026**: Tutors MUST be able to cancel scheduled classes
- **FR-027**: System MUST sync class modifications and cancellations to Google Calendar
- **FR-028**: System MUST display scheduled classes to assigned students and their parents

**Homework Management**
- **FR-029**: Tutors MUST be able to assign homework to students with description, due date, and optional file attachments
- **FR-030**: Tutors MUST be able to upload multiple files when creating homework assignments for common document formats (PDF, DOC, DOCX, TXT, JPG, PNG) with configurable file size limits (default 10MB per file)
- **FR-031**: Students MUST be able to view all assigned homework with status (pending, submitted, overdue) and download tutor-provided attachments
- **FR-032**: Students MUST be able to upload completed homework files
- **FR-033**: Students MUST be able to mark homework as submitted
- **FR-034**: Students MUST be able to upload multiple files per homework submission for common document formats (PDF, DOC, DOCX, TXT, JPG, PNG) with configurable file size limits (default 10MB per file)
- **FR-035**: Parents MUST be able to view their child's homework assignments, tutor attachments, and submission status
- **FR-036**: Tutors MUST be able to view homework submissions from their students
- **FR-037**: System MUST automatically mark homework as overdue when the due date passes without submission

**Feedback & Messaging (Tutor-Parent Communication)**
- **FR-038**: Tutors MUST be able to provide written feedback about students
- **FR-039**: Parents MUST be able to view all feedback provided by their child's tutors
- **FR-040**: Parents MUST be able to send messages to tutors
- **FR-041**: Tutors MUST be able to view messages from parents
- **FR-042**: System MUST display feedback and messages in chronological order
- **FR-043**: System MUST associate feedback with specific students and tutors

**Notifications**
- **FR-044**: System MUST send email notifications for all completed actions (class scheduling, homework assignment, homework submission, feedback, messages, user account creation)
- **FR-045**: System MUST support configurable notification delivery methods with email as the initial implementation
- **FR-046**: System MUST allow future expansion to WhatsApp and other notification platforms
- **FR-047**: Email notifications MUST include relevant action details (who, what, when) and links to view full information in the system
- **FR-048**: System MUST send notifications to appropriate recipients based on action type (e.g., homework assigned → student and parent; homework submitted → tutor and parent)
- **FR-049**: System MUST handle email delivery failures gracefully and log failed notifications for retry

**Dashboard Views**
- **FR-050**: Tutor dashboard MUST display all assigned students
- **FR-051**: Tutor dashboard MUST display upcoming classes
- **FR-052**: Tutor dashboard MUST display pending homework submissions
- **FR-053**: Tutor dashboard MUST display unread parent messages
- **FR-054**: Student dashboard MUST display upcoming classes with Google Meet links
- **FR-055**: Student dashboard MUST display assigned homework with due dates
- **FR-056**: Parent dashboard MUST display child's upcoming classes
- **FR-057**: Parent dashboard MUST display child's homework assignments and submission status
- **FR-058**: Parent dashboard MUST display tutor feedback
- **FR-059**: Administrator dashboard MUST display user management functions
- **FR-060**: System MUST support parents with multiple children viewing each child's information separately

### Key Entities

- **User**: Represents any person using the system. Has authentication credentials, role (Parent, Student, Tutor, Administrator), name, email, phone number, and account status (active/inactive)

- **Student**: A User with student role. Can be assigned to multiple Tutors, linked to one or more Parents, has homework assignments, class enrollments, and receives feedback

- **Parent**: A User with parent role. Can be linked to one or more Students, views child's classes, homework, and feedback, can send messages to Tutors

- **Tutor**: A User with tutor role. Can be assigned multiple Students, creates classes, assigns homework, provides feedback, receives parent messages

- **Administrator**: A User with administrator role. Creates and manages all user accounts, assigns relationships between users

- **Class**: Represents a scheduled tutoring session. Has date, time, duration, subject, assigned Student, assigned Tutor, Google Calendar event ID, Google Meet link, and status (scheduled, completed, cancelled)

- **Homework**: Represents an assignment given to a Student. Has description, due date, assigned Student, assigned Tutor, status (pending, submitted, overdue), and optional file attachments uploaded by Tutor

- **Homework Submission**: Represents a Student's completed homework. Has submission timestamp, uploaded files, associated Homework assignment

- **File Attachment**: Represents a file uploaded by either a Tutor (for homework assignments) or Student (for homework submissions). Has filename, file size, file type, upload timestamp, uploader reference, and associated entity (Homework or Homework Submission)

- **Feedback**: Represents tutor feedback about a Student. Has content, timestamp, Student, Tutor, and optional parent response

- **Message**: Represents communication between Parents and Tutors. Has content, timestamp, sender (Parent or Tutor), recipient, associated Student, and read status

- **Notification**: Represents a notification sent to a User. Has notification type (class_scheduled, homework_assigned, homework_submitted, feedback_provided, message_received, user_created), recipient User, delivery method (email initially, expandable to WhatsApp/other), delivery status, content, timestamp, and reference to associated entity (Class, Homework, Feedback, Message)

- **Contact Form Submission**: Represents a submission from the public website. Has visitor name, contact information, message content, submission timestamp, and delivery status

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Public marketing site loads in under 3 seconds on standard broadband connections
- **SC-002**: Contact form submissions successfully send WhatsApp messages with 99% reliability
- **SC-003**: Users can log in and reach their role-appropriate dashboard in under 30 seconds
- **SC-004**: Tutors can view their Google Calendar events on the scheduling page to identify available time slots
- **SC-005**: Tutors can create a class with Google Calendar integration in under 2 minutes
- **SC-006**: Students can view and access Google Meet links for upcoming classes within 3 clicks
- **SC-007**: Tutors can assign homework with file attachments to a student in under 2 minutes
- **SC-008**: Students can download tutor-provided homework attachments in under 30 seconds
- **SC-009**: Students can upload and submit homework with multiple files in under 2 minutes
- **SC-010**: Parents can view all their child's information (classes, homework, feedback) on a single dashboard page
- **SC-011**: Administrators can create a new user account and assign relationships in under 3 minutes
- **SC-012**: Google Calendar sync completes within 30 seconds of class creation or modification
- **SC-013**: Email notifications are delivered within 2 minutes of action completion for 99% of events
- **SC-014**: Email notifications include all relevant action details and functional links to the system
- **SC-015**: System supports at least 100 concurrent users without performance degradation
- **SC-016**: 90% of users successfully complete their primary task (viewing classes, submitting homework, etc.) on first attempt without assistance
- **SC-017**: Public site content matches existing site's marketing message and branding with 100% accuracy
- **SC-018**: All role-based access controls prevent unauthorized access with 100% effectiveness
- **SC-019**: File uploads complete successfully for files up to the configured size limit (default 10MB) with 99% reliability

