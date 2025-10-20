# API Routes Contract

**Feature**: 001-rails-tutoring-platform  
**Date**: 2025-10-20  
**Phase**: 1 - Design & Contracts

## Overview

This document defines all HTTP routes, request/response formats, and HATEOAS patterns for the Rails tutoring platform. All routes follow RESTful conventions and return server-rendered HTML (not JSON) for AJAX requests.

## Route Organization

### Public Routes (Unauthenticated)

#### Marketing Site
```
GET  /                          # Homepage
GET  /about                     # About page
GET  /services                  # Services page
GET  /contact                   # Contact page
POST /contact                   # Submit contact form
```

#### Authentication
```
GET  /login                     # Login page
POST /login                     # Process login
DELETE /logout                  # Logout
GET  /password/reset            # Password reset request (future)
POST /password/reset            # Send reset email (future)
```

### Authenticated Routes

All authenticated routes require valid session. Unauthorized access redirects to `/login`.

#### Tutor Dashboard
```
GET  /tutors/dashboard          # Tutor dashboard home
GET  /tutors/students           # List assigned students
GET  /tutors/students/:id       # Student detail page

# Classes
GET  /tutors/classes            # List all classes (calendar view)
GET  /tutors/classes/new        # New class form
POST /tutors/classes            # Create class
GET  /tutors/classes/:id/edit   # Edit class form
PATCH /tutors/classes/:id       # Update class
DELETE /tutors/classes/:id      # Cancel class
GET  /tutors/calendar/events    # AJAX: Get calendar events (HTML partial)

# Homework
GET  /tutors/homework           # List all homework
GET  /tutors/homework/new       # New homework form
POST /tutors/homework           # Create homework
GET  /tutors/homework/:id       # Homework detail
GET  /tutors/homework/:id/edit  # Edit homework form
PATCH /tutors/homework/:id      # Update homework
DELETE /tutors/homework/:id     # Delete homework
GET  /tutors/homework/:id/submissions  # View submissions

# Feedback
GET  /tutors/feedback           # List all feedback
GET  /tutors/feedback/new       # New feedback form
POST /tutors/feedback           # Create feedback
GET  /tutors/feedback/:id       # Feedback detail

# Messages
GET  /tutors/messages           # List all messages
GET  /tutors/messages/:id       # Message thread
POST /tutors/messages           # Send message
PATCH /tutors/messages/:id/read # Mark as read (AJAX)
```

#### Student Dashboard
```
GET  /students/dashboard        # Student dashboard home
GET  /students/classes          # List upcoming classes
GET  /students/classes/:id      # Class detail

# Homework
GET  /students/homework         # List all homework
GET  /students/homework/:id     # Homework detail
POST /students/homework/:id/submit  # Submit homework
DELETE /students/homework/:id/submission/:file_id  # Remove uploaded file
```

#### Parent Dashboard
```
GET  /parents/dashboard         # Parent dashboard home
GET  /parents/children          # List children (if multiple)
GET  /parents/children/:id      # Child detail page

# Classes
GET  /parents/children/:id/classes  # Child's classes

# Homework
GET  /parents/children/:id/homework  # Child's homework
GET  /parents/children/:id/homework/:homework_id  # Homework detail

# Feedback
GET  /parents/children/:id/feedback  # Child's feedback
GET  /parents/children/:id/feedback/:feedback_id  # Feedback detail

# Messages
GET  /parents/messages          # List all messages
GET  /parents/messages/:id      # Message thread
POST /parents/messages          # Send message
PATCH /parents/messages/:id/read  # Mark as read (AJAX)
```

#### Administrator Dashboard
```
GET  /admin/dashboard           # Admin dashboard home

# User Management
GET  /admin/users               # List all users
GET  /admin/users/new           # New user form
POST /admin/users               # Create user
GET  /admin/users/:id           # User detail
GET  /admin/users/:id/edit      # Edit user form
PATCH /admin/users/:id          # Update user
DELETE /admin/users/:id         # Deactivate user
POST /admin/users/:id/restore   # Restore deactivated user
POST /admin/users/:id/reset_password  # Reset user password

# Relationships
POST /admin/student_tutors      # Assign student to tutor
DELETE /admin/student_tutors/:id  # Remove assignment
POST /admin/parent_students     # Link parent to student
DELETE /admin/parent_students/:id  # Remove link

# System
GET  /admin/notifications       # View notification log
GET  /admin/contact_submissions # View contact form submissions
```

### Shared Routes (Multiple Roles)

#### File Downloads
```
GET  /files/:id/download        # Download file attachment
```

#### Notifications
```
GET  /notifications             # List user's notifications
PATCH /notifications/:id/read   # Mark notification as read (AJAX)
PATCH /notifications/read_all   # Mark all as read (AJAX)
```

## Request/Response Formats

### HTML Responses (Default)

All routes return full HTML pages by default:

```
Accept: text/html
```

Response includes:
- Full page layout with navigation
- CSRF token in forms
- Alpine.js data attributes
- DaisyUI styled components

### Partial HTML Responses (AJAX)

AJAX requests return HTML partials:

```
Accept: text/html
X-Requested-With: XMLHttpRequest
```

Response includes:
- HTML fragment (no layout)
- Alpine.js data attributes
- HATEOAS links/forms for next actions

### Error Responses

#### 401 Unauthorized
```html
<!-- Redirect to /login with flash message -->
```

#### 403 Forbidden
```html
<div class="alert alert-error">
  <p>You don't have permission to access this resource.</p>
  <a href="/" class="btn btn-primary">Go Home</a>
</div>
```

