# Quickstart Guide: Rails Tutoring Platform

**Feature**: 001-rails-tutoring-platform  
**Date**: 2025-10-20  
**Phase**: 1 - Design & Contracts

## Overview

This guide provides step-by-step instructions for setting up the development environment and implementing the Rails tutoring platform rewrite.

## Prerequisites

### Required Software

- **Ruby**: 3.3.0 or higher
- **Rails**: 8.0 or higher
- **SQLite3**: 3.x (usually pre-installed on most systems)
- **Node.js**: 20 or higher (for asset compilation)
- **Git**: 2.x

### Optional Tools

- **Docker**: For containerized development
- **Overmind/Foreman**: For process management
- **SQLite Browser**: DB Browser for SQLite (GUI for viewing database)

## Initial Setup

### 1. Verify Rails Installation

```bash
# Check Ruby version
ruby -v  # Should be 3.3.0+

# Check Rails version
rails -v  # Should be 8.0+

# Check SQLite3
sqlite3 --version  # Should be 3.x
```

### 2. Database Setup

```bash
# Create databases
rails db:create

# Run migrations (once created)
rails db:migrate

# Seed initial data
rails db:seed
```

### 3. Install Dependencies

```bash
# Install Ruby gems (including vite_rails)
bundle install

# If vite_rails not in Gemfile yet, add it
bundle add vite_rails

# Run vite_rails installer (creates config files)
bundle exec vite install

# Install Vite and JavaScript packages
npm install

# Install Tailwind CSS 4, DaisyUI 5, and Vite plugin
npm install -D vite @tailwindcss/vite tailwindcss@latest daisyui@latest
```

### 4. Configure Tailwind CSS 4 and DaisyUI 5

**IMPORTANT**: Tailwind CSS 4 has breaking changes from v3. Configuration is now CSS-first (no JavaScript config file).

#### Create CSS Configuration

Create `app/assets/stylesheets/application.css`:

```css
/* Import Tailwind CSS 4 */
@import "tailwindcss";

/* Load DaisyUI 5 plugin */
@plugin "daisyui";

/* Optional: Configure DaisyUI themes */
@plugin "daisyui" {
  themes: light --default, dark --prefersdark;
}

/* Custom theme variables for Smarty Pants Tutoring */
@theme {
  --font-family-display: "Inter", "sans-serif";
  --color-primary: #4f46e5;
  --color-secondary: #7c3aed;
  --color-accent: #06b6d4;
}

/* Import custom component classes */
@import "components/buttons";
@import "components/cards";
@import "components/forms";
@import "components/badges";
@import "components/dashboard";
```

#### Configure Vite

The `vite install` command creates `vite.config.ts`. Update it to include Tailwind CSS:

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    tailwindcss(),
  ],
});
```

#### Update Application Layout

Ensure your layout includes Vite tags (vite_rails installer should add these):

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <title>Smarty Pants Tutoring</title>
    <%= csrf_meta_tags %>
    <%= csp_meta_tag %>
    
    <%= vite_client_tag %>
    <%= vite_stylesheet_tag 'application' %>
  </head>
  <body>
    <%= yield %>
    <%= vite_javascript_tag 'application' %>
  </body>
</html>
```

**Note**: Do NOT create `tailwind.config.js` - Tailwind CSS 4 uses CSS-first configuration!

### 5. Configure Credentials

```bash
# Edit encrypted credentials
EDITOR="code --wait" rails credentials:edit

# Add the following keys:
# google_calendar:
#   client_id: YOUR_GOOGLE_CLIENT_ID
#   client_secret: YOUR_GOOGLE_CLIENT_SECRET
# whatsapp:
#   account_sid: YOUR_TWILIO_ACCOUNT_SID
#   auth_token: YOUR_TWILIO_AUTH_TOKEN
#   from_number: YOUR_WHATSAPP_NUMBER
# aws:
#   access_key_id: YOUR_AWS_ACCESS_KEY
#   secret_access_key: YOUR_AWS_SECRET_KEY
#   region: us-east-1
#   bucket: your-bucket-name
```

