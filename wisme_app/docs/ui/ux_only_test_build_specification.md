🧪 Wisme – UI/UX-Only Test Build Specification
________________________________________
🎯 Purpose
 Create a fully navigable version of the Wisme app to test and validate UI/UX, design system, routing, and user flows without relying on live services like Supabase, Firebase, or API keys.
________________________________________
🚧 What This Version Does
Feature	Behavior
Authentication	Skipped. App opens directly to onboarding or dashboard
Backend APIs	Not called. All screens use static or fake data
Navigation	Fully supported using test route file
Animations / Transitions	Fully functional as in production
Dynamic Widgets	Shown using static examples from local mock files
Personalization / AI Coach	Hardcoded names, avatars, and voices; no customization persistence
Lessons / Journeys	Uses placeholder data to simulate UI state
Mood Toggle (Kai/Vee)	Static toggle, UI-only
Ask-the-Coach	Mock chat UI only
Journey State	Simulated progress and milestone states
Feedback / Emoji Reactions	UI-only version
________________________________________
📁 Folder Structure Additions
/lib/
├── ui_test/
│   ├── main_ui_test.dart         # Entry point for UI-only app build
│   ├── nav_test_router.dart      # Mirror of real routes with debug flows
│   ├── fake_data.dart            # Mock content for testing lessons, coaches
│   ├── dev_jump_screen.dart      # Fast nav for internal testing
│   ├── fake_states.dart          # Empty/loading/error state providers
│   └── mock_widgets/             # Widgets with hardcoded behavior (e.g., mock CoachCard)

________________________________________
🧪 Screen Behavior in Test Build
Screen	Behavior / Notes
Onboarding	Navigable directly; no preferences stored
Intent Selection	Dummy cards; navigates to next
Category Preferences	Static icons; values not persisted
Dashboard	Loads with mock "up next" and dummy coaches
Coaches Page	Sample coach cards, fixed selection state
Learning Journey	Fixed list of 5 lessons; show TL;DR, audio mock icon
Lesson View	Transcript shown; play button triggers mock playback animation
Ask the Coach	Fake chat UI with sample Q&A
Library	Shows mock bookmarked and completed lessons
Search / Explore	Fake trending tags and result items
Settings	Navigable UI, but values are not saved or synced
Profile	Static info; update button does not persist
________________________________________
🧪 UI State Testing Scenarios
●	✅ Empty State for Library, Coaches, Bookmarks

●	✅ Loading State with shimmer animations

●	✅ Error State for failed fetch simulations

●	✅ Completed State for journeys and streaks

Use fake_states.dart to simulate these variants.
________________________________________
🎨 Theming & Device Contexts
●	✅ Light/Dark Mode Toggle

●	✅ Font Scaling / Accessibility support

●	✅ Responsive Layout (phone/tablet)

●	✅ Optional RTL mode support

________________________________________
🔍 Navigation Coverage Checklist
Ensure the test build supports:
●	All onboarding screens

●	Topic input + coach selection

●	Learning journey map view

●	Daily audio lesson playback simulation

●	Ask-the-Coach interface

●	Coach cards and personalization

●	Bookmarked + completed lesson pages

●	Settings, Profile, and Mood Selector

●	Search & Explore with previews

Use dev_jump_screen.dart for fast internal screen switching.
________________________________________
🔧 Build & Run
Run the app with the test build entry point:
flutter run -t lib/ui_test/main_ui_test.dart

You can also configure flavors for easier switching between builds (optional).
________________________________________
🏷️ Visual Debug Markers (Optional)
●	Add [UI TEST] tag in AppBar or corner overlay

●	Use color badges on mock widgets (e.g. gray avatar borders)

●	Show banner in debug mode: UI TEST BUILD

________________________________________
🔐 Safeguards
●	Debug-only assertions to prevent test routes from leaking into production

●	Ensure main_ui_test.dart is excluded from release builds

●	Avoid bundling test assets and fake data in production

________________________________________
✅ Benefits
●	Iterate rapidly on UI/UX without backend

●	Enable PMs/designers to validate flows

●	Unblock animation, theming, and layout review

●	Fully isolated from business logic and state syncing

________________________________________
