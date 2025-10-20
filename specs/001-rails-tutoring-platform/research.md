# Research: Rails Tutoring Platform

**Feature**: 001-rails-tutoring-platform  
**Date**: 2025-10-20  
**Phase**: 0 - Outline & Research

## Overview

This document consolidates research findings for technical decisions, best practices, and integration patterns needed for the Rails tutoring platform rewrite.

## Technology Decisions

### 1. Alpine.js for Client-Side Interactions

**Decision**: Use Alpine.js 3.x for lightweight client-side interactivity

**Rationale**:
- Minimal footprint (~15KB gzipped) compared to React/Vue
- Declarative syntax similar to Vue, easy to learn
- Works seamlessly with server-side rendered HTML
- No build step required, can be included via CDN or importmap
- Perfect for progressive enhancement and HATEOAS architecture

**Alternatives Considered**:
- **Stimulus**: Rejected per user requirement (not installed, explicitly excluded)
- **Turbo**: Rejected per user requirement (not installed, explicitly excluded)
- **Vanilla JS**: Would require more boilerplate for common interactions
- **HTMX**: Good alternative but Alpine.js provides better state management for complex UI

**Implementation Notes**:
- Use Alpine.js `x-data` for component state
- Use `x-on` for event handling
- Use `x-show`/`x-if` for conditional rendering
- Keep Alpine components small and focused

### 2. Alpine-AJAX for Server Communication

**Decision**: Use alpine-ajax plugin for AJAX requests following HATEOAS principles

**Rationale**:
- Integrates seamlessly with Alpine.js
- Supports returning HTML partials from server
- Maintains HATEOAS architecture (server returns HTML, not JSON)
- Simpler than managing fetch() calls manually
- Supports progressive enhancement

**Alternatives Considered**:
- **Fetch API**: More verbose, requires manual DOM manipulation
- **jQuery**: Outdated, adds unnecessary weight
- **Axios**: Designed for JSON APIs, not HTML partials

**Implementation Notes**:
- Server endpoints return HTML partials (not JSON)
- Use `x-target` to specify where response HTML should be inserted
- Leverage HTTP status codes for error handling
- Return appropriate HTMX/Alpine-friendly responses

### 3. DaisyUI 5 for CSS Framework

**Decision**: Use DaisyUI 5.x built on Tailwind CSS 4.x

**Rationale**:
- Component-based CSS framework with semantic class names
- Built on Tailwind CSS 4 (utility-first, highly customizable)
- Provides pre-built components (buttons, cards, modals, forms)
- Excellent theming support for custom branding
- No JavaScript required (pure CSS)
- Active development and good documentation
- DaisyUI 5 + Tailwind CSS 4 is the latest stable combination

**Alternatives Considered**:
- **Bootstrap 5**: More opinionated, harder to customize, heavier
- **Bulma**: Less feature-rich, smaller community
- **Pure Tailwind**: Would require building all components from scratch

**Implementation Notes (Tailwind CSS 4 + DaisyUI 5)**:

**IMPORTANT - Breaking Changes from v3 to v4**:
- Tailwind CSS 4 uses **CSS-first configuration** (no more JavaScript config file)
- Use `@import "tailwindcss"` instead of `@tailwind` directives
- Use `@plugin "daisyui"` to load DaisyUI (new syntax)
- Theme configuration now uses CSS variables with `@theme` directive
- PostCSS plugin moved to separate `@tailwindcss/postcss` package
- Vite users should use `@tailwindcss/vite` plugin for better performance

**Installation**:
1. Install packages:
   ```bash
   npm install -D tailwindcss@latest daisyui@latest
   ```

2. Create `app/assets/stylesheets/application.css`:
   ```css
   @import "tailwindcss";
   @plugin "daisyui";
   
   /* Optional: Configure DaisyUI themes */
   @plugin "daisyui" {
     themes: light --default, dark --prefersdark, cupcake;
   }
   
   /* Custom theme variables */
   @theme {
     --font-family-display: "Inter", "sans-serif";
     --color-primary: #your-brand-color;
   }
   ```

3. **No tailwind.config.js needed** - Configuration is now in CSS!