### 6. Start Development Server

```bash
# Start all services with Procfile.dev (Rails + Vite)
bin/dev

# Or manually in separate terminals:
# Terminal 1: Rails server (includes Solid Queue worker)
rails server

# Terminal 2: Vite dev server (HMR for assets)
bin/vite dev

# Note: Solid Queue runs automatically with Rails server in development
# Note: Vite provides Hot Module Replacement (HMR) for instant CSS/JS updates
```

### 7. Access the Application

- **Homepage**: http://localhost:3000
- **Login**: http://localhost:3000/login
- **Solid Queue Dashboard**: http://localhost:3000/solid_queue (admin only, if configured)

## Development Workflow

### TDD Cycle (Red-Green-Refactor)

#### 1. Write Failing Test (Red)

```bash
# Generate model with test
rails generate model User email:string role:integer

# Write test in spec/models/user_spec.rb
```

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires an email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end
  end
end
```

```bash
# Run test (should fail)
rspec spec/models/user_spec.rb
```

#### 2. Make Test Pass (Green)

```ruby
# app/models/user.rb
class User < ApplicationRecord
  validates :email, presence: true
end
```

```bash
# Run test (should pass)
rspec spec/models/user_spec.rb
```

#### 3. Refactor

```ruby
# Improve code while keeping tests green
# Add more validations, extract methods, etc.
```

### Creating a New Feature

#### Example: Homework Assignment

**Step 1: Write Request Spec**

```ruby
# spec/requests/tutors/homework_spec.rb
require 'rails_helper'

RSpec.describe 'Tutors::Homework', type: :request do
  let(:tutor) { create(:user, :tutor) }
  let(:student) { create(:user, :student) }
  
  before { sign_in tutor }
  
  describe 'POST /tutors/homework' do
    it 'creates homework assignment' do
      expect {
        post tutors_homework_path, params: {
          homework: {
            student_id: student.id,
            title: 'Math Problems',
            description: 'Complete exercises 1-10',
            due_date: 1.week.from_now
          }
        }
      }.to change(Homework, :count).by(1)
      
      expect(response).to redirect_to(tutors_homework_path)
    end
  end
end
```

**Step 2: Create Route**

```ruby
# config/routes.rb
Rails.application.routes.draw do
  namespace :tutors do
    resources :homework
  end
end
```

**Step 3: Create Controller**

```ruby
# app/controllers/tutors/homework_controller.rb
module Tutors
  class HomeworkController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_tutor
    
    def create
      @homework = current_user.homework_assignments.build(homework_params)
      
      if @homework.save
        NotificationService.notify_homework_assigned(@homework)
        redirect_to tutors_homework_path, notice: 'Homework assigned successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    private
    
    def homework_params
      params.require(:homework).permit(:student_id, :title, :description, :due_date)
    end
    
    def authorize_tutor
      redirect_to root_path unless current_user.tutor?
    end
  end
end
```

**Step 4: Create View**

```erb
<!-- app/views/tutors/homework/new.html.erb -->
<div class="container mx-auto px-4 py-8">
  <h1 class="text-3xl font-bold mb-6">Assign Homework</h1>
  
  <%= form_with model: @homework, url: tutors_homework_path, class: "space-y-4" do |f| %>
    <div class="form-control">
      <%= f.label :student_id, class: "label" %>
      <%= f.collection_select :student_id, @students, :id, :full_name, 
          { prompt: "Select student" }, class: "select select-bordered w-full" %>
    </div>
    
    <div class="form-control">
      <%= f.label :title, class: "label" %>
      <%= f.text_field :title, class: "input input-bordered w-full" %>
    </div>
    
    <div class="form-control">
      <%= f.label :description, class: "label" %>
      <%= f.text_area :description, rows: 5, class: "textarea textarea-bordered w-full" %>
    </div>
    
    <div class="form-control">
      <%= f.label :due_date, class: "label" %>
      <%= f.date_field :due_date, class: "input input-bordered w-full" %>
    </div>
    
    <div class="form-control">
      <%= f.submit "Assign Homework", class: "btn btn-primary" %>
    </div>
  <% end %>
