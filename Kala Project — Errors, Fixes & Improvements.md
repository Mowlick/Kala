# Kala Project — Errors, Fixes & Improvements

## Objective

Analyze the existing Kala Flutter project and implement **all the fixes and improvements listed below**.

These requirements are based on the existing code review of the project.

The AI must:

1. Locate each mentioned file.
2. Verify the reported issue in the actual code.
3. Implement the recommended fix.
4. Preserve existing functionality and UI.
5. Avoid unnecessary rewrites.
6. Test the affected functionality after making changes.
7. Report any issue that could not be fixed.

**Do not only provide recommendations. Make the changes directly in the project files.**

---

# 1. CRITICAL ERRORS

## ERROR-001 — Hardcoded Supabase Credentials

### File

```text
main.dart
```

### Problem

`SUPABASE_URL` and `SUPABASE_ANON_KEY` are currently hardcoded as default values in the source code.

### Why this is a problem

- Backend configuration is exposed in source code.
- It creates security and deployment risks.
- Different environments cannot easily use different configurations.
- Credentials/configuration should not be committed directly into application source.

### Required Fix

Remove the hardcoded Supabase values from `main.dart`.

Use secure environment/build-time configuration instead.

For example, if appropriate for the existing project:

```dart
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
```

Do not replace the existing hardcoded values with another hardcoded value.

### Additional Requirements

- Check `.gitignore`.
- Add/update `.env.example` if the project uses `.env`.
- Document the required Supabase configuration in `README.md`.
- Never expose the actual credentials in the final report.
- If the credentials have already been committed to a public repository, recommend rotating them.

---

# 2. ERROR-002 — Invalid Default Widget Test

### File

```text
widget_test.dart
```

### Problem

The current test is the default Flutter counter-app test and does not correspond to the Kala application.

### Why this is a problem

The test provides no meaningful coverage and may fail because Kala does not contain the default counter widget.

### Required Fix

Remove the default counter test.

Replace it with meaningful tests for the actual Kala application.

At minimum, add tests covering relevant:

- Authentication behavior
- Splash navigation
- Onboarding behavior
- Controller behavior
- Important application workflows

Do not create fake tests simply to increase test coverage.

---

# 3. ERROR-003 — Default README

### File

```text
README.md
```

### Problem

The README still contains Flutter starter/template content.

### Required Fix

Replace it with documentation specific to Kala.

The README should include:

- Project description
- Main features
- Technology stack
- Project structure
- Flutter/Dart requirements
- Supabase configuration
- Environment setup
- Installation steps
- Running instructions
- Testing instructions
- Build instructions

Do not include real API keys or Supabase credentials.

---

# 4. BUG-001 — Student Onboarding Has No Real State/Persistence

### Files

```text
student_onboarding_screen.dart
```

and related controllers/models.

### Problem

The student onboarding flow contains static/placeholder values and does not properly capture user input into application state or persist it.

### Current Behavior

The user can move through onboarding without the entered information being properly stored.

### Expected Behavior

The onboarding process should:

```text
User Input
    ↓
Form State
    ↓
Validation
    ↓
Application State
    ↓
Persistence
    ↓
Successful Navigation
```

### Required Fix

Implement actual form state.

Use the existing project architecture, preferably Provider/controllers where appropriate.

For input fields:

- Capture user input.
- Store the values.
- Validate required fields.
- Create/update the appropriate model.
- Persist the information.
- Update local state.
- Navigate only after successful persistence.

### Important

Do not redesign the existing onboarding UI unless necessary.

---

# 5. BUG-001 — Organizer Onboarding Has No Real State/Persistence

### File

```text
organizer_onboarding_screen.dart
```

### Problem

The organizer onboarding flow also uses static/placeholder values and does not properly persist user input.

### Required Fix

Implement the same real workflow as student onboarding:

```text
User Input
    ↓
Form State
    ↓
Validation
    ↓
Organizer Model/State
    ↓
Persistence
    ↓
Navigation
```

Add:

- Input state
- Validation
- Loading state
- Error handling
- Persistence
- Successful navigation

Do not navigate if saving the data fails.

---

# 6. BUG-002 — Incomplete and Inconsistent Data Persistence

### File

```text
event_controller.dart
```

### Problem

Supabase inserts for:

- Events
- Opportunities
- Forms
- Submissions

only persist a limited subset of fields.

Local seeded/mock data may also differ from the backend data structure.

### Risk

This can result in:

- Incomplete database records.
- Data loss.
- Inconsistent local/backend state.
- Incorrect IDs.
- Problems when retrieving persisted data later.