4. For Rails with Vite (recommended - using vite_rails):
   ```bash
   # Install vite_rails gem
   bundle add vite_rails
   
   # Install Vite and Tailwind CSS Vite plugin
   npm install -D vite @tailwindcss/vite
   
   # Run vite_rails installer
   bundle exec vite install
   ```
   
   ```javascript
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

5. Alternative - For Rails with PostCSS (not recommended):
   ```bash
   npm install -D @tailwindcss/postcss
   ```
   
   ```javascript
   // postcss.config.js
   export default {
     plugins: {
       '@tailwindcss/postcss': {},
     },
   };
   ```

**Custom CSS Component Classes**:
- **Create custom CSS component classes** using `@apply` for reused patterns
- Compose Tailwind utilities into semantic component classes
- Example: `.card-homework` applies all card + spacing + shadow utilities
- Keeps HTML clean and utilities composed in one place
- Similar to DaisyUI's approach but for app-specific patterns

**DaisyUI 5 Changes from v4**:
- Removed `artboard` and `phone-*` classes
- Some component class name changes (see upgrade guide)
- Improved theme system with better CSS variable support

### 4. ViewComponent for Reusable UI

**Decision**: Use ViewComponent gem for component-based view architecture with DaisyUI-style utility composition

**Rationale**:
- Official GitHub gem, well-maintained
- Testable components (unit test Ruby logic separately from views)
- Better performance than partials (compiled, cached)
- Encapsulates component logic and presentation
- Works well with Tailwind/DaisyUI
- Supports slots for flexible composition
- **Componentize reused utility classes** (like DaisyUI's `btn` approach)

**Alternatives Considered**:
- **Rails Partials**: Less testable, no encapsulation, slower
- **Phlex**: Newer, less mature, different paradigm (Ruby DSL for HTML)
- **Cells**: Older gem, less actively maintained

**Implementation Notes**:
- Generate components: `rails g component ComponentName`
- Place in `app/components/`
- Write component specs in `spec/components/`
- **Create base UI components** for reused patterns:
  - `ButtonComponent` - Wraps `btn` + variants (primary, secondary, error, etc.)
  - `CardComponent` - Wraps `card` + common layouts
  - `FormFieldComponent` - Wraps `form-control` + label + input patterns
  - `AlertComponent` - Wraps `alert` + variants (success, error, warning, info)
  - `ModalComponent` - Wraps `modal` + common dialog patterns
  - `BadgeComponent` - Wraps `badge` + status variants
  - `TableComponent` - Wraps `table` + common table patterns
- **Compose utility classes once** in component, reuse everywhere
- Use for: buttons, cards, forms, dashboard widgets, modals, alerts, badges

### 5. Google Calendar API Integration

**Decision**: Use `google-api-client` gem with OAuth2 authentication

**Rationale**:
- Official Google gem for Ruby
- Supports OAuth2 flow for user authorization
- Handles token refresh automatically
- Comprehensive API coverage (Calendar, Meet)
- Well-documented with examples

**Alternatives Considered**:
- **Direct HTTP requests**: Too low-level, would need to handle OAuth manually
- **Omniauth-google-oauth2**: Good for authentication but doesn't include Calendar API client

**Implementation Notes**:
- Store OAuth tokens encrypted in database (per user)
- Implement OAuth callback flow for tutor authorization
- Use service objects to encapsulate Calendar API calls
- Handle rate limiting (1 request/second per user)
- Implement retry logic for transient failures
- Cache calendar events to reduce API calls

**API Operations Needed**:
- List events (for calendar visibility)
- Create event with Google Meet link
- Update event
- Delete event
- Watch for changes (webhooks for sync)

### 6. WhatsApp Business API Integration

**Decision**: Use WhatsApp Business API via Twilio or direct integration

**Rationale**:
- Required for contact form submissions
- WhatsApp Business API provides official messaging capabilities
- Twilio provides Ruby SDK and simplified integration
- Can be extended for future notification channels

**Alternatives Considered**:
- **WhatsApp Web scraping**: Violates ToS, unreliable
- **Third-party unofficial APIs**: Security risk, unreliable
- **Direct WhatsApp Business API**: More complex setup, requires Facebook Business verification

**Implementation Notes**:
- Use Twilio WhatsApp API for initial implementation
- Store WhatsApp business number in encrypted credentials
- Create service object for sending messages
- Handle delivery failures gracefully
- Log all WhatsApp messages for audit trail

### 7. File Upload with ActiveStorage

**Decision**: Use Rails ActiveStorage with cloud storage backend

**Rationale**:
- Built into Rails, no additional gem needed
- Supports multiple storage backends (S3, Azure, GCS)
- Direct uploads to cloud storage (reduces server load)
- Automatic image processing with ImageMagick/libvips
- Virus scanning integration available

**Alternatives Considered**:
- **CarrierWave**: Older gem, more configuration needed
- **Shrine**: More flexible but more complex
- **Paperclip**: Deprecated

**Implementation Notes**:
- Configure ActiveStorage with S3 or compatible storage
- Set file size limits (10MB default, configurable)
- Validate file types (PDF, DOC, DOCX, TXT, JPG, PNG)
- Implement virus scanning (ClamAV or cloud service)
- Use direct uploads for better UX
- Clean up orphaned files with background job

### 8. Email Notifications with ActionMailer + Solid Queue

**Decision**: Use ActionMailer with Solid Queue (Rails 8 default) for async email delivery

**Rationale**:
- ActionMailer is Rails standard for email
- **Solid Queue is built into Rails 8** - no additional dependencies
- **Database-backed** (uses SQLite3) - no Redis needed
- Supports retries and error handling
- Simple setup, zero configuration
- Perfect for small applications
- Good monitoring through Rails UI

**Alternatives Considered**:
- **Sidekiq + Redis**: Requires Redis server, overkill for this scale
- **Delayed Job**: Older, less performant than Solid Queue
- **Good Job**: Similar to Solid Queue but not Rails default
- **Synchronous email**: Would block requests, poor UX

**Implementation Notes**:
- Configure ActionMailer with SMTP provider (SendGrid, Mailgun, AWS SES)
- Create mailer classes for each notification type
- Use Solid Queue for async delivery (Rails 8 default)
- Implement retry logic (3 attempts with exponential backoff)
- Log failed deliveries for manual review
- Create email templates with responsive design
- Include unsubscribe links for compliance
- Monitor jobs through Rails console or web UI

### 9. Authentication & Authorization

**Decision**: Use Devise for authentication, Pundit for authorization

**Rationale**:
- **Devise**: Industry standard for Rails authentication
  - Handles registration, login, password reset
  - Supports multiple user types (roles)
  - Extensible and well-documented
  - Security best practices built-in
  
- **Pundit**: Simple, object-oriented authorization
  - Policy classes for each model
  - Easy to test
  - Explicit authorization checks
  - Works well with Rails conventions

**Alternatives Considered**:
- **Authlogic**: Older, less feature-rich
- **Sorcery**: Simpler but requires more manual work
- **CanCanCan**: More complex than Pundit, less intuitive
- **Custom auth**: Reinventing the wheel, security risk

**Implementation Notes**:
- Install Devise, configure for User model
- Add role enum to User (parent, student, tutor, administrator)
- Create Pundit policies for each resource
- Implement role-based dashboard routing
- Admin-only user creation (disable public registration)
- Password reset via admin initially (email-based later)

### 10. Database Design Patterns

**Decision**: Use standard Rails ActiveRecord with SQLite3

**Rationale**:
- ActiveRecord provides excellent ORM capabilities
- SQLite3 is perfect for small-to-medium applications (up to 2000 users)
- **Easy backup**: Single file database makes backups trivial (just copy the file)
- No separate database server to manage
- Built into Rails by default
- Excellent for development and small production deployments
- Supports most SQL features needed for this application
- No need for repository pattern (constitution allows direct DB access)

**Alternatives Considered**:
- **PostgreSQL**: More features (JSONB, full-text search) but overkill for this scale, requires separate server, more complex backups
- **MySQL**: Similar to PostgreSQL, adds unnecessary complexity

**Implementation Notes**:
- Use foreign keys with `on_delete` cascades
- Add database-level constraints (NOT NULL, UNIQUE, CHECK)
- Index foreign keys and frequently queried columns
- Implement soft deletes with `deleted_at` timestamp
- Use database transactions for multi-step operations
- Regular backups via simple file copy or automated script
- Consider WAL mode for better concurrency
- Monitor database file size (SQLite handles up to ~281 TB theoretically, but practical limit ~1 TB)

**SQLite3 Limitations to Note**:
- No JSONB type (use JSON text column instead)
- Limited concurrent writes (one writer at a time)
- No built-in full-text search (can add FTS5 extension if needed)
- For this application scale (2000 users max), these limitations are not concerns

**Backup Strategy**:
- Automated daily backups (copy .sqlite3 file)
- Keep 30 days of backups
- Store backups in separate location/cloud storage
- Test restore process regularly

### 11. Caching Strategy

**Decision**: Use Rails built-in caching with file store or Solid Cache

**Rationale**:
- **Rails built-in caching** is sufficient for this application scale
- **File store**: Simple, no dependencies, works out of the box
- **Solid Cache** (Rails 8): Database-backed cache using SQLite, zero config
- No Redis needed for small application (100 concurrent users)
- Reduces infrastructure complexity
- Easy to set up and maintain

**Alternatives Considered**:
- **Redis**: Requires separate server, overkill for this scale
- **Memcached**: Requires separate server, more complex setup
- **No caching**: Would impact performance for expensive queries

**Implementation Notes**:
- Use fragment caching for expensive view partials
- Use Rails.cache for expensive database queries
- Cache Google Calendar API responses (reduce API calls)
- Set appropriate cache expiration times
- Use cache keys with versioning for easy invalidation
- Monitor cache hit rates in development

**Caching Targets**:
- Student/tutor lists (cache for 5 minutes)
- Calendar events (cache for 1 minute)
- Dashboard statistics (cache for 10 minutes)
- Public marketing pages (cache for 1 hour)
- User permissions (cache for duration of request)

## Integration Patterns

### HATEOAS Architecture

**Pattern**: Hypermedia As The Engine Of Application State

**Implementation**:
- Server returns HTML (not JSON) for all AJAX requests
- HTML includes links and forms for next actions
- Client (Alpine.js) swaps HTML into DOM
- State lives in HTML attributes (`data-*`, Alpine `x-data`)
- No client-side routing or state management needed

**Benefits**:
- Simpler client code
- Server controls UI flow
- Better SEO (server-rendered HTML)
- Progressive enhancement
- Easier to test

### Service Object Pattern

**Pattern**: Extract complex business logic into service objects

**When to Use**:
- Google Calendar operations (create, update, sync)
- Notification sending (email, WhatsApp)
- File upload processing
- Multi-step workflows

**Structure**:
```ruby
class ServiceName
  def initialize(params)
    @params = params
  end
  
  def call
    # Business logic here
    # Return result object or raise error
  end
