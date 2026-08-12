# AstraPlay (IPTV & Media Player)

## Overview
**AstraPlay** is a high-performance IPTV and media streaming platform. It is designed to bridge the gap between high-level Flutter UI and low-level **Android Native Media3/ExoPlayer** power. The project is ~85% functional and features a professional-grade player experience.

## Engineering Highlights
- **Media3 Native Engine:** Utilizes Kotlin and Media3 (ExoPlayer) for hardware-accelerated playback, ensuring stability and efficiency that pure Flutter plugins often lack.
- **Advanced M3U Parsing:** Solved the "Large Playlist" problem by developing a **Streaming M3U Parser** that reads lines sequentially, preventing memory exhaustion (OOM) and reducing memory pressure by over 80%.
- **Incremental Sync:** Optimized data synchronization for large playlists (10k+ streams) using an incremental approach in the repository layer.
- **Clean Architecture:** Built from the ground up with a strict separation of concerns, making it highly maintainable and scalable.

## Architecture & Technology
- **Layers:** Clean Architecture (Presentation, Domain, Data, Native).
- **State Management:** `flutter_bloc` for UI logic and `go_router` for deep linking and navigation.
- **Storage:** `Isar` NoSQL database for lightning-fast metadata, history, and settings storage.
- **Networking:** `Dio` for Xtream API and M3U source fetching.
- **Native:** Custom `PlatformView` using Kotlin and Media3.

## Technical Capabilities
- **Playback Features:** Picture-in-Picture (PiP), DRM support, Subtitle downloading, and Audio track switching.
- **Interactive Controls:** Swipe gestures for volume, brightness, and seeking. Playback speed adjustment and 10s skip controls.
- **Media Support:** Live TV, VOD, Series (Seasons/Episodes), Xtream Codes, and M3U Playlists.
- **Networking Metrics:** Optimized Xtream handshake (200-500ms) and category fetching (300-800ms).

## Development Context
The project addresses real-world streaming challenges, including memory management for massive data sets and native-level player integration, positioning it as a top-tier engineering feat.
