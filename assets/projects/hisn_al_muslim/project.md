# Hisn Al Muslim (حصن المسلم)

## Overview
**Hisn Al Muslim** (Hesn Al Muslim) is a production-grade Islamic application built with Flutter (v3.1.0). It serves as a comprehensive spiritual tool, integrating the Holy Quran, Adhkar, Prayer Times, Adhan scheduling, Qibla, and more. The project is designed with a strong focus on **Offline Experience**, **Material 3 design**, and **High Performance**.

## Engineering Highlights
- **Native Android Scheduling:** Developed a custom `AdhanScheduler` using Android Native Kotlin, `AlarmManager`, and `WorkManager` to overcome the limitations of cross-platform notification plugins.
- **Sliding Window Logic:** Implemented a sophisticated "Sliding Window" for Adhan scheduling (7-day window) to ensure 100% reliability while optimizing battery consumption.
- **Dynamic Temporal UI:** The interface evolves throughout the day based on the current prayer time, using a custom Material 3 theme called **Noor M3**.
- **Offline-First:** Supports automatic downloading of Quran JSON and assets on first launch to ensure full functionality without an internet connection.

## Architecture & Technology
- **Framework:** Flutter with `flutter_bloc` for state management.
- **Native Layer:** Kotlin for deep Android integration (AlarmManager, Foreground Services).
- **Storage:** SQLite (`sqflite`) for Quranic data and `SharedPreferences` for user settings.
- **Networking:** `Dio` for fetching prayer times via AlAdhan API and recitations via Quran Cloud.

## Challenges & Solutions
- **Challenge:** Notification duplication and reliability issues on newer Android versions.
- **Solution:** Hardened the scheduling logic in the Native layer and implemented correct Foreground Service declarations and Exact Alarm policies.
- **Challenge:** Managing app size with high-quality assets.
- **Solution:** Optimized app size (70-90 MB) through Minification, asset shrinking, and optimizing splash/icon resources.

## Audit & Readiness
The project underwent a rigorous technical audit, achieving high scores in Architecture (88/100) and Performance (70/100). It is hardened for production and store release.
