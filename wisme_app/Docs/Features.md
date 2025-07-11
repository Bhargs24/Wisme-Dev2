📚 Wisme — Full Feature Breakdown (2025)
________________________________________
✅ CORE FEATURES (MUST-HAVE for MVP)
These define Wisme’s core value: AI-powered daily learning via smart, personalized voice content.
1. AI-Powered Learning Coaches
●	Users can create & name multiple coaches

●	Each coach has a fixed tone, personality, and voice

●	Coaches remember user preferences, tone, learning progress

●	Feels like a smart friend, not a generic chatbot

2. Open Topic Entry + Smart Categorization
●	Users type any topic (e.g., “crypto”, “how to train a dog”)

●	AI classifies into one of 16 content categories

●	AI determines appropriate knowledge levels based on context

3. Predefined Knowledge Levels (Dynamic per Category)
For each category, 3–4 tailored levels such as:
●	🔹 Core Concepts

●	📈 Case Studies / Advanced Models

●	🛠 Tools & Trends

●	🎛 Bit of Everything (Balanced Mix)

4. Curriculum Generation (Learning Journey Mode)
●	AI builds a structured multi-day plan per topic + level

●	Combines cached + new audio lessons to form a smart path

●	Users progress through curated episodes over time

5. Daily Podcast-Style Audio Episodes
●	5–12 min audio episodes per day

●	Human-like voice via ElevenLabs

●	Feels like a personalized podcast, not a lecture

6. Voice Format Options (Solo vs. Multi-Voice)
●	Users choose between:

○	🎙 Solo Coach

○	🎧 Podcast Duo: e.g. "Coach + Curious Friend"

●	Switchable mid-journey

7. User Profiles + Progress Tracking
●	Track learning streaks, history, completed episodes

●	Coach-specific tracking

●	Episode bookmarking, saving for review

8. Backend Audio Storage Logic
●	Every audio clip stored with:

○	Category

○	Topic

○	Subtopic

○	Knowledge level

○	Hashtags

○	Coach voice

●	AI searches based on hashtags and similarity for reuse

●	Dynamic personalization (reorders segments, rephrases slightly)

________________________________________
✨ DELIGHTER FEATURES (Enhancers)
Make learning addictive, sticky, and habit-forming.
9. Smart Hashtag-Based Content Retrieval
●	Every lesson is tagged with relevant #topics, #knowledgelevel, #coachvoice

●	AI generates new hashtags from user topic input and retrieves matching content

●	Ranking algorithm finds most relevant content based on similarity

10. Avoiding Repetition System
●	Tracks what each user has already learned

●	Ranks unseen or semi-relevant lessons higher

●	Prevents serving duplicate episodes even if topic overlaps

11. Coach Growth System
●	Coaches “level up” with you

●	Unlock new dialogue styles, teaching formats, or tones

●	Adds emotional connection and gamification

12. Dynamic Book Mode (Page-by-Page Learning)
●	Users upload or pick a book

●	AI breaks it down page by page

●	Coach teaches, explains, and quizzes with context

●	Works with open-source or licensed books

13. Daily Recaps & Quiz Mode
●	End of each session includes TL;DR summary

●	Optional mini-quiz to reinforce knowledge

●	Retention-focused interaction

14. "Wisme Wrapped" Recap System
●	Monthly or yearly report of what you’ve learned

●	Breakdown by category, level, time spent

●	Social sharing options to show off progress

________________________________________
🚀 DIFFERENTIATOR FEATURES (Wisme-Only Uniques)
These make Wisme stand apart from NotebookLM or Duolingo.
15. Coach Collaboration Mode
●	Two coaches debate or co-teach a topic

●	E.g., “Stoic vs. Hustler” on productivity

●	Dynamic teaching formats

16. AI Mood Awareness (Optional)
●	System detects user mood (from choices, typing, voice tone)

●	Adjusts delivery style to match energy

●	E.g., calming tone during late night, upbeat in morning

17. Offline Mode
●	Download episodes or journeys

●	Key for school accessibility or travel

18. Community Curation (Future)
●	Users or creators can share their learning journeys

●	Public coach profiles or topic playlists

●	Collaborative learning via shared tracks

19. Book Publisher Integrations
●	Create premium AI-coached learning journeys from books

●	Author-curated commentary or summary tracks

________________________________________
🛠 BACKEND + TECH FEATURES
🧠 Smart Hashtag Content Matching Engine
●	Topics are tagged with rich metadata (hashtags + category + level)

●	When a new request comes in:

○	AI generates hashtags based on input

○	Matches against DB entries

○	Uses semantic ranking (embedding similarity)

●	If high similarity content exists → reuse with slight personalization

●	If not → generate fresh content

🧠 Audio Storage Strategy
●	Tree structure: /category/topic/lesson_name/

●	Each lesson stores:

○	Audio URL

○	Transcript

○	Tags

○	Coach voice

○	Version (to handle updates/personalizations)

●	Efficient caching to avoid duplicate generation

🔁 Content Reuse Logic
●	Segments reused if user hasn’t encountered it

●	Reordered or rephrased slightly for freshness

●	Personalized to coach voice or user style

🧠 Intent Detection Engine
●	Classifies vague topics (e.g. “dogs” → training, evolution, behavior)

●	Asks clarifying questions if needed

●	Categorizes topic correctly before lesson generation

________________________________________
📐 Future-Ready Vision
●	🧠 Real-time conversational learning with coach (voice-based)

●	🥽 Mixed Reality classroom integration (via your own MR headset)

●	🧑‍🤝‍🧑 Group journeys: Learn together with friends/classmates

●	✍️ AI journal assistant to summarize weekly learnings


