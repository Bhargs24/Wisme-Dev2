# 🗂️ PROJECT REORGANIZATION PLAN

## 🔍 CURRENT ISSUES ANALYSIS

### Duplicate Files Found:
1. **Episode Models:**
   - `lib/models/episode.dart` (Supabase-compatible, newer)
   - `lib/core/models/episode.dart` (Legacy, used by content engine)

2. **ContentMetadata Models:**
   - `lib/models/content_metadata.dart` (Supabase tracking)
   - `lib/core/models/content_metadata.dart` (Content engine)

3. **Theme Files:**
   - `lib/shared/themes/app_theme.dart`
   - `lib/core/theme/wisme_theme.dart`

4. **Button Components:**
   - `lib/shared/components/wisme_button.dart`
   - `lib/shared/widgets/wisme_button.dart`

5. **Main Files:**
   - `lib/main.dart` (Current, simple)
   - `lib/main_optimized.dart` (Alternative)

### Empty Folders Found:
- `lib/features/audio_player/` (empty)
- `lib/features/dashboard/` (empty)
- `lib/features/learning_journey/` (empty)
- `lib/features/profile/` (empty)
- `lib/features/search/` (empty)
- `lib/features/topic_personalization/` (empty)
- `lib/features/auth/presentation/widgets/` (empty)

## 🚀 REORGANIZATION STRATEGY

### Phase 1: Model Consolidation
**DECISION:** Use the newer Supabase-compatible models from `lib/models/`
- Keep `lib/models/episode.dart` (backend-ready)
- Keep `lib/models/content_metadata.dart` (production tracking)
- Remove `lib/core/models/` entirely
- Update all imports to point to `lib/models/`

### Phase 2: Component Consolidation
**DECISION:** Use `lib/shared/` as the single source for reusable components
- Keep `lib/shared/themes/app_theme.dart`
- Keep `lib/shared/widgets/wisme_button.dart`
- Remove duplicates from `lib/core/theme/` and `lib/shared/components/`

### Phase 3: Feature Structure Cleanup
**DECISION:** Clean feature architecture
- Remove empty folders that won't be needed soon
- Keep folders that will be needed for Step 3 (auth widgets)
- Consolidate related features

### Phase 4: Import Path Updates
**DECISION:** Update all imports to match new structure
- Update all files to use consolidated models
- Fix import paths in all components
- Ensure consistent import patterns

## 📁 FINAL STRUCTURE TARGET

```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants
│   ├── services/           # Backend services  
│   ├── config/             # Configuration
│   ├── content/            # AI content generation
│   └── utils/              # Helper functions
├── models/                 # All data models (consolidated)
│   ├── episode.dart
│   ├── content_metadata.dart
│   ├── episode_engagement.dart
│   └── user_learning_profile.dart
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── audio/             # Audio engine
│   ├── learning/          # Learning flow
│   └── onboarding/        # User onboarding
├── shared/                # Reusable components
│   ├── widgets/           # UI components
│   ├── themes/            # App theming
│   └── utils/             # Shared utilities
└── main.dart              # Single entry point
```

## ⚠️ CRITICAL FILES TO UPDATE
1. All content generation files that use old Episode model
2. All UI components that import from wrong paths
3. Storage and database files
4. Service files with model dependencies

---
**Status:** Ready to execute reorganization
**Risk Level:** Medium - requires careful import updates
**Estimated Time:** 30 minutes with proper execution