### Required Fix

Inspect the relevant models and Supabase operations.

Make sure the database payload matches the actual model structure.

Ensure:

- Required fields are persisted.
- IDs are generated consistently.
- Database-generated IDs are used where appropriate.
- The returned database record is used to update local state.
- Local and backend models remain consistent.

### Desired Flow

```text
Model
 ↓
Validation
 ↓
Supabase Payload
 ↓
Database
 ↓
Persisted Record
 ↓
Model
 ↓
Local State
```

Do not silently discard important model fields.

---

# 7. BUG-003 — Hardcoded Route Strings

### File

```text
app_router.dart
```

### Problem

The project relies on static named route strings across multiple screens.

### Risk

A typo in a route name can cause runtime navigation failures.

### Required Fix

Create centralized route constants.

For example:

```dart
class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const organizerHub = '/organizer';
}
```

Use these constants throughout the application.

Do not change the actual navigation behavior unnecessarily.

---

# 8. BUG-004 — Ambiguous Authentication Roles

### File

```text
auth_screen.dart
```

### Problem

The current implementation uses:

```text
artist
organization
```

in the UI/selection logic while internally mapping them to:

```text
student
organizer
```

### Risk

This creates ambiguity between:

- UI terminology
- Application logic
- Database values

### Required Fix

Normalize the internal role representation.

Prefer an enum if compatible with the current architecture:

```dart
enum UserRole {
  student,
  organizer,
}
```

Use consistent internal values throughout the application.

UI labels may remain human-friendly.

For example:

```text
UI:
Artist
Organization

Internal:
student
organizer
```

If the database already expects `student` and `organizer`, preserve those database values.

---

# 9. SECURITY-001 — Supabase Configuration Exposure

### File

```text
main.dart
```

### Problem

Supabase configuration is exposed directly in source.

### Required Fix

This is related to ERROR-001 and must be fixed as part of the same implementation.

Requirements:

- Remove hardcoded configuration.
- Use environment/build configuration.
- Document setup.
- Never commit secrets.
- Recommend credential rotation if actual secrets have been publicly exposed.

---

# 10. SECURITY-002 — Debug Logging May Expose Internal Information

### Files

```text
auth_controller.dart
event_controller.dart
```

### Problem

`debugPrint` and exception output may expose internal application/backend information.

### Risk

Production logs could expose:

- Database errors
- Internal implementation details
- User-related information
- Authentication-related information

### Required Fix

Review all debug/error logging.

Use structured or controlled logging where appropriate.

Do not log:

- Passwords
- Tokens
- API keys
- Authentication credentials
- Sensitive personal information

User-facing errors should be safe and understandable.

Technical exception details should not be shown directly to users.

---

# 11. PERFORMANCE-001 — Supabase Realtime Subscription

### File

```text
event_controller.dart
```

### Problem

Supabase realtime is initialized when the controller is created, even when the relevant event functionality may not be active.

### Impact

This may cause:

- Unnecessary network connections.
- Unnecessary backend activity.
- Increased resource usage.
- Additional startup overhead.

### Required Fix

Initialize realtime only when required.

Preferred behavior:

```text
Controller Created
       ↓
No Realtime Connection
       ↓
Feature Requires Realtime
       ↓
Subscribe
       ↓
Feature No Longer Needed
       ↓
Unsubscribe
```

Ensure subscriptions are:

- Not duplicated.
- Properly disposed.
- Not left running unnecessarily.

Do not break existing realtime functionality.

---

# 12. PERFORMANCE-002 — Repeated Derived List Filtering

### File

```text
student_profile_controller.dart
```

### Problem

The following derived lists may be recalculated every time they are accessed:

- `featuredItems`
- `drafts`

### Impact

This causes repeated list filtering and can become inefficient as the portfolio grows.

### Required Fix

Inspect the actual implementation.

If recalculation is unnecessary, optimize it by:

- Caching derived values.
- Recalculating only when portfolio data changes.
- Maintaining derived state.

### Important

Do not introduce stale data.

Correctness is more important than optimization.

---

# 13. QUALITY-001 — Update Project Metadata

### File

```text
pubspec.yaml
```

### Problem

Generic Flutter starter metadata remains in the project.

### Required Fix

Update:

- Project name
- Description
- Relevant metadata

to accurately represent Kala.

Do not blindly change dependency versions.

---

# 14. QUALITY-002 — Separate UI and Business Logic

### File

```text
auth_screen.dart
```

### Problem

The screen contains both UI layout and authentication/business logic.

### Required Fix