</div>
```

**Step 5: Run Tests**

```bash
# Run all tests
rspec

# Run specific test
rspec spec/requests/tutors/homework_spec.rb

# Run with coverage
COVERAGE=true rspec
```

### Creating CSS Component Classes

When you have reused UI patterns, create custom CSS component classes using Tailwind's `@apply` directive. This composes utility classes together in one place, similar to how DaisyUI creates its component classes like `.btn` and `.card`.

#### Philosophy

**"Compose Tailwind utilities once in CSS, reuse semantic class names everywhere"**

Instead of repeating utility combinations in HTML, create a semantic CSS class that applies them all at once.

#### Example: Custom Button Variants

**Problem**: You need consistent button styling but want to extend DaisyUI's `.btn` with your own variants.

**Solution**: Create CSS component classes in `app/assets/stylesheets/components/buttons.css`

```css
/* app/assets/stylesheets/components/buttons.css */

/* Extend DaisyUI buttons with custom variants */
.btn-save {
  @apply btn btn-primary;
  @apply shadow-lg hover:shadow-xl;
  @apply transition-all duration-200;
}

.btn-cancel {
  @apply btn btn-ghost;
  @apply text-base-content/70 hover:text-base-content;
}

.btn-danger {
  @apply btn btn-error;
  @apply shadow-md hover:shadow-lg;
}

.btn-icon {
  @apply btn btn-circle btn-ghost;
  @apply hover:bg-base-200;
}

/* Loading button state */
.btn-loading {
  @apply btn;
  @apply opacity-70 cursor-not-allowed;
}
```

**Usage in views**:
```erb
<!-- Before: Repeating utility classes -->
<button class="btn btn-primary shadow-lg hover:shadow-xl transition-all duration-200">
  Save
</button>

<!-- After: Clean semantic class -->
<button class="btn-save">Save</button>
<button class="btn-cancel">Cancel</button>
<button class="btn-danger">Delete</button>
```

#### Example: Card Components

**Problem**: You have different card styles for homework, classes, and feedback that reuse the same utility combinations.

**Solution**: Create semantic card classes

```css
/* app/assets/stylesheets/components/cards.css */

/* Base card with common styling */
.card-base {
  @apply card bg-base-100 shadow-xl;
  @apply hover:shadow-2xl transition-shadow duration-200;
}

/* Homework card */
.card-homework {
  @apply card-base;
  @apply border-l-4 border-primary;
}

.card-homework-overdue {
  @apply card-base;
  @apply border-l-4 border-error;
  @apply bg-error/5;
}

/* Class card */
.card-class {
  @apply card-base;
  @apply border-t-2 border-accent;
}

/* Feedback card */
.card-feedback {
  @apply card-base;
  @apply bg-base-200;
}

/* Card body variations */
.card-body-compact {
  @apply card-body;
  @apply p-4 space-y-2;
}

.card-body-spacious {
  @apply card-body;
  @apply p-6 space-y-4;
}
```

**Usage in views**:
```erb
<!-- Before: Repeating utility classes -->
<div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow duration-200 border-l-4 border-primary">
  <div class="card-body p-4 space-y-2">
    <!-- content -->
  </div>
</div>

<!-- After: Clean semantic classes -->
<div class="card-homework">
  <div class="card-body-compact">
    <h3 class="card-title">Math Assignment</h3>
    <p>Due: Tomorrow</p>
  </div>
</div>

<div class="card-homework-overdue">
  <div class="card-body-compact">
    <h3 class="card-title">Overdue Assignment</h3>
  </div>
