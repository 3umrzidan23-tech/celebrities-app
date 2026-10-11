# Celebrities App — Explore Famous People

A sleek, modern Flutter application built to explore popular celebrities, discover detailed actor biographies, browse high-resolution image galleries, and view movie and TV show credits. Powered by The Movie Database (TMDB) API and Google Gemini AI, designed with a premium Cinematic Dark interface.

---

## Live Demo
> **Status:** Pending Vercel Web Deployment. A live URL will be provided once deployed.

---

## Features

- **Popular People Discovery**: Browse trending and popular actors with paginated infinite scrolling powered by TMDB.
- **Live Search**: Instant celebrity search with automatic debounce handling to optimize network queries.
- **Detailed Profiles**: Rich biographical profiles displaying popularity scores, department, birthday, place of birth, and expandable biography text with complete null-safety.
- **Celebrity Image Gallery**: High-resolution profile photo gallery fetched directly from TMDB.
- **Interactive Full-Screen Image Viewer**: Full-screen photo viewer with pinch-to-zoom controls (`1.0x` to `4.0x` zoom via `InteractiveViewer`), swipe navigation, and page indicators.
- **Device Image Saving**: Download celebrity portraits directly to the device photo library with real-time feedback (supported on Android/iOS via `gal`).
- **Favorites System**: Persistent local favorites bookmarking using `shared_preferences`, with visual indicators across all screens and a dedicated Favorites tab.
- **Filmography & Credits**: Comprehensive movie and TV show credits parsed from TMDB combined credits, deduplicated and chronologically sorted, showcasing release years and character/crew roles.
- **Generative AI Chat Assistant**: In-app AI assistant powered by Google Gemini (`gemini-1.5-flash`), with structured message bubbles, loading animations, and error handling.
- **Adaptive Responsive Design**: Tailored UI supporting both mobile screens (bottom navigation bar) and larger tablet/desktop displays (side navigation rail and constrained content widths).
- **Cinematic Dark Theme**: Custom dark visual style featuring deep navy and charcoal palettes, electric blue accents, and subtle gradient overlays.

---

## Screenshots

> *Screenshots will be added soon.*

---

## Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (SDK `^3.12.2`) & Dart
- **Architecture**: Clean Architecture (Data, Domain, and Presentation layers)
- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (`^9.1.1`) & [equatable](https://pub.dev/packages/equatable) (`^2.1.0`)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it) (`^9.2.1`)
- **Networking**: [dio](https://pub.dev/packages/dio) (`^5.11.0`) with interceptors and logging
- **Network Connectivity**: [internet_connection_checker_plus](https://pub.dev/packages/internet_connection_checker_plus) (`^3.1.1`)
- **Functional Error Handling**: [dartz](https://pub.dev/packages/dartz) (`^0.10.1`)
- **Local Persistence**: [shared_preferences](https://pub.dev/packages/shared_preferences) (`^2.5.5`)
- **Image Caching & Display**: [cached_network_image](https://pub.dev/packages/cached_network_image) (`^4.0.0`)
- **Media & Permissions**: [gal](https://pub.dev/packages/gal) (`^2.3.0`), [permission_handler](https://pub.dev/packages/permission_handler) (`^13.0.1`), [path_provider](https://pub.dev/packages/path_provider) (`^2.1.6`)
- **Typography & Icons**: [google_fonts](https://pub.dev/packages/google_fonts) (`^8.2.1`), [cupertino_icons](https://pub.dev/packages/cupertino_icons) (`^1.0.8`)
- **AI Integration**: Google Gemini API (`gemini-1.5-flash`) via REST & [google_generative_ai](https://pub.dev/packages/google_generative_ai) (`^0.4.7`)

---

## APIs & Endpoints

This application integrates with **The Movie Database (TMDB) API v3** and the **Google Gemini API**:

| Endpoint | Method | Description |
| :--- | :---: | :--- |
| `/person/popular` | `GET` | Fetches a paginated list of trending actors and celebrities. |
| `/search/person` | `GET` | Searches for actors and personalities by name query. |
| `/person/{person_id}` | `GET` | Retrieves full biographical details, birthday, place of birth, and popularity. |
| `/person/{person_id}/images` | `GET` | Fetches available profile photos and gallery images. |
| `/person/{person_id}/combined_credits` | `GET` | Retrieves complete movie and television appearances for cast and crew. |
| `gemini-1.5-flash:generateContent` | `POST` | Interacts with the Gemini model to provide celebrity trivia and chat assistance. |

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/             # API endpoints, routes, and string constants
│   ├── errors/                # Failures, exceptions, and error mappings
│   ├── network/               # Dio ApiClient with interceptors, network checker
│   ├── routes/                # Named navigation router (AppRouter)
│   ├── theme/                 # AppColors, AppTextStyles, theme definitions
│   ├── utils/                 # ResponsiveHelper for adaptive breakpoints
│   └── widgets/               # Reusable UI widgets (PersonCard, loading, error)
├── features/
│   ├── ai_assistant/          # Gemini AI chat cubit, data sources, and chat page
│   ├── favorites/             # Local favorites repository, cubit, and page
│   ├── image_viewer/          # Full-screen image viewer, zoom & gallery downloader
│   └── people/                # Popular actors, search, details, credits & images
├── injection_container.dart   # Service Locator (GetIt) dependency setup
└── main.dart                  # Application entry point
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.12.2` or later)
- [Dart SDK](https://dart.dev/get-dart)
- A TMDB API Key (create a free account at [themoviedb.org](https://www.themoviedb.org/documentation/api))
- A Google Gemini API Key (obtain from [Google AI Studio](https://aistudio.google.com/))

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/3umrzidan23-tech/celebrities-app.git
   cd celebrities-app
   ```

2. **Install project dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   Pass your API keys securely at compile time using `--dart-define`:
   ```bash
   flutter run --dart-define=TMDB_API_KEY=your_tmdb_api_key --dart-define=GEMINI_API_KEY=your_gemini_api_key
   ```

   To run on Flutter Web (Chrome):
   ```bash
   flutter run -d chrome --dart-define=TMDB_API_KEY=your_tmdb_api_key --dart-define=GEMINI_API_KEY=your_gemini_api_key
   ```

---

## Limitations & Security Notes

- **API Secrets**: Never hardcode API keys or commit `.env` files into source control. API keys are injected via `--dart-define` at compile time. Note that client-side apps can be decompiled; for production releases, proxying third-party API calls through a secure backend server is recommended.
- **Platform Image Downloading**: Saving images directly to the system gallery utilizes the `gal` package and native storage permissions, optimized for Android and iOS. On Flutter Web, saving directly to the photo library is subject to browser download capabilities.
- **AI Assistant**: Requires an active network connection and a valid Gemini API key. If no key is supplied, the chat interface displays a connection/server failure state.

---

## Author

**Omar Ahmed Zidan**  
*IT Student | Frontend Developer*  
- GitHub: [@3umrzidan23-tech](https://github.com/3umrzidan23-tech)
