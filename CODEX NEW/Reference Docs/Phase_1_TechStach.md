📦 Wisme Full Stack Tech Stack – Phase 1 (MVP)
Version: 1.0
Goal: Launch a scalable, podcast-style AI audio learning platform for 100K user🛠 Example Episode Generation Pipeline
markdown
Copy
Edit
1. User searches: "Machine Learning for beginners"
2. App maps to → Category: Technology & AI
3. App picks → Voice Pair: Maya + Kai
4. Learning Type: Core Concepts
5. Episode parameters hashed for cache lookup
6. Episode cache hit?
   ⮕ Yes → Return cached episode audio from R2
   ⮕ No → Generate complete episode script
7. Complete episode TTS generation via ElevenLabs
8. Upload complete episode audio to Cloudflare R2
9. Save episode metadata and cache mapping
10. Return playable episode link to frontendListening (Preset Voice Pairs + Fragment Caching)

🧠 Architecture Philosophy
Speed > Flexibility (Preset categories, fixed voices, 2-speaker format)

Cache-first AI generation (Re-use LLM + audio fragments)

Pre-rendered audio playback (No real-time generation)

Low operational complexity (monolith backend, managed infra)

🧩 Core Stack Overview
Layer	Stack / Tools
Frontend	React Native + Expo, TypeScript, Zustand, Lottie (for light animation)
Backend	FastAPI (Python), PostgreSQL, Redis, Celery
TTS	ElevenLabs API (External)
LLM	OpenAI GPT-4 API (External, templated prompts via caching layer)
Storage	Cloudflare R2 (Audio), PostgreSQL (Structured Data), Firebase Firestore
Caching	Redis (Prompt Cache, Episode Hashes), PostgreSQL (Fragment Indexing)
Auth	Firebase Auth + JWT
Payments	Stripe, Razorpay (India)
Infra & Deploy	Render.com (initial), GitHub Actions (CI/CD), Docker Compose (local dev)

🧩 Frontend Stack (Mobile App via React Native)
Tech:
React Native + Expo (Cross-platform)

TypeScript (type safety)

Zustand (lightweight global state)

Lottie (badge animations, loading states)

Axios (API client)

Folder Structure:
bash
Copy
Edit
/app
  ├── screens/          # Search, Player, Library, Profile
  ├── components/       # Reusable UI blocks (AudioCard, BadgeItem, etc.)
  ├── state/            # Zustand stores (user, session, audio playback)
  ├── services/         # API calls (axios wrappers)
  ├── assets/           # Fonts, icons, preset avatars
  └── utils/            # Time formatting, audio helpers, etc.
🧩 Backend Stack (FastAPI Monolith)
Core Architecture:
FastAPI (Python) REST API

Celery + Redis (async episode generation tasks)

PostgreSQL (Users, Episodes, Fragments, Logs)

Redis (Fragment + Prompt Caching)

Cloudflare R2 (Audio file storage)

Modules:
bash
Copy
Edit
/backend
  ├── api/              # FastAPI route handlers
  ├── tasks/            # Celery episode builders
  ├── cache/            # Redis wrapper (prompt, audio fragment hash → ID)
  ├── prompts/          # Jinja2 templates per category + learning type
  ├── audio/            # ElevenLabs client + TTS caching
  ├── models/           # SQLAlchemy models (User, Episode, Fragment, etc.)
  ├── services/         # Core logic orchestration
  └── utils/            # Logging, file ops, rate limiting, etc.
Key Endpoints:
POST /generate → Topic → Prompt Template → LLM → Fragment cache check → TTS

GET /episodes/:id → Fetch + stream pre-rendered audio

GET /categories + GET /types → 15 x 4 preset options

📂 Database Schema (PostgreSQL)
Table	Purpose
User	Firebase-linked account data
Episode	Complete generated learning session (topic + audio file ref)
EpisodeCache	Maps episode parameters to normalized episode hash
AudioCache	Maps episode content → audio URL (for complete episode reuse)
UsageLog	Tracks token and audio costs per user
Feedback	Optional thumbs-up/thumbs-down on episodes

🎧 Caching System (Smart Cost Control)
Episode-Level Caching:
Each complete episode is cached as a single unit

Episode Hash = (topic, category, learning_type, voice_pair)

Reuse complete episodes across similar user requests

Prompt Normalization:
Before sending to LLM, prompts are normalized → hashed

Hash used as cache key (to avoid duplicate LLM calls)

Episode Audio Caching:
Complete TTS audio for entire episode is cached as single file

Audio hosted on Cloudflare R2 (CDN-backed)

🧾 Payment Stack
Stripe for global plans

Razorpay for Indian users

Basic models:

UserPlan (Free, Pro, Premium)

CreditUsage (if using token packs instead of subscriptions)

Webhook support for Stripe events

⚙️ DevOps & Deployment
Environment	Tooling
Local Dev	Docker Compose, Preload Cache
CI/CD	GitHub Actions
Hosting	Render.com (or Railway, Fly.io)
Monitoring	Render Metrics, Sentry (optional)

🔐 Auth & Access Control
Firebase Auth

JWT tokens validated by backend

Rate limiting via Redis token bucket

Access tiers:

Free: Limited generations

Pro/Premium: More minutes + priority queue

🛠 Example Episode Generation Pipeline
markdown
Copy
Edit
1. User searches: “Machine Learning for beginners”
2. App maps to → Category: Technology & AI
3. App picks → Voice Pair: Maya + Kai
4. Learning Type: Core Concepts
5. Prompt template filled with keywords
6. Prompt hash checked in Redis → LLM cache hit?
   ⮕ Yes → Reuse text → TTS cache
   ⮕ No → Generate → Fragmentize → Store
7. TTS cache hit?
   ⮕ Yes → Fetch audio from R2
   ⮕ No → Generate via ElevenLabs → Upload to R2
8. Final episode = stitched fragments
9. Save `Episode` → return playable link to frontend
📈 Scaling Strategy for 100K Users
50–60% reuse rate expected via episode caching

Keep avg cost per episode below $0.80

Precompute popular episodes in background

Run LLM/TTS queue workers on demand (Celery)

Frontend serves streamed audio via CDN

🧱 Summary
Aspect	Status
Interactivity	❌ (Passive only)
Voice customization	❌ (Preset per category)
Real-time sync	❌ (Pre-generated audio only)
Scalability	✅ (via caching + CDN)
Cost Optimization	✅ Smart LLM & TTS reuse
Personalization	🟡 Basic (topic, duration, style)