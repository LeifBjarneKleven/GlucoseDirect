# EatThisDie Development Rules & Best Practices

**Version**: 1.0  
**Last Updated**: 2025-09-30  
**Status**: Active

This document defines comprehensive development standards for EatThisDie, combining SOLID principles, Apple HIG, Swift/iOS best practices, and health app requirements with a unique DOS amber CGA aesthetic.

---

## Table of Contents

1. [Core Principles](#core-principles)
2. [Architecture Standards](#architecture-standards)
3. [Swift & iOS Standards](#swift--ios-standards)
4. [Design System Integration](#design-system-integration)
5. [HealthKit & Data Management](#healthkit--data-management)
6. [Security & Privacy](#security--privacy)
7. [Testing Requirements](#testing-requirements)
8. [Code Style](#code-style)
9. [Project Structure](#project-structure)
10. [Commit & Documentation](#commit--documentation)

---

## Core Principles

### The Ten Commandments

1. **HealthKit is Truth**: All health data flows through HealthKit as the source of truth
2. **Privacy by Design**: No PII in logs, metadata, or analytics
3. **Offline-First**: Core functionality works without network
4. **Auto-Save Everything**: Never lose user data under any circumstance
5. **Type Safety**: No force unwrapping, handle all optionals properly
6. **Async/Await**: Use modern concurrency, no completion handlers
7. **Protocol-Oriented**: Depend on abstractions, not concretions
8. **Amber Aesthetic**: Maintain DOS CGA visual identity consistently
9. **Accessibility First**: Support VoiceOver, Dynamic Type, high contrast
10. **Test-Driven**: Write tests before or alongside implementation

### Never Do This

- ❌ Store sensitive health data without encryption
- ❌ Force unwrap optionals (`!`)
- ❌ Hardcode credentials or API keys
- ❌ Ignore HealthKit authorization states
- ❌ Block the main thread
- ❌ Mix view and business logic
- ❌ Use completion handlers in new code
- ❌ Store PII in UserDefaults or metadata
- ❌ Skip error handling
- ❌ Deploy without accessibility testing

---

## Architecture Standards

### MVVM + Clean Architecture

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  Views (SwiftUI) ← ViewModels           │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│          Domain Layer                   │
│  Use Cases ← Entities/Models            │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│          Data Layer                     │
│  Repositories ← Data Sources            │
│  (HealthKit, Core Data, Network)        │
└─────────────────────────────────────────┘
```

### SOLID Principles (Swift Edition)

#### Single Responsibility
```swift
// ✅ Good: One responsibility
struct FoodItem {
    let name: String
    let carbs: Double
}

class FoodLoggingService {
    func logFood(_ item: FoodItem) async throws
}

// ❌ Bad: Multiple responsibilities
class FoodItemManager {
    func logFood() { }
    func renderUI() { }
    func saveToDatabase() { }
}
```

#### Open/Closed Principle
```swift
// ✅ Good: Extensible via protocols
protocol FoodRecognizer {
    func recognize(image: UIImage) async throws -> [FoodItem]
}

class MLKitRecognizer: FoodRecognizer { }
class CloudVisionRecognizer: FoodRecognizer { }
```

#### Liskov Substitution
- Subtypes must be substitutable for base types
- Protocol conformance shouldn't break expected behavior

#### Interface Segregation
```swift
// ✅ Good: Small, focused protocols
protocol Readable {
    func read() -> Data
}

protocol Writable {
    func write(_ data: Data)
}

// ❌ Bad: Fat interface
protocol DataHandler {
    func read() -> Data
    func write(_ data: Data)
    func delete()
    func compress()
    func encrypt()
}
```

#### Dependency Inversion
```swift
// ✅ Good: Depends on abstraction
class FoodLoggingViewModel {
    private let service: FoodLoggingService
    
    init(service: FoodLoggingService) {
        self.service = service
    }
}
```

---

## Swift & iOS Standards

### Language Requirements

- **Swift Version**: 5.9+
- **Minimum iOS**: 15.0
- **Target iOS**: Latest stable
- **Xcode**: Latest stable release

### Modern Swift Patterns

#### Async/Await
```swift
// ✅ Always use async/await
func fetchGlucoseData() async throws -> [GlucoseReading] {
    try await healthKitService.queryGlucoseReadings()
}

// ❌ Avoid completion handlers
func fetchGlucoseData(completion: @escaping ([GlucoseReading]?, Error?) -> Void)
```

#### Error Handling
```swift
enum FoodLoggingError: LocalizedError {
    case invalidImage
    case recognitionFailed
    case healthKitUnavailable
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "The image could not be processed."
        case .recognitionFailed:
            return "Unable to recognize food items."
        case .healthKitUnavailable:
            return "HealthKit access is required."
        }
    }
}
```

#### Value vs Reference Types
```swift
// ✅ Structs for data models
struct FoodItem {
    let id: UUID
    let name: String
    let carbs: Double
}

// ✅ Classes for services
class HealthKitService {
    private let store = HKHealthStore()
}

// ✅ Actors for thread-safe state
actor GlucoseDataCache {
    private var readings: [GlucoseReading] = []
    
    func addReading(_ reading: GlucoseReading) {
        readings.append(reading)
    }
}
```

### Optionals & Safety

```swift
// ✅ Use guard for early returns
func processFood(_ food: FoodItem?) -> Bool {
    guard let food = food else { return false }
    // Process food
    return true
}

// ✅ Optional chaining
let carbCount = meal?.foods?.first?.carbs

// ✅ Nil coalescing for defaults
let carbs = food.carbs ?? 0.0

// ❌ NEVER force unwrap
let name = food!.name  // Don't do this!
```

---

## Design System Integration

### DOS Amber CGA Aesthetic

#### Color Usage
```swift
enum AmberTheme {
    static let amber = Color(hex: "ffbf00")          // Primary
    static let amberDark = Color(hex: "cc9900")      // Dimmed
    static let amberLight = Color(hex: "ffd740")     // Highlights
    
    static let dosBlack = Color(hex: "0a0a0a")       // Background
    static let dosGray = Color(hex: "1a1a1a")        // Secondary bg
    static let dosBorder = Color(hex: "333333")      // Borders
    
    static let cgaGreen = Color(hex: "00ff00")       // Success
    static let cgaMagenta = Color(hex: "ff00ff")     // Error
    static let cgaCyan = Color(hex: "00ffff")        // Info
}
```

#### Typography
```swift
enum Typography {
    // All text uses monospace for DOS aesthetic
    static let monospace = Font.system(.body, design: .monospaced)
    static let headerLarge = Font.system(size: 34, weight: .bold, design: .monospaced)
    static let body = Font.system(size: 17, design: .monospaced)
    static let dataDisplay = Font.system(.body, design: .monospaced).monospacedDigit()
}
```

#### Layout
```swift
enum Spacing {
    static let unit: CGFloat = 8  // 8-pixel grid (DOS alignment)
    
    static let xs: CGFloat = 8
    static let sm: CGFloat = 16
    static let md: CGFloat = 24
    static let lg: CGFloat = 32
    static let xl: CGFloat = 48
}

enum CornerRadius {
    static let none: CGFloat = 0      // DOS sharp corners (primary)
    static let minimal: CGFloat = 2   // Slight softening
    static let apple: CGFloat = 10    // Standard (use sparingly)
}
```

#### Animations
```swift
enum Animations {
    // DOS-style: fast, snappy, minimal
    static let snap = Animation.linear(duration: 0.1)
    static let cursorBlink = Animation.easeInOut(duration: 0.5).repeatForever()
    static let typewriter = Animation.linear(duration: 0.05)
}
```

### Component Patterns

#### DOS Button
```swift
struct DOSButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Typography.monospace.weight(.bold))
            .foregroundColor(AmberTheme.dosBlack)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                configuration.isPressed 
                    ? AmberTheme.amberDark 
                    : AmberTheme.amber
            )
            .overlay(
                Rectangle()
                    .stroke(AmberTheme.dosBlack, lineWidth: 2)
            )
    }
}
```

---

## HealthKit & Data Management

### HealthKit Authorization

```swift
class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async throws {
        let readTypes: Set<HKObjectType> = [
            HKQuantityType(.bloodGlucose),
            HKQuantityType(.activeEnergyBurned),
        ]
        
        let writeTypes: Set<HKSampleType> = [
            HKQuantityType(.dietaryCarbohydrates),
            HKQuantityType(.dietaryEnergyConsumed),
        ]
        
        try await healthStore.requestAuthorization(
            toShare: writeTypes, 
            read: readTypes
        )
    }
}
```

### Data Flow Strategy

```
User Input → App → HealthKit (Write) → HealthKit (Read) → App Display
                ↓
          Core Data (Cache for offline/performance)
```

**Rules**:
1. HealthKit is always the source of truth
2. Core Data caches for UI performance and offline access
3. Sync pending data when online
4. Never duplicate if HealthKit is available

### Core Data Repository Pattern

```swift
protocol FoodRepository {
    func save(_ food: FoodItem) async throws
    func fetchAll() async throws -> [FoodItem]
    func delete(_ id: UUID) async throws
}

class CoreDataFoodRepository: FoodRepository {
    private let context: NSManagedObjectContext
    
    func save(_ food: FoodItem) async throws {
        try await context.perform {
            let entity = FoodItemEntity(context: self.context)
            entity.id = food.id
            entity.name = food.name
            entity.carbs = food.carbs
            try self.context.save()
        }
    }
}
```

---

## Security & Privacy

### Data Encryption

#### Local Storage
```swift
// Core Data encryption
let description = container.persistentStoreDescriptions.first
description?.setOption(
    FileProtectionType.complete as NSObject,
    forKey: NSPersistentStoreFileProtectionKey
)
```

#### Keychain for Secrets
```swift
class KeychainService {
    func store(_ data: Data, forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.storeFailed
        }
    }
}
```

### Privacy Compliance

#### HIPAA Awareness
- End-to-end encryption for health data
- Audit logging for data access
- User consent for all data sharing
- Right to deletion

#### Metadata Rules
```swift
// ✅ Good metadata
let metadata: [String: Any] = [
    HKMetadataKeyFoodType: "Apple",
    "AppVersion": Bundle.main.appVersion,
    "RecognitionConfidence": 0.95,
]

// ❌ Bad metadata (never store PII)
let badMetadata = [
    "UserName": "John Doe",           // ❌
    "UserEmail": "john@example.com",  // ❌
]
```

---

## Testing Requirements

### Coverage Goals
- **Minimum**: 80% code coverage
- **Critical paths**: 100% coverage (HealthKit, data sync, food logging)
- **UI components**: Visual regression tests

### Testing Strategy

#### Unit Tests
```swift
@testable import EatThisDie
import XCTest

class FoodLoggingServiceTests: XCTestCase {
    var sut: FoodLoggingService!
    var mockHealthKit: MockHealthKitManager!
    
    override func setUp() {
        super.setUp()
        mockHealthKit = MockHealthKitManager()
        sut = FoodLoggingService(healthKit: mockHealthKit)
    }
    
    func testLogFood_Success() async throws {
        let food = FoodItem(name: "Apple", carbs: 25)
        
        let result = try await sut.logFood(food)
        
        XCTAssertTrue(result)
        XCTAssertEqual(mockHealthKit.savedItems.count, 1)
    }
}
```

#### UI Tests
```swift
class FoodLoggingUITests: XCTestCase {
    func testLogFoodFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        app.buttons["Log Food"].tap()
        app.textFields["Food Name"].tap()
        app.textFields["Food Name"].typeText("Apple")
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.staticTexts["Apple"].exists)
    }
}
```

---

## Code Style

### Naming Conventions

```swift
// Types: PascalCase
struct FoodItem { }
class HealthKitManager { }
enum GlucoseLevel { }

