<!--
Sync Impact Report:
- Version change: [none] → 1.0.0
- Initial constitution creation for sptutor project
- Principles defined:
  * I. Test-Driven Development (TDD)
  * II. Rails Best Practices
  * III. Clean & Modular Code
  * IV. RSpec Testing Framework
  * V. Code Quality & Maintainability
- Templates status:
  ✅ plan-template.md - Constitution Check section compatible
  ✅ spec-template.md - User scenarios and testing requirements align
  ✅ tasks-template.md - Test-first workflow supported
- No follow-up TODOs
-->

# sptutor Constitution

## Core Principles

### I. Test-Driven Development (NON-NEGOTIABLE)

TDD is the mandatory development workflow for all features and bug fixes:

- Tests MUST be written before implementation code
- Tests MUST fail initially (Red phase)
- Implementation MUST make tests pass (Green phase)
- Code MUST be refactored while keeping tests green (Refactor phase)
- No production code may be committed without corresponding tests
- Test coverage MUST be maintained at meaningful levels (not just metrics)

**Rationale**: TDD ensures code correctness, prevents regressions, and produces
maintainable, well-designed code by forcing consideration of interfaces and edge
cases before implementation.

### II. Rails Best Practices

All code MUST follow established Rails conventions and best practices:

- Follow Rails naming conventions (models, controllers, views, helpers)
- Use Rails generators appropriately for consistency
- Respect MVC separation of concerns
- Use ActiveRecord idiomatically (scopes, validations, associations)
- Follow RESTful routing conventions
- Use Rails helpers and view partials to avoid duplication
- Leverage Rails built-in features before adding gems
- Keep controllers thin, models focused, use service objects for complex logic
- Use Rails migrations for all database schema changes

**Rationale**: Rails conventions provide a shared language and structure that
makes code predictable, maintainable, and accessible to any Rails developer.

### III. Clean & Modular Code

Code MUST be clean, readable, and modular:

- Single Responsibility Principle: Each class/module has one clear purpose
- DRY (Don't Repeat Yourself): Extract common logic into reusable components
- Methods MUST be short and focused (prefer < 10 lines)
- Classes MUST be cohesive (prefer < 100 lines)
- Use meaningful names that reveal intent
- Avoid deep nesting (max 3 levels)
- Extract complex logic into well-named private methods or service objects
- Use modules for shared behavior
- Prefer composition over inheritance
- Keep dependencies explicit and minimal

**Rationale**: Clean, modular code is easier to understand, test, modify, and
debug. It reduces cognitive load and enables confident refactoring.

### IV. RSpec Testing Framework

RSpec is the standard testing framework for all test types:

- Use RSpec for all unit, integration, and request tests
- Follow RSpec best practices (describe/context/it structure)
- Use descriptive test names that document behavior
- One assertion per test when practical
- Use RSpec matchers idiomatically
- Use factories (FactoryBot) for test data, not fixtures
- Use shared examples for common behavior testing
- Mock/stub external dependencies appropriately
- Organize specs to mirror source code structure
- Use request specs for integration testing over controller specs

**Rationale**: RSpec provides expressive, readable tests that serve as living
documentation. Consistent RSpec usage across the project ensures all developers
can read and write tests effectively.

### V. Code Quality & Maintainability

Code quality MUST be maintained through continuous practices:

- Run RuboCop for style and quality checks (fix violations before commit)
- Run Brakeman for security vulnerability scanning
- Keep Gemfile dependencies up to date and minimal
- Document non-obvious code with comments
- Write clear commit messages following conventional commits
- Review your own code before requesting peer review
- Address all test failures immediately
- Refactor when you see duplication or complexity
- Keep technical debt visible and prioritized

**Rationale**: Consistent quality practices prevent code decay, security issues,
and technical debt accumulation. Quality is everyone's responsibility.

## Rails-Specific Standards

### Directory Structure

Follow Rails conventions strictly:

- `app/models/` - Domain models and business logic
- `app/controllers/` - HTTP request handling (thin layer)
- `app/views/` - Presentation templates
- `app/helpers/` - View helpers only
- `app/services/` - Complex business logic and orchestration
- `app/jobs/` - Background job classes
- `lib/` - Non-Rails-specific library code
- `spec/` - All test files mirroring app structure

### Database & Migrations

- All schema changes MUST go through migrations
- Migrations MUST be reversible (define both up and down)
- Never edit committed migrations
- Use database constraints for data integrity
- Index foreign keys and frequently queried columns
- Test migrations in development before committing

### Dependencies

- Prefer Rails built-in solutions before adding gems
- Evaluate gem maintenance status before adding dependencies
- Document why each gem is needed
- Keep Gemfile organized by purpose (group related gems)
- Lock gem versions appropriately

## Development Workflow

### Feature Development Process

1. **Specification**: Define user stories and acceptance criteria
2. **Test Design**: Write failing tests for acceptance criteria (RSpec)
3. **Implementation**: Write minimal code to pass tests
4. **Refactor**: Improve code quality while keeping tests green
5. **Review**: Self-review, then peer review
6. **Integration**: Merge only when all tests pass

### Quality Gates

Before any code is merged:

- ✅ All RSpec tests pass
- ✅ RuboCop violations resolved
- ✅ Brakeman security scan clean
- ✅ Code reviewed and approved
- ✅ Test coverage maintained or improved
- ✅ Documentation updated if needed

### Code Review Standards

All code changes MUST be reviewed:

- Verify TDD workflow was followed (tests exist and are meaningful)
- Check Rails conventions are followed
- Assess code clarity and modularity
- Verify tests adequately cover the changes
- Ensure no security vulnerabilities introduced
- Confirm performance implications considered

## Governance

This constitution supersedes all other development practices and conventions.
All team members MUST follow these principles without exception.

### Amendment Process

Constitution changes require:

1. Written proposal with rationale
2. Team discussion and consensus
3. Version bump following semantic versioning
4. Update of all dependent templates and documentation
5. Communication to all team members

### Compliance

- All pull requests MUST demonstrate compliance with these principles
- Violations MUST be addressed before merge
- Repeated violations require team discussion
- Constitution compliance is part of code review checklist

### Versioning

- **MAJOR**: Backward incompatible principle changes or removals
- **MINOR**: New principles added or significant expansions
- **PATCH**: Clarifications, wording improvements, typo fixes

**Version**: 1.0.0 | **Ratified**: 2025-10-20 | **Last Amended**: 2025-10-20