end
```

**Benefits**:
- Testable in isolation
- Reusable across controllers/jobs
- Single responsibility
- Easy to mock in tests

### Background Job Pattern

**Pattern**: Use Solid Queue (Rails 8 default) for async operations

**When to Use**:
- Email sending
- WhatsApp messages
- Google Calendar sync
- File processing
- Data cleanup
- Homework overdue checks

**Structure**:
```ruby
class JobName < ApplicationJob
  queue_as :default
  
  def perform(*args)
    # Job logic here
  end
end
```

**Benefits**:
- Non-blocking requests
- Automatic retries
- Database-backed (uses SQLite3)
- No Redis dependency
- Built into Rails 8
- Simple monitoring through Rails console

## Best Practices

### Rails 8.0 Specific

- Use `vite_rails` for JavaScript bundling and asset pipeline (modern, fast)
- Use Vite for Alpine.js, alpine-ajax, and other JavaScript dependencies
- Use `solid_queue` for background jobs (built-in, database-backed)
- Use `solid_cache` for caching (database-backed, optional)
- Follow Rails 8 conventions for credentials management
- Use `ActiveRecord::Encryption` for sensitive data
- No Redis needed - Rails 8 provides database-backed alternatives

### Testing Strategy

- **Model specs**: Validations, associations, scopes, methods
- **Request specs**: Integration tests for full request/response cycle
- **System specs**: End-to-end tests with Capybara (critical user flows)
- **Service specs**: Unit tests for service objects
- **Component specs**: ViewComponent rendering and logic
- **Job specs**: Background job behavior

### Security Considerations

- Use strong parameters in controllers
- Implement CSRF protection (Rails default)
- Validate file uploads (type, size, content)
- Scan uploaded files for viruses
- Encrypt sensitive data (OAuth tokens, API keys)
- Use HTTPS in production
- Implement rate limiting for API endpoints
- Sanitize user input in views
- Use Pundit for authorization checks
- Regular security audits with Brakeman

### Performance Optimization

- Use database indexes strategically
- Implement caching for expensive queries
- Use eager loading to avoid N+1 queries
- Optimize images (ActiveStorage variants)
- Use CDN for static assets
- Implement pagination for large lists
- Use background jobs for slow operations
- Monitor with APM tool (New Relic, Scout, Skylight)

## Technology Stack Summary

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Language** | Ruby 3.3+ | Application code |
| **Framework** | Rails 8.0 | Web framework |
| **Database** | SQLite3 | Primary data store |
| **Asset Pipeline** | Vite (vite_rails) | JavaScript bundling, HMR |
| **Background Jobs** | Solid Queue (Rails 8) | Async job processing |
| **Caching** | Rails cache / Solid Cache | Application caching |
| **Frontend** | Alpine.js 3.x | Client-side interactivity |
| **AJAX** | alpine-ajax | Server communication |
| **CSS** | Tailwind CSS 4 + DaisyUI 5 | Styling framework |
| **Components** | ViewComponent | Reusable UI components |
| **Auth** | Devise | Authentication |
| **Authz** | Pundit | Authorization |
| **Email** | ActionMailer + Solid Queue | Email delivery |
| **Storage** | ActiveStorage (local/S3) | File uploads |
| **Calendar** | Google Calendar API | Calendar integration |
| **Messaging** | Twilio WhatsApp API | WhatsApp messages |
| **Testing** | RSpec + FactoryBot + Capybara | Test suite |
| **Quality** | RuboCop + Brakeman | Code quality, security |

## Next Steps

Phase 0 research complete. Proceed to Phase 1:
1. Generate data model (data-model.md)
2. Define API contracts (contracts/)
3. Create quickstart guide (quickstart.md)
4. Update agent context files