#### 404 Not Found
```html
<div class="alert alert-warning">
  <p>The page you're looking for doesn't exist.</p>
  <a href="/" class="btn btn-primary">Go Home</a>
</div>
```

#### 422 Unprocessable Entity
```html
<div class="alert alert-error">
  <ul>
    <li>Email has already been taken</li>
    <li>Password is too short</li>
  </ul>
</div>
```

#### 500 Internal Server Error
```html
<div class="alert alert-error">
  <p>Something went wrong. Please try again later.</p>
</div>
```

## HATEOAS Patterns

### Example: Class List Response

```html
<div class="classes-list" x-data="{ selectedClass: null }">
  <div class="flex justify-between mb-4">
    <h2 class="text-2xl font-bold">Upcoming Classes</h2>
    <a href="/tutors/classes/new" class="btn btn-primary">
      Schedule New Class
    </a>
  </div>
  
  <div class="grid gap-4">
    <div class="card bg-base-100 shadow-xl" data-class-id="1">
      <div class="card-body">
        <h3 class="card-title">Mathematics - John Doe</h3>
        <p>Monday, Oct 21, 2025 at 2:00 PM (60 minutes)</p>
        <div class="card-actions justify-end">
          <a href="/tutors/classes/1/edit" class="btn btn-sm btn-ghost">
            Edit
          </a>
          <form action="/tutors/classes/1" method="post" 
                x-on:submit.prevent="$ajax.submit($event)">
            <input type="hidden" name="_method" value="delete">
            <button type="submit" class="btn btn-sm btn-error">
              Cancel Class
            </button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
```

### Example: Homework Submission Form

```html
<form action="/students/homework/1/submit" 
      method="post" 
      enctype="multipart/form-data"
      x-data="{ uploading: false }"
      x-on:submit="uploading = true">
  
  <div class="form-control">
    <label class="label">
      <span class="label-text">Upload Files</span>
    </label>
    <input type="file" 
           name="files[]" 
           multiple 
           accept=".pdf,.doc,.docx,.txt,.jpg,.png"
           class="file-input file-input-bordered">
    <label class="label">
      <span class="label-text-alt">Max 10MB per file</span>
    </label>
  </div>
  
  <div class="form-control">
    <label class="label">
      <span class="label-text">Notes (optional)</span>
    </label>
    <textarea name="notes" 
              class="textarea textarea-bordered" 
              rows="3"></textarea>
  </div>
  
  <div class="form-control mt-4">
    <button type="submit" 
            class="btn btn-primary"
            x-bind:disabled="uploading">
      <span x-show="!uploading">Submit Homework</span>
      <span x-show="uploading" class="loading loading-spinner"></span>
    </button>
  </div>
</form>
```

### Example: Calendar Events (AJAX Response)

```html
<!-- Returned as partial for calendar widget -->
<div class="calendar-events">
  <div class="event" data-event-id="1">
    <div class="event-time">2:00 PM - 3:00 PM</div>
    <div class="event-title">Mathematics - John Doe</div>
    <a href="/tutors/classes/1" class="event-link">View Details</a>
  </div>
  <div class="event" data-event-id="2">
    <div class="event-time">4:00 PM - 5:00 PM</div>
    <div class="event-title">English - Jane Smith</div>
    <a href="/tutors/classes/2" class="event-link">View Details</a>
  </div>
</div>
```

## Form Conventions

### CSRF Protection

All forms include CSRF token (Rails automatic):

```html
<form action="/path" method="post">
  <input type="hidden" name="authenticity_token" value="...">
  <!-- form fields -->
</form>
```

### HTTP Method Override

Use hidden field for PUT/PATCH/DELETE:

```html
<form action="/tutors/classes/1" method="post">
  <input type="hidden" name="_method" value="patch">
  <!-- form fields -->
</form>
```

### File Uploads

Use multipart form encoding:

```html
<form action="/path" method="post" enctype="multipart/form-data">
  <input type="file" name="files[]" multiple>
</form>
```

### Alpine-AJAX Integration

Use `x-on:submit.prevent` with `$ajax.submit()`:

```html
<form action="/path" 
      method="post"
      x-on:submit.prevent="$ajax.submit($event)"
      x-target="#result-container">
  <!-- form fields -->
</form>

<div id="result-container">
  <!-- Response HTML will be inserted here -->
</div>
```

## Response Headers

### Successful Responses

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
X-Frame-Options: SAMEORIGIN
X-XSS-Protection: 1; mode=block
X-Content-Type-Options: nosniff
```

### Redirect Responses

```
HTTP/1.1 302 Found
Location: /tutors/dashboard
Set-Cookie: _session_id=...; path=/; HttpOnly; SameSite=Lax
```

### AJAX Responses

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
X-Requested-With: XMLHttpRequest
```

## Rate Limiting

### Public Routes
- Contact form: 5 submissions per IP per hour
- Login attempts: 5 attempts per IP per 15 minutes

### Authenticated Routes
- File uploads: 20 uploads per user per hour
- Message sending: 50 messages per user per hour
- API calls: 100 requests per user per minute

### Google Calendar API
- 1 request per second per user (enforced by service layer)

## Security Headers

All responses include:

```
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Content-Security-Policy: default-src 'self'; script-src 'self' 'unsafe-inline' cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' cdn.jsdelivr.net; img-src 'self' data: https:;
```

## Next Steps

Routes contract complete. Proceed to:
1. Create quickstart guide (quickstart.md)
2. Update agent context files
