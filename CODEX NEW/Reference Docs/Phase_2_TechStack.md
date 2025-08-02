# Wisme Phase 2 Full Stack Architecture (Detailed)

This document outlines the complete full-stack architecture for **Wisme**, your conversational AI learning app with real-time TTS, AI-driven coaches, and gamified experiences.

---

## 🧠 Architecture Philosophy

* Modular monolith at early scale → microservices when needed
* Separate compute-heavy services (TTS, LLM, Animation)
* Built for real-time interactions

---

## 🧩 Core Stack Overview

| Layer         | Tech Stack                                                                   |
| ------------- | ---------------------------------------------------------------------------- |
| Frontend      | React Native, Expo, TypeScript, Zustand, Lottie/WebGL (for animated avatars) |
| Backend       | FastAPI (Python), PostgreSQL, Redis, Celery, Stripe                          |
| TTS Inference | ONNX + NVIDIA Triton                                                         |
| AI/LLM        | OpenAI (initial), Router for Together.ai, Anthropic (fallback)               |
| Storage       | Cloudflare R2 (audio), Firebase Firestore (light state), PostgreSQL (core)   |
| Auth          | Firebase Auth → JWTs validated on backend                                    |
| Payment       | Stripe, Razorpay (India)                                                     |
| Deployment    | Render.com → GCP / Lambda / Kubernetes (scale)                               |
| Animation     | Live2D / WebGL / D-ID or DeepMotion (for character facial animation)         |

---

## 🧩 Frontend (React Native + Expo)

### Folder Structure:

```
/app
  ├── screens/            # Topic screens, onboarding, player, profile
  ├── components/         # Reusable UI blocks
  ├── state/              # Zustand stores (user, session, settings)
  ├── services/           # API wrappers (axios)
  ├── assets/             # Fonts, icons, avatars
  └── animations/         # Lottie animations or WebGL components
```

### Key Features:

* Session player UI with chat + audio + coach visuals
* Coach selector + voice preview
* Gamified XP + badge system UI
* Offline support (using local SQLite/cache)

### Animation Support:

* WebView for WebGL avatars (ReadyPlayerMe)
* Lottie for 2D reactions, animated badges
* Future: Unity WebGL or Spine for custom rigs

---

## 🧩 Backend (FastAPI + PostgreSQL + Redis)

### Modules

```
/backend
  ├── api/                # FastAPI route handlers
  ├── models/             # SQLAlchemy DB models
  ├── services/           # Core logic: prompt engine, TTS, gamification
  ├── workers/            # Celery tasks
  ├── schemas/            # Pydantic request/response
  ├── auth/               # JWT auth & Firebase integration
  └── utils/              # Helpers, rate limiters, loggers
```

### Services Breakdown:

#### 1. Prompt Engine

* Templates built with Jinja2
* Memory store → Redis (short-term) + PostgreSQL (long-term)
* Handles multi-coach dialogue orchestration

#### 2. TTS Pipeline

* Celery + Redis queue
* StyleTTS2 model exported to ONNX
* Triton Inference Server runs models on GPU
* Outputs streamed to Cloudflare R2

#### 3. Gamification Engine

* XP, badges, level-ups
* Scheduled tasks (Celery) track engagement
* Events stored in `UserXPEvent`, `UserBadge`

#### 4. Payment & Plans

* Stripe + Razorpay
* `UserPlan`, `CreditPack`, `SubscriptionWebhook`

#### 5. Rate Limiting

* Token bucket limiter with Redis
* Premium/free tiers enforced before LLM or TTS access

---

## 🧩 Database (PostgreSQL)

### Key Tables:

| Table       | Purpose                        |
| ----------- | ------------------------------ |
| `User`      | Basic info + auth link         |
| `UserPlan`  | Subscription status & limits   |
| `Session`   | Tracks one study session       |
| `Message`   | Message logs per session       |
| `AudioFile` | TTS audio linked to messages   |
| `Voice`     | System-provided coach voices   |
| `UserVoice` | Cloned or personalized voices  |
| `UserXP`    | XP progress                    |
| `UserBadge` | Earned badges                  |
| `LLMUsage`  | Tracks token usage per user    |
| `TTSUsage`  | Tracks seconds of TTS per user |

---

## 🧩 Infra / Deployment

### Local Dev

* Docker + Docker Compose
* Run Triton server container with mounted models

### Production

* Start with Render.com or Railway
* Migrate to GCP or AWS when user base grows
* Host Triton on GPU instances (e.g. GCP A100)
* Use Cloudflare for CDN, DNS, and R2 (storage)

### CI/CD

* GitHub Actions
* Auto-test + deploy on merge

---

## 🧩 Additional Character Animation Support

### Avatar Animation Options:

* **Live2D** or **Spine** for light, expressive 2D avatars
* **D-ID API** or **DeepMotion** for video-based animated head
* **WebGL** (ReadyPlayerMe) for real-time avatars in WebView
* TTS output piped into lipsync processor (Rhubarb or AI API)

### Avatar Sync Flow:

1. User triggers response
2. LLM prompt runs → output
3. TTS generated → voice file
4. Lipsync generated via model/API
5. Avatar animation triggered with lip keyframes
6. Frontend renders animation in WebView / Lottie

---

## 🧩 Future-Proofing

* Shift to microservices: `prompt-service`, `tts-service`, `payment-service`
* Move to Kubernetes when needed (Helm + ArgoCD)
* WebRTC audio rooms for group learning (future add-on)

---

Let me know if you want the GitHub repo scaffold next, or a separate infra + DevOps document.
