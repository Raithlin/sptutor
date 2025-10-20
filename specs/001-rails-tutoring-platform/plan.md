# Implementation Plan: Rails Tutoring Platform Rewrite

**Branch**: `001-rails-tutoring-platform` | **Date**: 2025-10-20 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-rails-tutoring-platform/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

Rewrite the Smarty Pants Tutoring website in Ruby on Rails with a comprehensive admin system for tutors, students, and parents. The platform will feature a public marketing site, role-based authentication, class scheduling with Google Calendar integration, homework management with file uploads, tutor-parent communication, and email notifications. The technical approach emphasizes server-side rendering with Alpine.js for client interactions, HATEOAS principles, and DaisyUI for styling.

## Technical Context

**Language/Version**: Ruby 3.3+ / Rails 8.0  
**Primary Dependencies**: 
- **Asset Pipeline**: Vite (vite_rails gem) - Modern bundler with HMR
- **Frontend**: Alpine.js (client-side interactions), alpine-ajax (AJAX requests), Tailwind CSS 4, DaisyUI 5 (CSS framework)
- **Backend**: ViewComponent (component-based views), Google Calendar API, Google OAuth2, WhatsApp Business API
- **File Storage**: Local storage to start with, ActiveStorage with cloud storage (AWS S3 or similar) later if we can find a free plan
- **Email**: ActionMailer with background job processing (Solid Queue - Rails 8 default)
- **Background Jobs**: Solid Queue (Rails 8 built-in, database-backed)
- **Caching**: Rails built-in cache (file store or Solid Cache)

**IMPORTANT - Tailwind CSS 4 Breaking Changes**:
- CSS-first configuration (no `tailwind.config.js`)
- Use `@import "tailwindcss"` instead of `@tailwind` directives
- Use `@plugin "daisyui"` to load DaisyUI 5
- Theme configuration with `@theme` directive and CSS variables
- Use `@tailwindcss/vite` plugin with vite_rails

**Vite Setup**:
- Install: `bundle add vite_rails` then `bundle exec vite install`
- Config: `vite.config.ts` with RubyPlugin and tailwindcss plugin
- Dev: `bin/vite dev` for Hot Module Replacement (HMR)
- Build: `bin/vite build` for production assets

**Storage**: SQLite3 (primary database)  
**Testing**: RSpec (unit, integration, request specs), FactoryBot (test data), Capybara (system tests)  
**Target Platform**: Linux server (production), Docker containers (development/deployment)  
**Project Type**: Web application (monolithic Rails app with server-side rendering)  
**Performance Goals**: 
- Page load: <3s for public pages, <2s for authenticated pages
- API response: <200ms p95 for CRUD operations
- Support 100 concurrent users without degradation
- Email delivery: <2 minutes for 99% of notifications

**Constraints**: 
- No Turbo or Stimulus (explicitly excluded)
- Server-side rendering with HATEOAS architecture
- File uploads limited to 10MB default (configurable)
- Google Calendar API rate limits (1 request/second per user)

**Scale/Scope**: 
- Initial: ~50 tutors, ~500 students, ~300 parents
- Growth: Support up to 200 tutors, 2000 students within 2 years
- ~50 views/components, ~20 models, ~30 controllers
- ~15 background job types

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### ✅ I. Test-Driven Development
- **Status**: PASS
- **Evidence**: RSpec configured as testing framework, TDD workflow will be followed for all features
- **Action**: Write tests before implementation for all user stories

### ✅ II. Rails Best Practices
- **Status**: PASS
- **Evidence**: Using Rails 8.0 conventions, MVC architecture, RESTful routing, ActiveRecord idiomatically
- **Action**: Follow Rails generators, naming conventions, and built-in features throughout

### ✅ III. Clean & Modular Code
- **Status**: PASS
- **Evidence**: Service objects planned for complex logic (Google Calendar integration, notifications), ViewComponents for reusable UI
- **Action**: Keep controllers thin, extract business logic to services, use single responsibility principle

### ✅ IV. RSpec Testing Framework
- **Status**: PASS
- **Evidence**: RSpec, FactoryBot, and Capybara configured for comprehensive testing
- **Action**: Write request specs for integration, use factories for test data, organize specs to mirror source

### ✅ V. Code Quality & Maintainability
- **Status**: PASS
- **Evidence**: RuboCop and Brakeman available for quality/security checks
- **Action**: Run quality checks before commits, maintain clear documentation, address technical debt

### Quality Gates Summary
All constitution principles are satisfied. No violations to justify.

## Project Structure

### Documentation (this feature)

