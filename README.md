# Wisme, Phase 2

**The second build of the app that became [Wivme](https://wivmeai.com),** and the point where it moved onto a real backend. Two Flutter apps in one repo: the main learning app, and a stripped-down demo used for research sessions.

Built August 2025, under the original "Wisme" spelling. Not maintained.

> **This repository is private and should stay private.** An OpenAI API key was committed to `wisme_app2/lib/config/api_keys.dart` and to two of the setup guides, and it is still in the git history. Making the repo public would expose it. Revoke the key and rewrite the history before considering otherwise.

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
