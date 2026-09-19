# EventGo

![Flutter](https://img.shields.io/badge/Flutter-3.12%2B-blue?logo=flutter)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Mobile%20%7C%20Web%20%7C%20Desktop-orange)
![State Management](https://img.shields.io/badge/State%20Management-BLoC-blueviolet)
![DI](https://img.shields.io/badge/DI-get__it-orange)

**EventGo** is a cross-platform Flutter mobile application that unifies event discovery and ticket booking into a single seamless flow. Users browse events sourced from the **Ticketmaster API**, register and authenticate via a **RouteMisr e-commerce backend**, and complete ticket orders in-app without leaving the app.

---

## Table of Contents

- [Demo](#demo)
- [Features](#features)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Business Requirements Document (BRD)](#business-requirements-document-brd)
- [Product Requirements Document (PRD)](#product-requirements-document-prd)

---

## Demo

*(Screenshots and recorded flows will be added here.)*

| Authentication | Event Discovery | Booking Flow |
|---|---|---|
| _Screenshot placeholder_ | _Screenshot placeholder_ | _Screenshot placeholder_ |

---

## Features

### In Scope
- **User Registration & Authentication** — Users create an account and receive a JWT token via the RouteMisr backend. Login flow is defined in routes and will be connected to the auth API.
- **Event Discovery** — Browse events fetched from the Ticketmaster API, including event name, venue, date, and image.
- **Filtering & Search** — Filter events by city, category, and date range.
- **Ticket Selection** — Choose ticket quantity (1–6) for a selected event.
- **Order Checkout** — Submit an order directly within the app (future implementation connected to the RouteMisr e-commerce API).
- **Error Handling** — Centralized, typed error parsing for both the RouteMisr and Ticketmaster APIs.

### Future Enhancements
- User login screen and token persistence
- Payment integration
- Booking history & tickets
- Push notifications for event reminders

---

## Architecture & Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter SDK 3.12+ |
| **State Management** | flutter_bloc (BLoC pattern) |
| **HTTP Client** | Dio |
| **Logging** | pretty_dio_logger |
| **Dependency Injection** | get_it |
| **Image Loading** | cached_network_image |
| **Environment Config** | flutter_dotenv |
| **Internationalization** | intl |
| **Backend — Auth/E-commerce** | RouteMisr (`https://ecommerce.routemisr.com`) |
| **Backend — Event Data** | Ticketmaster (`https://oauth.ticketmaster.com`) |

### Architecture Overview

The project follows a **feature-based clean architecture**:

```
lib/
├── core/                 # Cross-cutting concerns
│   ├── networking/       # Dio, API service, error handling
│   ├── routes/           # Navigation
│   └── di/               # Service locator (get_it)
├── features/
│   └── register/         # Auth feature (data, presentation)
└── event_go.dart         # App root
```

- **Networking** — `ApiService` wraps `DioFactory` and exposes typed `getRequest`, `postRequest`, `putRequest`, `deleteRequest` methods. Errors are parsed through pluggable `ApiErrorParser` implementations (`AuthErrorParser`, `TicketmasterErrorParser`).
- **Repository Pattern** — Each feature exposes a repository (e.g., `RegisterRepo`) that converts raw HTTP responses into `ApiResult` (`Success` / `Error`) objects.
- **Dependency Injection** — `ServiceLocator` (`get_it`) registers lazy singletons for API services (named instances for RouteMisr vs. Ticketmaster), repositories, and (future) BLoCs.
- **Routing** — `AppRouter` maps named routes (`AppRoutes.registerScreen`, `AppRoutes.loginScreen`) to screen widgets.

---

## Project Structure

```
lib/
├── main.dart                    # App entry point — loads .env, runs EventGo
├── event_go.dart                # Root StatelessWidget with MaterialApp
├── core/
│   ├── networking/
│   │   ├── api_constants.dart        # Base URLs & endpoint paths
│   │   ├── api_service.dart          # Generic CRUD HTTP methods
│   │   ├── dio_factory.dart          # Dio configuration & interceptors
│   │   ├── api_result.dart           # Success / Error result wrapper
│   │   ├── app_error.dart            # Typed application error
│   │   ├── api_error_handler.dart    # DioException → AppError mapping
│   │   ├── api_error_parser.dart     # Parser interface
│   │   ├── auth_error_parser.dart    # RouteMisr error parser
│   │   ├── ticket_master_error_parser.dart  # Ticketmaster error parser
│   │   └── api_error_model_route.dart/
│   │       api_error_model.dart       # Error response models
│   ├── routes/
│   │   ├── app_router.dart           # Route generation
│   │   └── app_routes.dart           # Route name constants
│   └── di/
│       └── service_locator.dart      # get_it setup
├── features/
│   └── register/
│       ├── data/
│       │   ├── repos/register_repo.dart
│       │   └── models/
│       │       ├── register_request_model.dart
│       │       └── register_response_model.dart
│       └── presentation/
│           └── ui/register_screen.dart
└── assets/
    ├── images/                   # Static image assets
    └── svgs/                     # SVG icon assets
```

---

## Getting Started

### Prerequisites

- [Flutter](https://docs.flutter.dev/get-started/install) SDK `>=3.12.0 <4.0.0`
- Android Studio / Xcode (for device emulators)
- A Ticketmaster API key
- Internet permission (already declared in Android/iOS manifests)

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd event_ticket_booking

# Install dependencies
flutter pub get

# Run the app
flutter run
```

---

## Configuration

EventGo relies on a `.env` file for secrets. A `.env.example` is provided:

```env
# .env
API_KEY=<your-ticketmaster-api-key>
```

> **Security note:** The `.env` file is listed in `.gitignore` and must never be committed.

---

## Business Requirements Document (BRD)

### Business Objective (BRD core)

| Field | Description |
|---|---|
| **Business Problem** | Event-goers discover events scattered across social media and ticket resellers; they lose time comparing dates, venues and prices, and abandon before purchasing. |
| **Business Objective** | Increase completed ticket purchases by making discovery, selection and checkout a single mobile flow. |
| **Target Users** | Event attendees (18–40) who follow concerts, sports and theater in their city. |
| **Expected Outcome** | Users browse events, filter by city/category/date, and complete a ticket order in-app without leaving for a browser. |
| **Business Rules** | 1. Only events with a future date can be booked.<br>2. A valid order requires event + ticket quantity (1–6) + successful payment.<br>3. Sold-out or past events are visible but not bookable. |
| **Success Metric** | More completed orders per active user; fewer abandoned checkouts. |

---

## Product Requirements Document (PRD)

### 1. Overview

| Attribute | Detail |
|---|---|
| **Product** | EventGo — Event discovery & ticket booking mobile app |
| **Platform** | Flutter (iOS, Android, Web) |
| **Target Release** | MVP v1.0 |
| **Primary Metric** | Completed ticket orders per active user |
| **Supporting Metrics** | Event browse → book conversion rate, checkout abandonment rate, API error rate |

### 2. Goals & Success Criteria

| # | Goal | Success Criteria (MVP) |
|---|---|---|
| G1 | Enable user registration & authentication | New users can register with email/phone; receive JWT; access app |
| G2 | Provide comprehensive event discovery | Users can view, search, and filter events from Ticketmaster |
| G3 | Enable in-app ticket booking | Users can select 1–6 tickets and complete checkout flow |
| G4 | Deliver resilient error handling | All API errors are parsed and displayed as user-friendly messages |

### 3. User Personas

| Persona | Description | Needs |
|---|---|---|
| **Event Enthusiast** (18–40) | Active on social media for event discovery; values speed and convenience | Fast search/filter; single-flow booking |
| **Weekend Planner** (25–38) | Plans activities for weekends & evenings | Date/category filters; clear event details |
| **First-Time Buyer** (18–30) | New to ticket purchasing; may be cautious | Simple registration; clear pricing & errors |

### 4. User Stories

#### Epic: Account Management

| ID | As a… | I want to… | So that… |
|---|---|---|---|
| US-01 | New user | Register an account using email, phone, name, and password | I can book tickets and save my details |
| US-02 | Registered user | Log in with my email and password | I can access my account and booking history |
| US-03 | Logged-in user | Have my session persist across app restarts | I don't need to log in every time |

#### Epic: Event Discovery

| ID | As a… | I want to… | So that… |
|---|---|---|---|
| US-04 | Browser | See a list of upcoming events | I can discover what's happening |
| US-05 | Browser | Filter events by city, category, and date | I can narrow down to relevant events |
| US-06 | Browser | Search events by keyword | I can find specific events |
| US-07 | Browser | View event details (image, name, venue, date, price) | I can make an informed decision |

#### Epic: Booking & Checkout

| ID | As a… | I want to… | So that… |
|---|---|---|---|
| US-08 | Browser | Select ticket quantity (1–6) for an event | I can book the right number of tickets |
| US-09 | Booking user | Review my order (event, quantity, total price) | I can verify before paying |
| US-10 | Booking user | Complete payment within the app | I get confirmed tickets without leaving |
| US-11 | Booking user | Receive order confirmation | I know my booking succeeded |

#### Epic: Error Handling

| ID | As a… | I want to… | So that… |
|---|---|---|---|
| US-12 | User | See clear error messages when something fails | I understand what went wrong and can retry |
| US-13 | User | See a message when there are no events | I know the search returned no results |
| US-14 | User | See loading indicators during API calls | I know the app is working |

### 5. Functional Requirements

#### 5.1 Authentication (FR-01 – FR-03)

| ID | Requirement | Priority |
|---|---|---|
| FR-01 | Registration accepts name, email, password, rePassword, phone; sends POST to `/api/v1/auth/signup`. | Must-have |
| FR-02 | Login accepts email & password; sends POST to `/api/v1/auth/signin`. | Must-have |
| FR-03 | JWT token returned from auth API must be stored securely (keychain/keystore). | Must-have |

#### 5.2 Event Discovery (FR-04 – FR-09)

| ID | Requirement | Priority |
|---|---|---|
| FR-04 | Fetch events from Ticketmaster API with pagination support. | Must-have |
| FR-05 | Display event name, image, venue name, and date in list tile. | Must-have |
| FR-06 | Filter by city (keyword). | Must-have |
| FR-07 | Filter by category (lookup & event genres). | Should-have |
| FR-08 | Filter by date range (start/end date). | Should-have |
| FR-09 | Search bar triggers keyword-based event search. | Must-have |

#### 5.3 Booking (FR-10 – FR-14)

| ID | Requirement | Priority |
|---|---|---|
| FR-10 | Event detail page shows full info + availability. | Must-have |
| FR-11 | Quantity selector enforces min=1, max=6. | Must-have |
| FR-12 | Past or sold-out events must show a disabled "Book" button. | Must-have |
| FR-13 | Checkout submits order to RouteMisr checkout endpoint. | Must-have |
| FR-14 | Successful checkout displays confirmation with order ID. | Must-have |

#### 5.4 Error Handling (FR-15 – FR-17)

| ID | Requirement | Priority |
|---|---|---|
| FR-15 | All HTTP errors routed through `ApiErrorHandler` → typed `AppError`. | Must-have |
| FR-16 | RouteMisr errors parsed by `AuthErrorParser` (reads `message` + `statusMsg`). | Must-have |
| FR-17 | Ticketmaster errors parsed by `TicketmasterErrorParser` (reads `fault.faultstring` + `detail.errorcode`). | Must-have |

### 6. Non-Functional Requirements

| Category | Requirement |
|---|---|
| **Performance** | API responses cached; list images lazy-loaded; 10s default Dio timeouts |
| **Security** | `.env` excluded from VCS; secrets never logged; JWT stored in secure storage |
| **Reliability** | Connection timeouts, offline errors, and 4xx/5xx all mapped to user messages |
| **Scalability** | Named DI instances allow separate base URLs per backend without coupling |
| **Maintainability** | Feature-folder structure; repositories isolate API contracts from UI |
| **Compatibility** | Flutter SDK >=3.12; targets Android API 21+, iOS 13+, Web modern browsers |

### 7. Data Model Summary

| Model | Source | Key Fields |
|---|---|---|
| `RegisterRequestModel` | Client → RouteMisr | `name`, `email`, `password`, `rePassword`, `phone` |
| `RegisterResponseModel` | RouteMisr → Client | `message`, `user` (name, email, role), `token` |
| `AppError` | All APIs | `message` (user-facing), `code` (machine-readable) |
| `ApiResult<T>` | All repos | `Success<T>` / `Error<T>` |

### 8. API Endpoints

| Service | Base URL | Endpoint | Method | Purpose |
|---|---|---|---|---|
| RouteMisr (Auth) | `https://ecommerce.routemisr.com` | `/api/v1/auth/signup` | POST | Register new user |
| RouteMisr (Auth) | `https://ecommerce.routemisr.com` | `/api/v1/auth/signin` | POST | Authenticate user |
| Ticketmaster | `https://oauth.ticketmaster.com` | `/discovery/v2/events.json` | GET | Search/discover events |

### 9. UI / Screen Flow

```
[Register Screen] → [Login Screen] → [Event List Screen]
                                              │
                                              ↓
                                    [Event Detail Screen]
                                              │
                                              ↓
                                   [Booking / Checkout]
                                              │
                                              ↓
                                   [Order Confirmation]
```

> **Note:** Routes `AppRoutes.loginScreen` and `AppRoutes.registerScreen` are defined. The current MVP entry point is the Register screen; Login, Event List, Detail, and Checkout screens are planned for the next sprint.

### 10. Out of Scope (MVP)

- Seat selection & interactive venue maps
- Booking history / purchased tickets dashboard
- Payment gateway integration (card, Apple Pay, Google Pay)
- Social sharing of events
- Offline event caching beyond image cache

---

## Development

### Code Generation & Linting

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

### Dependency Injection

The service locator (`lib/core/di/service_locator.dart`) uses **named instances** to distinguish between the two API backends:

- `routeApiService` — `ApiService` with `RouteBaseUrl`
- `ticketMasterApiService` — `ApiService` with `TicketMasterBaseUrl`

```dart
final registerRepo = getIt<RegisterRepo>(instanceName: routeApiService);
```

<!-- Uncomment the line below when a LICENSE file is added -->
<!-- ## License -->
<!--
Distributed under the MIT License. See `LICENSE` for more information.
-->