</div>
```

#### Example: Form Layouts

**Problem**: Forms have consistent spacing, field groups, and action button layouts.

**Solution**: Create form layout classes

```css
/* app/assets/stylesheets/components/forms.css */

/* Form container */
.form-standard {
  @apply space-y-6;
  @apply max-w-2xl mx-auto;
}

/* Field group with consistent spacing */
.field-group {
  @apply space-y-4;
}

/* Form section with heading */
.form-section {
  @apply space-y-4;
  @apply pb-6 border-b border-base-300;
}

.form-section-title {
  @apply text-lg font-semibold text-base-content;
}

/* Form actions (buttons at bottom) */
.form-actions {
  @apply flex gap-3 justify-end;
  @apply pt-6 border-t border-base-300;
}

/* Inline field group (label + input side by side) */
.field-inline {
  @apply grid grid-cols-3 gap-4 items-center;
}

.field-inline-label {
  @apply label justify-end;
}

.field-inline-input {
  @apply col-span-2;
}
```

**Usage in views**:
```erb
<%= form_with model: @homework, class: "form-standard" do |f| %>
  <div class="form-section">
    <h2 class="form-section-title">Assignment Details</h2>
    
    <div class="field-group">
      <div class="form-control">
        <%= f.label :title, class: "label" %>
        <%= f.text_field :title, class: "input input-bordered w-full" %>
      </div>
      
      <div class="form-control">
        <%= f.label :description, class: "label" %>
        <%= f.text_area :description, class: "textarea textarea-bordered w-full" %>
      </div>
    </div>
  </div>
  
  <div class="form-actions">
    <%= link_to "Cancel", :back, class: "btn-cancel" %>
    <%= f.submit "Save", class: "btn-save" %>
  </div>
<% end %>
```

#### Example: Status Badges

**Problem**: Homework, classes, and other entities have status badges with consistent styling.

**Solution**: Create status badge classes

```css
/* app/assets/stylesheets/components/badges.css */

/* Status badges */
.badge-status {
  @apply badge badge-lg;
  @apply font-semibold;
}

.badge-pending {
  @apply badge-status badge-warning;
  @apply shadow-sm;
}

.badge-submitted {
  @apply badge-status badge-success;
  @apply shadow-sm;
}

.badge-overdue {
  @apply badge-status badge-error;
  @apply shadow-sm animate-pulse;
}

.badge-scheduled {
  @apply badge-status badge-info;
}

.badge-completed {
  @apply badge-status badge-success;
  @apply badge-outline;
}

.badge-cancelled {
  @apply badge-status badge-ghost;
  @apply opacity-60;
}
```

**Usage in views**:
```erb
<!-- Before: Repeating utility classes -->
<span class="badge badge-lg font-semibold badge-warning shadow-sm">
  Pending
</span>

<!-- After: Clean semantic classes -->
<span class="badge-pending">Pending</span>
<span class="badge-submitted">Submitted</span>
<span class="badge-overdue">Overdue</span>
<span class="badge-scheduled">Scheduled</span>
```

#### Example: Dashboard Widgets

**Problem**: Dashboard has multiple stat cards and widget containers with similar styling.

**Solution**: Create dashboard component classes

```css
/* app/assets/stylesheets/components/dashboard.css */

/* Stat card */
.stat-card {
  @apply card bg-base-100 shadow-lg;
  @apply hover:shadow-xl transition-shadow;
}

.stat-card-body {
  @apply card-body items-center text-center;
}

.stat-value {
  @apply text-4xl font-bold text-primary;
}

.stat-label {
  @apply text-sm text-base-content/60 uppercase tracking-wide;
}

/* Widget container */
.widget {
  @apply card bg-base-100 shadow-md;
}

.widget-header {
  @apply card-body pb-0;
  @apply flex flex-row items-center justify-between;
}

