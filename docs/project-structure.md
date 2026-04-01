# Project Structure & Organization

**Version**: 1.0  
**Last Updated**: 2025-09-30

This document defines the folder structure, file organization, and naming conventions for the EatThisDie codebase.

---

## Repository Overview

```
eatthisidie/
├── .git/                          # Git version control
├── .github/                       # GitHub workflows and templates
│   ├── workflows/
│   │   ├── tests.yml
│   │   └── swiftlint.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/                          # Project documentation
│   ├── README.md
│   ├── requirements.md
│   ├── architecture.md
│   ├── technology-stack.md
│   ├── design-system.md
│   ├── development-rules.md
│   ├── project-structure.md
│   └── ui-mockups.md
├── src/                           # Source code
│   └── EatThisDie/               # Main app target
│       ├── App/
│       ├── DesignSystem/
│       ├── Features/
│       ├── Core/
│       ├── Resources/
│       └── Supporting Files/
├── tests/                         # Test suite
│   ├── Unit/
│   ├── Integration/
│   └── UI/
├── scripts/                       # Build and utility scripts
├── .swiftlint.yml                # SwiftLint configuration
├── .gitignore                    # Git ignore rules
└── README.md                     # Repository readme
```

---

## Source Code Structure (`src/EatThisDie/`)

### 1. App Layer (`App/`)

Entry point and app-level configuration.

```
App/
├── EatThisDieApp.swift           # @main app entry point
├── ContentView.swift             # Root view
├── AppDelegate.swift             # App lifecycle (if needed)
└── SceneDelegate.swift           # Scene lifecycle (if needed)
```

**Contents**:
- App initialization
- Root navigation setup
- Environment object injection
- Deep linking configuration

---

### 2. Design System (`DesignSystem/`)

All design tokens and reusable UI components.

```
DesignSystem/
├── Tokens/
│   ├── Colors.swift              # AmberTheme, DOS colors
│   ├── Typography.swift          # Font styles
│   ├── Spacing.swift             # Layout constants
│   ├── Animations.swift          # DOS-style animations
│   └── Icons.swift               # SF Symbol references
├── Components/
│   ├── Buttons/
│   │   ├── DOSButton.swift
│   │   ├── DOSGhostButton.swift
│   │   └── DOSIconButton.swift
│   ├── Inputs/
│   │   ├── DOSTextField.swift
│   │   ├── DOSSecureField.swift
│   │   └── DOSPicker.swift
│   ├── Display/
│   │   ├── DOSCard.swift
│   │   ├── DOSDataDisplay.swift
│   │   ├── DOSLabel.swift
│   │   └── DOSBadge.swift
│   ├── Navigation/
│   │   ├── DOSNavigationBar.swift
│   │   ├── DOSTabBar.swift
│   │   └── DOSToolbar.swift
│   └── Feedback/
│       ├── DOSAlert.swift
│       ├── DOSLoadingSpinner.swift
│       └── DOSToast.swift
└── Modifiers/
    ├── DOSCardStyle.swift
    ├── DOSGlowEffect.swift
    └── DOSBorderStyle.swift
```

**Naming Convention**: All design system components prefixed with `DOS` to indicate style system.

---

### 3. Features (`Features/`)

Feature modules organized by domain.

```
Features/
├── FoodLogging/
│   ├── Views/
│   │   ├── FoodLoggingView.swift
│   │   ├── FoodCameraView.swift
│   │   ├── FoodDetailView.swift
│   │   ├── BarcodeScannerView.swift
│   │   └── Components/
│   │       ├── FoodRow.swift
│   │       └── NutritionCard.swift
│   ├── ViewModels/
│   │   ├── FoodLoggingViewModel.swift
│   │   ├── FoodCameraViewModel.swift
│   │   └── FoodDetailViewModel.swift
│   ├── Models/
│   │   ├── FoodItem.swift
│   │   ├── MealType.swift
│   │   └── NutritionInfo.swift
│   └── UseCases/
│       ├── LogFoodUseCase.swift
│       ├── RecognizeFoodUseCase.swift
│       └── SearchFoodUseCase.swift
├── GlucoseMonitoring/
│   ├── Views/
│   │   ├── GlucoseDashboardView.swift
│   │   ├── GlucoseChartView.swift
│   │   └── GlucoseDetailView.swift
│   ├── ViewModels/
│   │   └── GlucoseMonitoringViewModel.swift
│   ├── Models/
│   │   ├── GlucoseReading.swift
│   │   └── GlucoseTrend.swift
│   └── UseCases/
│       ├── FetchGlucoseDataUseCase.swift
│       └── CalculateTrendsUseCase.swift
├── Analytics/
│   ├── Views/
│   │   ├── AnalyticsDashboardView.swift
│   │   ├── TrendsChartView.swift
│   │   └── InsightsView.swift
│   ├── ViewModels/
│   │   └── AnalyticsViewModel.swift
│   ├── Models/
│   │   ├── HealthInsight.swift
│   │   └── TrendData.swift
│   └── UseCases/
│       └── GenerateInsightsUseCase.swift
├── Profile/
│   ├── Views/
│   │   ├── ProfileView.swift
│   │   └── SettingsView.swift
│   ├── ViewModels/
│   │   └── ProfileViewModel.swift
│   └── Models/
│       └── UserProfile.swift
└── Onboarding/
    ├── Views/
    │   ├── WelcomeView.swift
    │   ├── HealthKitPermissionView.swift
    │   └── SetupCompleteView.swift
    └── ViewModels/
        └── OnboardingViewModel.swift
```