// Variables & Functions: camelCase
let glucoseReading: Double
func fetchGlucoseData() { }

// Booleans: is/has/should/can
let isLoading: Bool
let hasData: Bool
func shouldRefresh() -> Bool

// Constants: camelCase
let maxRetryAttempts = 3
let apiTimeout: TimeInterval = 30
```

### File Organization

```swift
// 1. Imports
import SwiftUI
import HealthKit

// 2. Type definition
struct FoodLoggingView: View {
    // 3. Properties (private first)
    @StateObject private var viewModel = FoodLoggingViewModel()
    @State private var showingCamera = false
    
    // 4. Body
    var body: some View {
        // Implementation
    }
    
    // 5. Private methods
    private func handleCapture() {
        // Implementation
    }
}

// 6. Extensions
extension FoodLoggingView {
    // Helper views
}
```

### SwiftLint Configuration

```yaml
# .swiftlint.yml
disabled_rules:
  - trailing_whitespace
opt_in_rules:
  - empty_count
  - explicit_init
  - closure_spacing
line_length: 120
type_body_length: 400
file_length: 600
identifier_name:
  min_length: 2
  max_length: 50
```

---

## Project Structure

```
src/EatThisDie/
├── App/
│   ├── EatThisDieApp.swift
│   └── ContentView.swift
├── DesignSystem/
│   ├── Colors.swift
│   ├── Typography.swift
│   ├── Spacing.swift
│   └── Components/
├── Features/
│   ├── FoodLogging/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Models/
│   ├── GlucoseMonitoring/
│   └── Analytics/
├── Core/
│   ├── HealthKit/
│   ├── CoreData/
│   └── Services/
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