.widget-title {
  @apply text-lg font-semibold;
}

.widget-body {
  @apply card-body pt-4;
}

/* List items in widgets */
.widget-list-item {
  @apply flex items-center justify-between;
  @apply py-3 border-b border-base-200 last:border-0;
  @apply hover:bg-base-200/50 transition-colors;
  @apply px-2 -mx-2 rounded;
}
```

**Usage in views**:
```erb
<!-- Dashboard stats -->
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
  <div class="stat-card">
    <div class="stat-card-body">
      <div class="stat-value"><%= @pending_homework_count %></div>
      <div class="stat-label">Pending Homework</div>
    </div>
  </div>
  
  <div class="stat-card">
    <div class="stat-card-body">
      <div class="stat-value"><%= @upcoming_classes_count %></div>
      <div class="stat-label">Upcoming Classes</div>
    </div>
  </div>
</div>

<!-- Widget with list -->
<div class="widget">
  <div class="widget-header">
    <h3 class="widget-title">Recent Feedback</h3>
    <%= link_to "View All", feedbacks_path, class: "btn-cancel btn-sm" %>
  </div>
  <div class="widget-body">
    <% @feedbacks.each do |feedback| %>
      <div class="widget-list-item">
        <span><%= feedback.student.full_name %></span>
        <span class="text-sm text-base-content/60"><%= feedback.created_at.to_date %></span>
      </div>
    <% end %>
  </div>
</div>
```

#### File Organization

Organize your CSS component classes by category:

```
app/assets/stylesheets/
├── application.css          # Main stylesheet
├── components/
│   ├── buttons.css         # Button variants
│   ├── cards.css           # Card styles
│   ├── forms.css           # Form layouts
│   ├── badges.css          # Status badges
│   ├── dashboard.css       # Dashboard widgets
│   ├── tables.css          # Table styles
│   └── modals.css          # Modal dialogs
├── layouts/
│   ├── header.css          # Header/navigation
│   ├── footer.css          # Footer
│   └── sidebar.css         # Sidebar layouts
└── pages/
    ├── homepage.css        # Homepage specific
    └── auth.css            # Login/signup pages
```

Import in `application.css` (Tailwind CSS 4 syntax):
```css
/* app/assets/stylesheets/application.css */
/* Tailwind CSS 4 - Single import replaces base/components/utilities */
@import "tailwindcss";

/* Load DaisyUI 5 */
@plugin "daisyui";

/* Custom component classes */
@import "components/buttons";
@import "components/cards";
@import "components/forms";
@import "components/badges";
@import "components/dashboard";
```

#### Benefits of CSS Component Classes

1. **DRY**: Utility classes composed once in CSS, reused everywhere in HTML
2. **Consistency**: All similar elements look the same
3. **Maintainable**: Change styling in one place (CSS file)
4. **Semantic**: Class names describe purpose, not appearance
5. **Clean HTML**: Short, meaningful class names instead of long utility strings
6. **Performance**: CSS is compiled once, cached by browser
7. **Team-friendly**: Designers can update CSS without touching views
8. **Searchable**: Easy to find all uses of a component (grep for class name)

#### When to Create a CSS Component Class

Create a CSS component class when:
- ✅ You use the same utility combination 3+ times
- ✅ The pattern has semantic meaning (e.g., "homework card", "save button")
- ✅ The styling might change across the app (consistency needed)
- ✅ You want designers to be able to update styling easily

Don't create a CSS component class when:
- ❌ Used only once or twice (just use utilities directly)
- ❌ Styling is truly one-off and won't be reused
- ❌ The utilities are simple and obvious (e.g., just `text-center`)

#### Real-World Example: Homework List

**Before** (repeating utilities):
```erb
<% @homeworks.each do |homework| %>
  <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-shadow duration-200 border-l-4 <%= homework.overdue? ? 'border-error bg-error/5' : 'border-primary' %>">
    <div class="card-body p-4 space-y-2">
      <h3 class="card-title text-lg font-bold"><%= homework.title %></h3>
      <p class="text-sm text-base-content/70"><%= homework.description %></p>
      <div class="flex items-center justify-between mt-4">
        <span class="badge badge-lg font-semibold <%= homework.status == 'pending' ? 'badge-warning' : homework.status == 'submitted' ? 'badge-success' : 'badge-error' %> shadow-sm">
          <%= homework.status.titleize %>
        </span>
        <span class="text-sm text-base-content/60">Due: <%= homework.due_date %></span>
      </div>
    </div>
  </div>