```
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```
app/
├── models/                    # Domain models (User, Student, Tutor, Class, Homework, etc.)
├── controllers/               # HTTP request handlers (thin layer)
│   ├── concerns/             # Shared controller behavior
│   ├── public/               # Public marketing site controllers
│   ├── auth/                 # Authentication controllers
│   ├── tutors/               # Tutor dashboard controllers
│   ├── students/             # Student dashboard controllers
│   ├── parents/              # Parent dashboard controllers
│   └── admin/                # Administrator controllers
├── views/                     # ERB templates
│   ├── layouts/              # Application layouts
│   ├── public/               # Public pages
│   ├── tutors/               # Tutor views
│   ├── students/             # Student views
│   ├── parents/              # Parent views
│   ├── admin/                # Admin views
│   └── shared/               # Shared partials
├── components/                # ViewComponents (reusable UI components)
│   ├── ui/                   # Generic UI components (buttons, cards, modals)
│   ├── dashboard/            # Dashboard-specific components
│   ├── calendar/             # Calendar components
│   └── forms/                # Form components
├── services/                  # Business logic and orchestration
│   ├── google_calendar/      # Google Calendar integration
│   ├── notifications/        # Email/WhatsApp notification services
│   ├── whatsapp/             # WhatsApp API integration
│   └── file_upload/          # File upload handling
├── jobs/                      # Background jobs (Sidekiq)
│   ├── notification_jobs/    # Email/notification jobs
│   ├── calendar_sync_jobs/   # Google Calendar sync jobs
│   └── cleanup_jobs/         # Data cleanup jobs
├── mailers/                   # Email templates and mailers
├── helpers/                   # View helpers
├── javascript/                # JavaScript (Alpine.js, alpine-ajax)
│   └── controllers/          # Alpine.js data/behavior
├── assets/                    # Static assets
│   ├── stylesheets/          # CSS (DaisyUI theme)
│   └── images/               # Images
└── policies/                  # Authorization policies (Pundit)

config/
├── routes.rb                  # Application routes
├── database.yml               # Database configuration
├── credentials.yml.enc        # Encrypted credentials (API keys)
└── initializers/              # Framework initializers

db/
├── migrate/                   # Database migrations
└── seeds.rb                   # Seed data

lib/
└── tasks/                     # Custom rake tasks

spec/
├── models/                    # Model specs
├── requests/                  # Request specs (integration tests)
├── services/                  # Service object specs
├── components/                # ViewComponent specs
├── jobs/                      # Background job specs
├── system/                    # System tests (Capybara)
├── factories/                 # FactoryBot factories
└── support/                   # Test helpers and shared examples
```

**Structure Decision**: Monolithic Rails 8.0 application following standard Rails conventions. ViewComponents used for complex reusable UI logic. Service objects handle complex business logic (Google Calendar, notifications). Background jobs process async tasks. Server-side rendering with Alpine.js for client-side interactivity.

**CSS Component Strategy**: Create custom CSS component classes using Tailwind's `@apply` directive to compose utility classes, similar to how DaisyUI creates `.btn` and `.card`. Organize in `app/assets/stylesheets/components/`:
- `buttons.css` - Button variants (`.btn-save`, `.btn-cancel`, `.btn-danger`)
- `cards.css` - Card styles (`.card-homework`, `.card-class`, `.card-feedback`)
- `forms.css` - Form layouts (`.form-standard`, `.form-actions`, `.field-group`)
- `badges.css` - Status badges (`.badge-pending`, `.badge-submitted`, `.badge-overdue`)
- `dashboard.css` - Dashboard widgets (`.stat-card`, `.widget`, `.widget-list-item`)

**Philosophy**: "Compose Tailwind utilities once in CSS, reuse semantic class names everywhere in HTML." This keeps HTML clean, ensures consistency, and makes styling changes easy (edit one CSS file instead of hunting through views).

## Complexity Tracking

No constitution violations. This section intentionally left empty.

## Phase 0: Research (COMPLETE)

✅ **Status**: Complete  
**Output**: [research.md](./research.md)

**Key Decisions**:
- Alpine.js 3.x for client-side interactions
- alpine-ajax for AJAX requests (HATEOAS architecture)
- DaisyUI 5 + Tailwind CSS 3 for styling
- ViewComponent for reusable UI components
- Devise + Pundit for auth/authz
- Google Calendar API for calendar integration
- Twilio WhatsApp API for messaging
- ActiveStorage (local/S3) for file uploads
- ActionMailer + Solid Queue for email delivery
- Solid Queue for background jobs (Rails 8 default, database-backed)
- Rails built-in caching (file store or Solid Cache)
- RSpec + FactoryBot + Capybara for testing

## Phase 1: Design & Contracts (COMPLETE)

✅ **Status**: Complete  
**Outputs**: 
- [data-model.md](./data-model.md) - Complete database schema with 11 entities
- [contracts/routes.md](./contracts/routes.md) - RESTful routes and HATEOAS patterns
- [quickstart.md](./quickstart.md) - Development setup and workflow guide
- `.windsurf/rules/specify-rules.md` - Agent context file updated

**Key Artifacts**:
- **Data Model**: 11 entities (User, Class, Homework, Notification, etc.)
- **Routes**: 60+ endpoints organized by role (public, tutor, student, parent, admin)
- **HATEOAS Patterns**: Server-rendered HTML with Alpine.js integration
- **TDD Workflow**: Comprehensive testing strategy documented

## Phase 2: Task Breakdown (PENDING)

⏳ **Status**: Not started  
**Command**: Run `/speckit.tasks` to generate task breakdown

This phase will decompose the implementation into dependency-ordered, testable tasks.