Refactor only where necessary.

Keep UI responsibilities in the screen:

- Widgets
- Layout
- User interaction
- Visual states

Move/keep business responsibilities in controllers/services:

- Authentication
- API calls
- Role handling
- Loading state
- Error state
- Business logic

Use the existing Provider architecture.

Do not replace Provider with another state-management solution.

Do not perform a complete architectural rewrite.

---

# 15. QUALITY-003 — Replace Hardcoded Application Data

### Areas

Inspect multiple screens under:

```text
onboarding
profile
opportunities
organizer
events
```

### Problem

Some screens contain hardcoded/sample application values.

### Required Fix

Identify which values are actual application data versus intentional static UI content.

Keep static UI content such as:

- Headings
- Button labels
- Navigation labels
- Empty-state messages

Replace hardcoded application data such as:

- User information
- Profiles
- Events
- Opportunities
- Applications
- Portfolio data

with model/controller/provider/backend data where appropriate.

---

# 16. QUALITY-004 — Project Documentation

### File

```text
README.md
```

### Required Fix

Create proper Kala documentation.

Include:

## Project Overview

Explain what Kala does.

## Features

List the main features.

## Tech Stack

Document Flutter, Provider, Supabase, and relevant dependencies.

## Project Structure

Explain the major folders/features.

## Requirements

Document required Flutter/Dart versions where available.

## Supabase Configuration

Explain how to provide:

```text
SUPABASE_URL
SUPABASE_ANON_KEY
```

without exposing actual values.

## Installation

Document:

```bash
flutter pub get
```

## Running

Document:

```bash
flutter run
```

## Testing

Document:

```bash
flutter test
```

## Analysis

Document:

```bash
flutter analyze
```

---

# 17. MISSING-001 — Onboarding Validation and Persistence

### Area

Student and organizer onboarding.

### Required Implementation

Both onboarding flows must have:

- Real form state.
- Required-field validation.
- Appropriate input validation.
- Persistence.
- Loading state.
- Error state.
- Successful navigation.

The user should not be able to complete onboarding successfully if required data cannot be saved.

---

# 18. MISSING-002 — Meaningful Automated Tests

### Area

Testing.

### Required Tests

Add tests for:

### Authentication

- Login.
- Signup.
- Logout.
- Role assignment.
- Authentication errors.

### Splash

- Authenticated user.
- Unauthenticated user.

### Onboarding

- Form validation.
- Successful submission.
- Failed submission.
- Navigation.

### EventController

- Add event.
- Add opportunity.
- Submit application.
- Persistence.
- Error handling.

### StudentProfileController

- Profile completion score.
- Portfolio updates.
- Featured items.
- Drafts.

Do not use real secrets in tests.

If Supabase needs to be tested, use an appropriate mock/fake/service abstraction where possible.

---

# 19. MISSING-003 — Environment Setup Documentation

### Area

Project configuration.

### Required Fix

Document how developers configure Supabase.

Provide an example configuration without real secrets.

If using Dart defines, document the appropriate command.

If using `.env`, document:

- Required variables.
- `.env.example`.
- `.gitignore`.

---

# 20. DEPENDENCY CHECK

### File

```text
pubspec.yaml
```

### Current Assessment

No direct evidence of incompatible dependencies was identified in the review.

### Required Action

Do not blindly update packages.

Run:

```bash
flutter pub outdated
```

Review the results.

Only make dependency changes if there is a clear:

- Compatibility issue.
- Security issue.
- Build issue.
- Maintenance reason.

Then run:

```bash
flutter pub get
```

---

# 21. TESTING REQUIREMENTS

Implement tests for:

1. Auth signup/signin.
2. Phone/email authentication mode where applicable.
3. Authentication error display.
4. Splash navigation.
5. Authenticated navigation.
6. Unauthenticated navigation.
7. Role assignment.
8. Logout.
9. Student onboarding.
10. Organizer onboarding.
11. Event persistence.
12. Opportunity persistence.
13. Application submission.
14. Profile completion.
15. Portfolio updates.

---

# 22. VALIDATION AFTER CHANGES

After implementing the fixes, run:

```bash
flutter analyze
```

Then:

```bash
flutter test
```

Then:

```bash
dart format .
```

If possible, also verify that the application builds successfully.

For example:

```bash
flutter build apk --debug
```

Do not claim a command passed unless it was actually executed.

---

# 23. IMPORTANT IMPLEMENTATION RULES

## Do