<% end %>
```

**After** (semantic CSS classes):
```erb
<% @homeworks.each do |homework| %>
  <div class="<%= homework.overdue? ? 'card-homework-overdue' : 'card-homework' %>">
    <div class="card-body-compact">
      <h3 class="card-title"><%= homework.title %></h3>
      <p class="text-sm text-base-content/70"><%= homework.description %></p>
      <div class="flex items-center justify-between mt-4">
        <span class="badge-<%= homework.status %>"><%= homework.status.titleize %></span>
        <span class="text-sm text-base-content/60">Due: <%= homework.due_date %></span>
      </div>
    </div>
  </div>
<% end %>
```

**Result**:
- ✅ 60% less code in views
- ✅ Much easier to read and understand
- ✅ Change all homework cards by editing one CSS file
- ✅ Semantic class names describe purpose

### Using Service Objects

#### Create Service

```ruby
# app/services/google_calendar/create_event_service.rb
module GoogleCalendar
  class CreateEventService
    def initialize(tutor:, class_record:)
      @tutor = tutor
      @class_record = class_record
    end
    
    def call
      return failure('No Google Calendar token') unless @tutor.google_calendar_token
      
      event = create_calendar_event
      @class_record.update!(
        google_calendar_event_id: event.id,
        google_meet_link: event.hangout_link
      )
      
      success(event)
    rescue Google::Apis::Error => e
      failure(e.message)
    end
    
    private
    
    def create_calendar_event
      service = google_calendar_service
      event = Google::Apis::CalendarV3::Event.new(
        summary: "#{@class_record.subject} - #{@class_record.student.full_name}",
        start: { date_time: @class_record.scheduled_at.iso8601 },
        end: { date_time: @class_record.end_time.iso8601 },
        conference_data: conference_data_request
      )
      
      service.insert_event('primary', event, conference_data_version: 1)
    end
    
    def google_calendar_service
      # Initialize Google Calendar API client
    end
    
    def conference_data_request
      # Google Meet conference data
    end
    
    def success(data)
      OpenStruct.new(success?: true, data: data, error: nil)
    end
    
    def failure(error)
      OpenStruct.new(success?: false, data: nil, error: error)
    end
  end
end
```

#### Service Spec

```ruby
# spec/services/google_calendar/create_event_service_spec.rb
require 'rails_helper'

RSpec.describe GoogleCalendar::CreateEventService do
  let(:tutor) { create(:user, :tutor, :with_google_token) }
  let(:student) { create(:user, :student) }
  let(:class_record) { create(:class, tutor: tutor, student: student) }
  
  subject(:service) { described_class.new(tutor: tutor, class_record: class_record) }
  
  describe '#call' do
    context 'when successful' do
      it 'creates Google Calendar event' do
        VCR.use_cassette('google_calendar/create_event') do
          result = service.call
          
          expect(result).to be_success
          expect(class_record.reload.google_calendar_event_id).to be_present
          expect(class_record.google_meet_link).to be_present
        end
      end
    end
    
    context 'when tutor has no token' do
      let(:tutor) { create(:user, :tutor) }
      
      it 'returns failure' do
        result = service.call
        
        expect(result).not_to be_success
        expect(result.error).to eq('No Google Calendar token')
      end
    end
  end
