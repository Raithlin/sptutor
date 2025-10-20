# SmartyPants Tutor

A Rails application for Smarty Pants Tutoring.

## Requirements

* **Ruby version:** 3.4.2
* **Rails version:** 8.0.3
* **Database:** SQLite3 (>= 2.1)

## System Dependencies

* Ruby 3.4.2
* Bundler
* SQLite3
* Node.js (for asset pipeline)

## Setup

To set up the application for development:

```bash
bin/setup
```

This will:
- Install Ruby dependencies
- Prepare the database
- Clear logs and temporary files
- Start the development server

## Database

The application uses SQLite3 for all environments:
- **Development:** `storage/development.sqlite3`
- **Test:** `storage/test.sqlite3`
- **Production:** `storage/production.sqlite3`

### Database Creation and Initialization

```bash
bin/rails db:prepare
```

## Running the Application

Start the development server with:

```bash
bin/dev
```

This runs both the Rails server and Tailwind CSS watcher via Foreman.

Alternatively, run the Rails server directly:

```bash
bin/rails server
```

## Running the Test Suite

The application uses RSpec for testing:

```bash
bundle exec rspec
```

## Deployment

The application is configured for deployment using [Kamal](https://kamal-deploy.org/):

```bash
kamal deploy
```

See `config/deploy.yml` for deployment configuration.
