# System Architecture

## Architecture Overview

EatThisDie follows a HealthKit-centric architecture designed for seamless integration with existing diabetes management apps. The MVP focuses on intelligent food logging with minimal complexity, leveraging Apple's native health data infrastructure for maximum interoperability and user control.

## MVP Architecture (HealthKit-Centric)

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   iOS App UI    │  │     Widgets     │  │ Watch (v2)  │  │
│  │   (SwiftUI)     │  │  (Glucose +     │  │             │  │
│  │  Food Logging   │  │   Recent Food)  │  │             │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │  Food Logging   │  │    Learning     │  │  Context    │  │
│  │    Manager      │  │     Engine      │  │  Manager    │  │
│  │   (MVP Core)    │  │  (Pattern Rec)  │  │ (Mood/Tags) │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│              HealthKit-Centric Data Layer                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   HealthKit     │  │   Core Data     │  │   UserDef   │  │
│  │ (Primary Store) │  │  (App Cache +   │  │ (Settings)  │  │
│  │ All Health Data │  │   Learning)     │  │             │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
                                │
┌─────────────────────────────────────────────────────────────┐
│                   External Services (MVP)                   │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │   Food Vision   │  │   Barcode API   │  │  Nutrition  │  │
│  │      AI         │  │  (Open Food     │  │   Database  │  │
│  │  (Core ML +     │  │    Facts)       │  │   (USDA)    │  │
│  │   Cloud API)    │  │                 │  │             │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              Existing Glucose Apps Integration              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐  │
│  │ Glucose Direct  │  │   Other CGM     │  │   Manual    │  │
│  │      ↓          │  │     Apps        │  │   Entry     │  │
│  │   HealthKit     │  │      ↓          │  │     ↓       │  │
│  │               ← │ ← │   HealthKit   ← │ ← │ HealthKit   │  │
│  └─────────────────┘  └─────────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## MVP Core Components

### 1. Presentation Layer

#### iOS App (SwiftUI)
- **Purpose**: Primary food logging interface
- **MVP Responsibilities**:
  - Camera-based food capture and recognition
  - Barcode scanning interface
  - Manual food entry forms
  - Quick meal logging workflow
  - Basic glucose data visualization from HealthKit

#### Widgets (Home Screen)
- **Purpose**: Quick access and overview
- **MVP Responsibilities**:
  - Latest glucose reading (from HealthKit)
  - Recent meal summary
  - Quick "Log Food" shortcut

#### Apple Watch (Phase 2)
- **Purpose**: Quick logging on-the-go
- **Future Responsibilities**:
  - Voice-activated food logging
  - Quick meal shortcuts

### 2. Business Logic Layer (MVP)

#### Food Logging Manager (Core MVP)
- **Purpose**: Central food data processing and HealthKit integration
- **MVP Responsibilities**:
  - Camera image processing coordination
  - Barcode scan result processing
  - Manual entry validation and quick shortcuts
  - Nutritional calculation and carb counting
  - Direct HealthKit data writing (nutrition, carbs, meal timing)
  - Integration with glucose data from HealthKit

#### Learning Engine (Basic)
- **Purpose**: Pattern recognition and suggestions
- **MVP Responsibilities**:
  - Food recognition accuracy improvement
  - Basic meal timing pattern recognition
  - Simple food suggestions based on history
  - Location-based context (home vs restaurant)

#### Context Manager (Simple)
- **Purpose**: Mood, stress, and journal integration
- **MVP Responsibilities**:
  - Mood/stress level tagging for meals
  - Simple journal entry association
  - Basic context pattern recognition

### 3. HealthKit-Centric Data Layer

#### HealthKit (Primary Data Store)
- **Purpose**: Central health data repository
- **MVP Data Types**:
  - Read: Glucose readings, exercise data, existing nutrition data
  - Write: Dietary carbohydrates, nutrition data, meal timing
  - Write: Mood samples, journal entries (custom HKCategoryType)
  - Integration: Seamless data sharing with other health apps