end
```

#### Use in Controller

```ruby
# app/controllers/tutors/classes_controller.rb
def create
  @class = current_user.classes.build(class_params)
  
  if @class.save
    result = GoogleCalendar::CreateEventService.new(
      tutor: current_user,
      class_record: @class
    ).call
    
    if result.success?
      redirect_to tutors_classes_path, notice: 'Class scheduled successfully'
    else
      flash.now[:alert] = "Class saved but Google Calendar sync failed: #{result.error}"
      render :new, status: :unprocessable_entity
    end
  else
    render :new, status: :unprocessable_entity
  end
end
```

### Using Background Jobs

#### Create Job

```ruby
# app/jobs/send_notification_job.rb
class SendNotificationJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  
  def perform(notification_id)
    notification = Notification.find(notification_id)
    
    case notification.delivery_method
    when 'email'
      NotificationMailer.send_notification(notification).deliver_now
    when 'whatsapp'
      WhatsAppService.send_message(notification)
    end
    
    notification.mark_as_sent!
  rescue => e
    notification.mark_as_failed!(e.message)
    raise
  end
end
```

#### Job Spec

```ruby
# spec/jobs/send_notification_job_spec.rb
require 'rails_helper'

RSpec.describe SendNotificationJob, type: :job do
  let(:notification) { create(:notification, :email) }
  
  it 'sends email notification' do
    expect {
      described_class.perform_now(notification.id)
    }.to have_enqueued_mail(NotificationMailer, :send_notification)
    
    expect(notification.reload.delivery_status).to eq('sent')
  end
end
```

#### Enqueue Job

```ruby
# Enqueue immediately
SendNotificationJob.perform_later(notification.id)

# Enqueue with delay
SendNotificationJob.set(wait: 5.minutes).perform_later(notification.id)

# Enqueue at specific time
SendNotificationJob.set(wait_until: Date.tomorrow.noon).perform_later(notification.id)
```

## Testing Strategy

### Test Types

1. **Model Specs**: Validations, associations, scopes, methods
2. **Request Specs**: Full request/response cycle, integration tests
3. **System Specs**: End-to-end with Capybara (critical flows only)
4. **Service Specs**: Business logic in service objects
5. **Component Specs**: ViewComponent rendering
6. **Job Specs**: Background job behavior

### Running Tests

```bash
# All tests
rspec

# Specific file
rspec spec/models/user_spec.rb

# Specific test
rspec spec/models/user_spec.rb:10

# By tag
rspec --tag focus
rspec --tag ~slow

# With coverage
COVERAGE=true rspec

# Parallel execution
rake parallel:spec
```

### Test Helpers

```ruby
# spec/support/auth_helpers.rb
module AuthHelpers
  def sign_in(user)
    post login_path, params: { email: user.email, password: user.password }
  end
  
  def sign_out
    delete logout_path
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
  config.include AuthHelpers, type: :system
end
```

## Code Quality

### Run RuboCop

```bash
# Check all files
rubocop

# Auto-correct safe violations
rubocop -a

# Auto-correct all violations (use with caution)
rubocop -A

# Check specific file
rubocop app/models/user.rb
```

### Run Brakeman

```bash
# Security scan
brakeman

# With more details
brakeman -A

# Output to file
brakeman -o brakeman_report.html
```

### Run Bundle Audit

```bash
# Check for vulnerable gems
bundle audit check --update
```

## Common Tasks

### Create Admin User

```bash
rails console

User.create!(
  email: 'admin@example.com',
  password: 'password',
  first_name: 'Admin',
  last_name: 'User',
  role: :administrator
)
```

### Reset Database

```bash
rails db:drop db:create db:migrate db:seed
```

### Generate Migration

```bash
# Add column
rails generate migration AddPhoneToUsers phone:string

# Create join table
rails generate migration CreateStudentTutors student:references tutor:references

# Remove column
rails generate migration RemovePhoneFromUsers phone:string
```

### Console Debugging

```bash
# Start console
rails console