**Feature Module Rules**:
- Each feature is self-contained
- MVVM pattern within each feature
- Use Cases handle business logic
- Models are feature-specific (shared models go in Core)

---

### 4. Core (`Core/`)

Shared infrastructure and services.

```
Core/
├── HealthKit/
│   ├── HealthKitManager.swift
│   ├── HealthKitAuthManager.swift
│   ├── HealthKitReader.swift
│   ├── HealthKitWriter.swift
│   └── Models/
│       ├── HKGlucoseReading.swift
│       └── HKNutritionData.swift
├── Persistence/
│   ├── CoreData/
│   │   ├── CoreDataManager.swift
│   │   ├── CoreDataStack.swift
│   │   ├── Models/
│   │   │   ├── FoodItemEntity.swift
│   │   │   ├── MealEntity.swift
│   │   │   └── UserPreferencesEntity.swift
│   │   ├── EatThisDie.xcdatamodeld
│   │   └── Repositories/
│   │       ├── FoodRepository.swift
│   │       ├── MealRepository.swift
│   │       └── PreferencesRepository.swift
│   └── UserDefaults/
│       └── UserDefaultsManager.swift
├── Networking/
│   ├── NetworkClient.swift
│   ├── APIEndpoints.swift
│   ├── APIError.swift
│   └── Services/
│       ├── FoodDatabaseService.swift
│       ├── BarcodeService.swift
│       └── FoodRecognitionService.swift
├── Services/
│   ├── LocationService.swift
│   ├── CameraService.swift
│   ├── NotificationService.swift
│   └── AnalyticsService.swift
├── Security/
│   ├── KeychainService.swift
│   ├── EncryptionService.swift
│   └── BiometricAuthService.swift
├── Extensions/
│   ├── Color+Hex.swift
│   ├── Date+Formatting.swift
│   ├── Double+Rounding.swift
│   └── View+Extensions.swift
└── Utilities/
    ├── Logger.swift
    ├── Validator.swift
    └── DateFormatter+Shared.swift
```

**Core Module Rules**:
- No UI code in Core
- All services use protocols
- Thread-safe implementations
- Comprehensive error handling

---

### 5. Resources (`Resources/`)

Non-code assets and configurations.

```
Resources/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/
│   ├── Colors/
│   │   ├── AmberCGA.colorset
│   │   ├── DOSBlack.colorset
│   │   └── DOSGray.colorset
│   └── Images/
│       ├── Logo.imageset
│       └── Onboarding/
├── Fonts/                        # Custom fonts (if any)
├── Info.plist                    # App configuration
├── Localizable.strings           # Localization
└── PrivacyInfo.xcprivacy        # Privacy manifest
```

---

## Test Structure (`tests/`)

```
tests/
├── Unit/
│   ├── ViewModels/
│   │   ├── FoodLoggingViewModelTests.swift
│   │   └── GlucoseMonitoringViewModelTests.swift
│   ├── UseCases/
│   │   └── LogFoodUseCaseTests.swift
│   ├── Services/
│   │   └── HealthKitManagerTests.swift
│   └── Mocks/
│       ├── MockHealthKitManager.swift
│       └── MockFoodRepository.swift
├── Integration/
│   ├── HealthKitIntegrationTests.swift
│   └── CoreDataIntegrationTests.swift
└── UI/
    ├── FoodLoggingUITests.swift
    └── OnboardingUITests.swift
```

---

## File Naming Conventions

### Swift Files

| Type | Naming Pattern | Example |
|------|----------------|---------|
| **View** | `{Feature}{Purpose}View.swift` | `FoodLoggingView.swift` |
| **ViewModel** | `{Feature}{Purpose}ViewModel.swift` | `FoodLoggingViewModel.swift` |
| **Model** | `{Entity}.swift` | `FoodItem.swift` |
| **Service** | `{Purpose}Service.swift` | `HealthKitService.swift` |
| **Manager** | `{Purpose}Manager.swift` | `CoreDataManager.swift` |
| **Use Case** | `{Action}UseCase.swift` | `LogFoodUseCase.swift` |
| **Repository** | `{Entity}Repository.swift` | `FoodRepository.swift` |
| **Protocol** | `{Entity/Action}Protocol.swift` | `FoodRepositoryProtocol.swift` |
| **Extension** | `{Type}+{Purpose}.swift` | `Color+Hex.swift` |
| **Test** | `{TestTarget}Tests.swift` | `FoodLoggingViewModelTests.swift` |

