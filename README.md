# Wisme, Phase 2

**The second build of the app that became [Wivme](https://wivmeai.com),** and the point where it moved onto a real backend. Two Flutter apps in one repo: the main learning app, and a stripped-down demo used for research sessions.

Built August 2025, under the original "Wisme" spelling. Not maintained.

## A note on the history

An OpenAI key and an admin password were committed to this repo during the build. Both have been revoked, and both were purged from every commit in the history before this repository was made public. Nothing here is a live credential. The Firebase values in the committed config are client-side identifiers, which ship in the app by design.

## What is in it

| Path | What |
|---|---|
| [`wisme_app2/`](wisme_app2/) | The main Flutter app. Source under `lib/`, with a `design_system/` and a `config/` layer. |
| `wisme_research_demo_app/` | A cut-down build used to run research sessions. |
| `functions/` | Firebase Cloud Functions. |
| `dataconnect/` | Firebase Data Connect schema and queries. |
| `firestore.rules`, `storage.rules` | Security rules. |
| `WISME_*.md` | Analysis written during the build: architecture and algorithms, codebase review, feature breakdown, and a UI/UX audit. |

## Stack

Flutter and Dart, Firebase (auth, Firestore, storage, functions, Data Connect), an LLM for lesson generation, TTS for audio.

## Status

Archived prototype from August 2025. The Firestore rules here are still the default open template that expired in August 2025, so the backend rejects everything by now. Treat this as a record of the second iteration, not as a runnable app.