# Reload code
reload!

# Access last request
app.get '/tutors/dashboard'
app.response.body

# Test mailer
NotificationMailer.send_notification(notification).deliver_now
```

## Deployment

### Prepare for Production

```bash
# Precompile assets
rails assets:precompile

# Run migrations
rails db:migrate RAILS_ENV=production

# Check configuration
rails runner 'puts Rails.application.config.inspect' RAILS_ENV=production
```

### Environment Variables

```bash
# Required in production
RAILS_ENV=production
SECRET_KEY_BASE=<generate with: rails secret>
DATABASE_URL=sqlite3:db/production.sqlite3

# Backup configuration
BACKUP_PATH=/path/to/backups
BACKUP_RETENTION_DAYS=30

# Optional: Cache configuration
RAILS_CACHE_STORE=file_store  # or solid_cache_store
```

## Database Backups

### Automated Backup Script

```bash
# Create backup script: bin/backup_database.sh
#!/bin/bash
set -e

BACKUP_DIR="${BACKUP_PATH:-./backups}"
RETENTION_DAYS="${BACKUP_RETENTION_DAYS:-30}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_FILE="db/production.sqlite3"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup
echo "Creating backup: $BACKUP_DIR/production_$TIMESTAMP.sqlite3"
sqlite3 "$DB_FILE" ".backup '$BACKUP_DIR/production_$TIMESTAMP.sqlite3'"

# Compress backup
gzip "$BACKUP_DIR/production_$TIMESTAMP.sqlite3"

# Remove old backups
echo "Removing backups older than $RETENTION_DAYS days"
find "$BACKUP_DIR" -name "production_*.sqlite3.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup complete!"
```

### Manual Backup

```bash
# Simple file copy
cp db/production.sqlite3 backups/production_$(date +%Y%m%d).sqlite3

# Or use SQLite backup command (safer for live database)
sqlite3 db/production.sqlite3 ".backup 'backups/production_$(date +%Y%m%d).sqlite3'"
```

### Restore from Backup

```bash
# Stop the application first
# Then restore
cp backups/production_20251020.sqlite3 db/production.sqlite3

# Or from compressed backup
gunzip -c backups/production_20251020.sqlite3.gz > db/production.sqlite3

# Restart the application
```

### Automated Daily Backups (Cron)

```bash
# Add to crontab: crontab -e
# Run backup daily at 2 AM
0 2 * * * cd /path/to/app && bin/backup_database.sh >> log/backup.log 2>&1
```

## Troubleshooting

### Common Issues

**Issue**: Database connection error
```bash
# Solution: Check database file permissions
ls -la db/*.sqlite3

# Ensure db directory exists
mkdir -p db

# Recreate database if corrupted
rails db:drop db:create db:migrate
```

**Issue**: Background jobs not processing
```bash
# Solution: Check Solid Queue is running
rails solid_queue:status

# Restart Rails server (Solid Queue runs with it)
# Or check logs for errors
tail -f log/development.log
```

**Issue**: Asset compilation fails
```bash
# Solution: Clear cache and recompile
rails assets:clobber
rails assets:precompile
```

**Issue**: Tests failing randomly
```bash
# Solution: Run with seed to reproduce
rspec --seed 12345

# Or disable random order
rspec --order defined
```

## Next Steps

1. Review [data-model.md](./data-model.md) for database schema
2. Review [contracts/routes.md](./contracts/routes.md) for API endpoints
3. Start implementing features following TDD workflow
4. Run `/speckit.tasks` to generate task breakdown

## Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [RSpec Documentation](https://rspec.info/)
- [ViewComponent Guide](https://viewcomponent.org/)
- [Alpine.js Documentation](https://alpinejs.dev/)
- [DaisyUI Components](https://daisyui.com/components/)
- [Google Calendar API](https://developers.google.com/calendar/api)