#### Core Data (App Cache & Learning)
- **Purpose**: Local caching and learning data
- **MVP Schema**:
  - Food recognition cache and corrections
  - User preferences and quick shortcuts
  - Learning model data and patterns
  - Offline food entry queue

#### UserDefaults (Settings)
- **Purpose**: App configuration and preferences
- **Data**: UI preferences, notification settings, privacy choices

### 4. External Services Layer

#### Freestyle Libre 3 API
- **Purpose**: CGM data integration
- **Data**: Real-time glucose readings, trends, alerts

#### Food Recognition AI
- **Purpose**: Image-based food identification
- **Providers**: Custom ML model + third-party services
- **Data**: Food identification, portion estimation

#### Barcode Database
- **Purpose**: Product nutritional information
- **Providers**: Open Food Facts, USDA, commercial APIs
- **Data**: Nutritional facts, serving sizes

#### Cloud Backup Service
- **Purpose**: Data backup and cross-device sync
- **Provider**: iCloud + custom backend
- **Data**: Encrypted health data, user preferences

#### Location Services
- **Purpose**: Context-aware features
- **Data**: GPS location, venue identification

#### Nutrition Database
- **Purpose**: Comprehensive food data
- **Providers**: USDA FoodData Central, custom curated data
- **Data**: Nutritional composition, glycemic index

## Data Flow Architecture

### Food Logging Data Flow

```
User Input → Image/Barcode → Recognition Service → Nutritional Data
    ↓                                                      ↓
Manual Entry ←→ Food Logging Manager ←→ Learning Engine ←→ Suggestions
    ↓                    ↓                      ↓
Core Data ←→ HealthKit ←→ Analytics Engine → Reports/Insights
    ↓
Cloud Sync ←→ Backup Service
```

### Health Data Flow

```
CGM Sensor → Freestyle API → Health Data Manager → Core Data
                                      ↓               ↓
Apple Health ←→ HealthKit Integration ←→ Analytics ←→ HealthKit
                                      ↓
                              Cloud Sync ←→ Backup
```

## Security Architecture

### Data Encryption
- **At Rest**: AES-256 encryption for local Core Data
- **In Transit**: TLS 1.3 for all network communications
- **Cloud Storage**: End-to-end encryption before cloud upload

### Authentication & Authorization
- **Local**: Device biometric authentication (Face ID/Touch ID)
- **Cloud**: OAuth 2.0 with refresh tokens
- **API Access**: Secure token-based authentication

### Privacy Protection
- **Health Data**: HealthKit privacy controls
- **Location**: User consent for location services
- **Analytics**: Anonymized data only
- **Sharing**: Explicit user consent for any data sharing

## Scalability Considerations

### Performance Optimization
- **Lazy Loading**: Load data on demand
- **Background Processing**: Heavy operations in background queues
- **Caching**: Multi-level caching strategy
- **Database Optimization**: Indexed queries and efficient schemas

### Modularity
- **Service-Oriented**: Each manager as independent service
- **Protocol-Based**: Interfaces for easy testing and swapping
- **Dependency Injection**: Loose coupling between components

### Extensibility
- **Plugin Architecture**: Easy addition of new data sources
- **API-First**: Internal APIs for future platform expansion
- **Configuration**: Feature flags for gradual rollouts

## Technology Integration Points

### Apple Ecosystem
- **HealthKit**: Primary health data integration
- **Core ML**: On-device food recognition
- **CloudKit**: Optional cloud sync
- **Siri Shortcuts**: Voice-activated logging
- **Apple Watch**: Companion app functionality

### Third-Party Services
- **CGM Integration**: Freestyle Libre 3 SDK
- **AI Services**: Food recognition APIs
- **Nutrition Data**: Multiple database providers
- **Analytics**: Custom analytics engine

## Offline Capabilities

### Local-First Architecture
- **Core Functionality**: Works fully offline
- **Data Storage**: All critical data stored locally
- **Sync Queue**: Automatic sync when online
- **Conflict Resolution**: Last-write-wins with user override option

### Background Processing
- **Health Data**: Continuous background monitoring
- **Sync Operations**: Background app refresh
- **Learning**: On-device model updates
- **Cleanup**: Automatic data maintenance