- Inspect the existing implementation first.
- Fix the reported issues.
- Preserve existing functionality.
- Preserve the existing UI wherever possible.
- Reuse existing models/controllers.
- Reuse Provider.
- Reuse Supabase.
- Add tests.
- Improve error handling.
- Keep changes focused.
- Verify the changes.

## Do Not

- Rewrite the entire project.
- Replace Flutter.
- Replace Provider.
- Replace Supabase.
- Remove existing features unnecessarily.
- Change the UI unnecessarily.
- Add unnecessary dependencies.
- Upgrade all dependencies blindly.
- Hardcode credentials.
- Expose secrets.
- Remove failing tests just to make tests pass.
- Claim something was fixed without verifying it.

---

# 24. IMPLEMENTATION ORDER

Make the changes in this order:

### Step 1 — Security

- Remove hardcoded Supabase credentials.
- Implement configuration handling.
- Check for exposed secrets.
- Fix unsafe logging.

### Step 2 — Authentication

- Normalize roles.
- Fix auth state/error handling.

### Step 3 — Onboarding

- Student onboarding.
- Organizer onboarding.
- Validation.
- Persistence.
- Loading/error states.

### Step 4 — Data Persistence

- Fix EventController.
- Align models and Supabase payloads.
- Fix IDs.
- Ensure local state matches persisted state.

### Step 5 — Navigation

- Centralize route constants.

### Step 6 — Code Quality

- Separate auth UI/business logic.
- Replace inappropriate static application data.
- Update `pubspec.yaml`.

### Step 7 — Performance

- Optimize realtime subscription lifecycle.
- Optimize derived lists where necessary.

### Step 8 — Testing

- Replace default widget test.
- Add meaningful tests.

### Step 9 — Documentation

- Rewrite README.
- Add environment setup documentation.

### Step 10 — Verification

Run:

```bash
dart format .
flutter analyze
flutter test
```

and build verification where possible.

---

# 25. FINAL ACCEPTANCE CRITERIA

The project should satisfy all of the following:

- [ ] No hardcoded Supabase credentials.
- [ ] Environment configuration is documented.
- [ ] No secrets are exposed.
- [ ] Unsafe debug logging is addressed.
- [ ] Student onboarding captures actual user input.
- [ ] Organizer onboarding captures actual user input.
- [ ] Onboarding validation works.
- [ ] Onboarding persistence works.
- [ ] Failed persistence does not incorrectly navigate the user.
- [ ] Authentication roles are consistent.
- [ ] Event persistence matches model data.
- [ ] IDs are handled consistently.
- [ ] Routes are centralized.
- [ ] UI/business logic separation is improved where necessary.
- [ ] Static application data is reduced.
- [ ] Realtime subscriptions are managed efficiently.
- [ ] Derived lists remain correct.
- [ ] Project metadata is updated.
- [ ] Default widget test is replaced.
- [ ] Meaningful tests are added.
- [ ] README is updated.
- [ ] Environment setup is documented.
- [ ] `flutter analyze` is checked.
- [ ] `flutter test` is checked.
- [ ] Formatting is applied.
- [ ] Build verification is attempted where possible.

---

# 26. FINAL OUTPUT FROM THE AI

After making the changes, provide a concise report.

## Changes Made

List each implemented fix:

```text
[FIX-001] Supabase credentials secured
[FIX-002] Widget tests replaced
[FIX-003] Student onboarding implemented
[FIX-004] Organizer onboarding implemented
[FIX-005] Authentication roles normalized
[FIX-006] Event persistence corrected
[FIX-007] Routes centralized
[FIX-008] Auth logic refactored
[FIX-009] Realtime lifecycle improved
[FIX-010] Derived lists optimized
[FIX-011] Project metadata updated
[FIX-012] README updated
[FIX-013] Automated tests added
```

For every implemented fix include:

- File(s) changed.
- What was changed.
- Why it was changed.

---

## Verification Results

Report the actual results:

```text
dart format: PASS / FAIL
flutter analyze: PASS / FAIL
flutter test: PASS / FAIL
flutter build: PASS / FAIL / NOT RUN
```

If something fails, explain the exact reason.

---

## Remaining Issues

List any issues that could not be fixed.

For each:

- File
- Problem
- Reason
- Recommended next step

If nothing remains:

```text
No significant remaining issues found.
```

---

## Changed Files

Provide a complete list of files actually modified or created.

Do not list files that were not changed.

---

# FINAL INSTRUCTION

**Inspect the Kala project and then directly implement every applicable error fix and improvement described in this document. Do not merely provide a review or recommendations. Make the changes in the project, verify them with tests/static analysis where possible, and provide the final implementation report.**