---

## Commit & Documentation

### Git Commit Messages

```
type(scope): subject

body (optional)

footer (optional)
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Examples**:
```
feat(food-logging): add camera capture functionality

Implemented AVFoundation camera integration for food
photo capture with DOS amber overlay UI.

Closes #123
```

### Documentation Requirements

#### Code Documentation
```swift
/// Logs a food item to HealthKit and updates local cache.
///
/// This method validates the food item, calculates nutritional data,
/// and saves it to HealthKit. If HealthKit is unavailable, it queues
/// the item for later sync.
///
/// - Parameter item: The food item to log
/// - Returns: `true` if successfully logged, `false` otherwise
/// - Throws: `FoodLoggingError` if validation or saving fails
func logFood(_ item: FoodItem) async throws -> Bool {
    // Implementation
}
```

#### README Updates
- Update README with new features
- Document breaking changes
- Include setup instructions
- Add troubleshooting section

---

## Development Workflow Checklist

### Before Coding
- [ ] Review requirements
- [ ] Design protocol interfaces
- [ ] Write test cases
- [ ] Plan data flow

### During Development
- [ ] Follow SwiftLint rules
- [ ] Write inline documentation
- [ ] Handle all error cases
- [ ] Test on multiple screen sizes

### Before Committing
- [ ] All tests pass
- [ ] SwiftLint passes (zero warnings)
- [ ] No force unwraps
- [ ] Documentation updated
- [ ] Accessibility tested

### Before PR/Release
- [ ] Code review completed
- [ ] UI/UX review with DOS aesthetic
- [ ] Performance profiling done
- [ ] Accessibility audit passed
- [ ] Privacy review completed

---

## Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [HealthKit Documentation](https://developer.apple.com/documentation/healthkit)
- [Clean Architecture in Swift](https://www.kodeco.com/11697166-clean-architecture-tutorial-for-ios)
- [HIPAA Compliance Guide](https://www.hhs.gov/hipaa/for-professionals/security/index.html)

---

**Last Updated**: 2025-09-30  
**Next Review**: Quarterly or upon major iOS updates