### Asset Files

| Type | Naming Pattern | Example |
|------|----------------|---------|
| **Images** | `lowercase-kebab-case` | `app-logo.png` |
| **Colors** | `PascalCase` | `AmberCGA.colorset` |
| **Fonts** | `font-name-weight` | `sf-mono-regular.ttf` |

---

## Code Organization Within Files

### Standard File Template

```swift
//
//  {FileName}.swift
//  EatThisDie
//
//  Created by {Developer} on {Date}.
//

// MARK: - Imports
import SwiftUI
import HealthKit
import Combine

// MARK: - Main Type Definition
struct FoodLoggingView: View {
    
    // MARK: - Properties
    
    // MARK: State & Environment
    @StateObject private var viewModel: FoodLoggingViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Private Properties
    @State private var showingCamera = false
    @State private var selectedFood: FoodItem?
    
    // MARK: - Initialization
    
    init(viewModel: FoodLoggingViewModel = FoodLoggingViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            content
        }
        .task {
            await loadData()
        }
    }
    
    // MARK: - Private Views
    
    private var content: some View {
        VStack {
            // Implementation
        }
    }
    
    // MARK: - Private Methods
    
    private func loadData() async {
        // Implementation
    }
    
    private func handleFoodCapture() {
        // Implementation
    }
}

// MARK: - Preview Provider

#Preview {
    FoodLoggingView()
}

// MARK: - Supporting Types

private enum Constants {
    static let maxFoods = 100
    static let cacheDuration: TimeInterval = 3600
}
```

---

## Import Order

Always organize imports in this order:

```swift
// 1. System frameworks
import SwiftUI
import UIKit
import Foundation

// 2. Apple frameworks (alphabetical)
import Combine
import CoreData
import HealthKit

// 3. Third-party dependencies (alphabetical)
import Alamofire
import Charts

// 4. Internal imports
@testable import EatThisDie
```

---

## Directory Creation Rules

### When to Create a New Directory

**DO create a new directory when**:
- ✅ Feature has 3+ related files
- ✅ Creating a new feature module
- ✅ Grouping related utilities/extensions
- ✅ Separating platform-specific code

**DON'T create a new directory when**:
- ❌ Only 1-2 files exist
- ❌ Directory would be mostly empty
- ❌ Files are temporary or experimental

### Directory Depth

- **Maximum nesting**: 4 levels deep
- **Recommended**: 2-3 levels
- **Prefer**: Flat structure with clear naming

---

## Git Ignore Patterns

```gitignore
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/
*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata

# Swift Package Manager
.build/
Packages/

# CocoaPods
Pods/

# Build artifacts
DerivedData/
build/

# User settings
*.pbxuser
*.mode1v3
*.mode2v3
*.perspectivev3
xcuserdata/

# Sensitive data
*.key
*.pem
Config.swift

# IDE
.vscode/
.idea/

# OS files
.DS_Store
```

---

## Scripts Directory

```
scripts/
├── setup.sh                      # Initial project setup
├── build.sh                      # Build automation
├── test.sh                       # Run all tests
├── lint.sh                       # SwiftLint check
├── format.sh                     # SwiftFormat
└── deploy.sh                     # TestFlight deployment
```

---

## Documentation Directory

```
docs/
├── README.md                     # Documentation index
├── requirements.md               # Requirements spec
├── architecture.md               # System architecture
├── technology-stack.md           # Tech stack decisions
├── design-system.md              # DOS amber design system
├── development-rules.md          # Development standards
├── project-structure.md          # This file
├── ui-mockups.md                 # UI designs and mockups
├── api-specs.md                  # API documentation
├── data-models.md                # Data structure specs
├── roadmap.md                    # Development roadmap
└── security-privacy.md           # Security guidelines
```

---

## Best Practices Summary

### File Organization
1. One primary type per file
2. Related extensions in same file
3. Group by feature, not by type
4. Keep related files together

### Naming
1. Descriptive and unambiguous
2. Follow Swift API design guidelines
3. Prefix design system components with `DOS`
4. Use domain language in feature modules

### Structure
1. Features are independent modules
2. Core contains shared infrastructure
3. Design system is centralized
4. Tests mirror source structure

### Growth Strategy
1. Start simple, refactor when needed
2. Create directories when 3+ files exist
3. Extract shared code to Core
4. Keep feature boundaries clear

---

**Last Updated**: 2025-09-30  
**Maintained By**: Development Team
