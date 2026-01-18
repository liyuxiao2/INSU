# DESIGN_SYSTEM.md - Figma Integration Rules for Loop/INSU

> **Purpose**: Guide AI assistants when integrating Figma designs into the Loop/INSU iOS codebase using Model Context Protocol (MCP).

## OVERVIEW

Loop/INSU is a **safety-critical medical device application** for automated insulin delivery built with **Swift/SwiftUI**. The design system has two layers:

1. **LoopKit Foundation** - Stable medical domain UI (charts, device status, therapy data)
2. **INSU Custom System** - Modern Figma-aligned home screen redesign

---

## 1. DESIGN TOKENS

### Color Palette

#### INSU Brand Colors (Custom - Use for New Features)

```swift
// Location: /Loop-260117-1851/LoopWorkspace/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift

extension Color {
    // Primary colors
    static let insuBlue = Color(red: 164/255, green: 200/255, blue: 225/255)      // #A4C8E1 - Card backgrounds
    static let insuDarkBlue = Color(red: 31/255, green: 60/255, blue: 110/255)    // #1F3C6E - Buttons, accents
    static let insuGray = Color(red: 105/255, green: 105/255, blue: 105/255)      // #696969 - Secondary text
    static let insuCardWhite = Color.white                                         // Card inner backgrounds
    static let insuTextPrimary = Color.black                                       // Primary text
}
```

#### Medical Domain Colors (LoopKit - Use for Therapy Data)

```swift
// Location: /LoopWorkspace/LoopKit/LoopKitUI/Extensions/Color.swift

extension Color {
    static let carbs = Color.green        // Carbohydrate data
    static let glucose = Color.teal       // Blood glucose values
    static let insulin = Color.orange     // Insulin delivery
    static let fresh = Color.green        // Data status: current
    static let aging = Color.yellow       // Data status: aging
    static let stale = Color.red         // Data status: stale
    static let loopAccent = Color.blue   // Primary app accent
}
```

**DO NOT** use INSU colors for medical data visualization (glucose, insulin, carbs). These have specific semantic meanings for user safety.

### Typography System

```swift
// Location: /Loop-260117-1851/LoopWorkspace/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift

public struct InsuTypography {
    // Headers
    static let greeting = Font.system(size: 36, weight: .semibold)
    static let subtitle = Font.system(size: 16, weight: .regular)
    static let subtitleBold = Font.system(size: 16, weight: .bold).italic()

    // Display values (large glucose/insulin readings)
    static let glucoseValue = Font.system(size: 90, weight: .semibold)
    static let cardLargeValue = Font.system(size: 50, weight: .bold)

    // Card content
    static let cardTitle = Font.system(size: 20, weight: .bold)
    static let cardUnit = Font.system(size: 20, weight: .regular)
    static let cardDate = Font.system(size: 16, weight: .regular)

    // Labels and metadata
    static let glucoseUnit = Font.system(size: 16, weight: .regular)
    static let iobLabel = Font.system(size: 16, weight: .regular)
    static let iobValue = Font.system(size: 16, weight: .bold)

    // Buttons
    static let buttonText = Font.system(size: 20, weight: .bold)
}
```

**Usage**: Apply directly via `.font(InsuTypography.greeting)`

### Spacing Tokens

```swift
// Location: /Loop-260117-1851/LoopWorkspace/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift

public struct InsuSpacing {
    // Layout
    static let screenHorizontalPadding: CGFloat = 20

    // Cards
    static let cardCornerRadius: CGFloat = 20
    static let innerCardCornerRadius: CGFloat = 15
    static let mainCardHeight: CGFloat = 234
    static let smallCardHeight: CGFloat = 258
    static let smallCardWidth: CGFloat = 171

    // Components
    static let buttonHeight: CGFloat = 46
    static let tabBarHeight: CGFloat = 65
}
```

**Pattern**: Use these constants instead of magic numbers. Example: `.cornerRadius(InsuSpacing.cardCornerRadius)`

---

## 2. COMPONENT ARCHITECTURE

### Card Component Pattern

All INSU home screen cards follow this **nested ZStack pattern**:

```swift
// Outer colored container + Inner white content area

ZStack {
    // 1. Outer card (colored background)
    RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
        .fill(Color.insuBlue)

    // 2. Inner content area (white)
    VStack(spacing: 8) {
        // Card content here
        Text("Content")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.white)
    .cornerRadius(InsuSpacing.innerCardCornerRadius)
    .padding(6)  // Creates visible outer border
}
```

**Critical**: The 6pt padding creates the visible colored border effect.

### View Modifiers (Reusable Styles)

```swift
// Location: /Loop-260117-1851/LoopWorkspace/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift

// Apply card styling
.modifier(InsuCardModifier())
// or
.insuCardStyle()

// Apply inner card styling with optional shadow
.modifier(InsuInnerCardModifier(hasShadow: true))
// or
.insuInnerCardStyle(hasShadow: true)
```

### Button Styles

```swift
// Primary action button (INSU style)
Button("Action") { }
    .buttonStyle(InsuPrimaryButtonStyle())

// Legacy LoopKit buttons
Button("Action") { }
    .buttonStyle(ActionButtonStyle(.primary))
    // Options: .primary, .secondary, .destructive
```

**InsuPrimaryButtonStyle** produces:
- Dark blue background (#1F3C6E)
- White text, 20pt bold
- 20pt corner radius
- 46pt height
- 0.98 scale on press

---

## 3. ICON SYSTEM

### SF Symbols (Primary)

The app uses Apple's SF Symbols extensively. **Always prefer SF Symbols over custom icons** for consistency:

```swift
// Common icons used in Loop
Image(systemName: "house.fill")                           // Home tab
Image(systemName: "chart.bar.fill")                       // Stats
Image(systemName: "person.fill")                          // Profile
Image(systemName: "bell.fill")                            // Notifications
Image(systemName: "pause.fill")                           // Pause action
Image(systemName: "figure.run")                           // Activity
Image(systemName: "arrow.up.right.circle")                // Glucose trend
Image(systemName: "arrow.triangle.2.circlepath.circle.fill")  // Automated mode
Image(systemName: "hand.raised.circle.fill")              // Manual mode
```

**Icon Sizing Guidelines**:
- **Large display icons**: 88-90pt (mode selection, feature icons)
- **Standard UI icons**: 22-26pt (tab bar, headers, buttons)
- **Inline icons**: 16pt (text inline, small indicators)

### Custom Assets

Custom icons stored in Asset Catalogs:
- **HUDAssets.xcassets**: Battery, reservoir, status indicators
- **DefaultAssets.xcassets**: App-specific custom icons

**When to use custom assets**: Only for medical device-specific icons (battery levels, reservoir status, pump connection states) that don't have SF Symbol equivalents.

---

## 4. COMPONENT LIBRARY

### Home Screen Components (Figma-Aligned)

Location: `/Loop-260117-1851/LoopWorkspace/Loop/LoopUI/Views/HomeCards/`

#### Main Container
```swift
// HomeCardContainer.swift - Main home screen with TabView pagination
public struct HomeCardContainer: View {
    @ObservedObject var viewModel: HomeViewModel
    let onInputBolus: () -> Void
    // Contains: Header, 3-page TabView, action cards, input button
}
```

#### Page Cards (Main TabView Pages)
1. **DashboardCardView.swift** - Glucose display (Page 0)
   - Large glucose value with unit
   - Trend arrow
   - IOB value
   - Stale data indicator

2. **PodStatusCardView.swift** - Pump status (Page 1)
   - Reservoir level
   - IOB
   - "View Details" link

3. **InsulinModeCardView.swift** - Mode selector (Page 2)
   - Automated/Manual toggle
   - Mode icon (88pt)
   - IOB

#### Action Cards (Bottom Section)
4. **LastBolusCardView.swift** - Last bolus info (171w × 258h)
5. **PauseGlucoseCardView.swift** - Quick action (157w × 118h)
6. **ActivityCardView.swift** - Quick action (157w × 118h)
7. **SensorAnalyticsCardView.swift** - 7-day stats with time-in-range breakdown

### Navigation
```swift
// HomeNavigationBar.swift - Animated bottom tab bar
public struct HomeNavigationBar: View
    // Features:
    // - 4 tabs: home, stats, history, profile
    // - Animated circular indicator
    // - "Dip" effect using DipCoverShape
    // - Cosine wave animation for smooth transitions
```

### LoopKit Base Components

Location: `/LoopWorkspace/LoopKit/LoopKitUI/Views/`

**Do not duplicate these** - import from LoopKitUI instead:
- `GlucoseHUDView` - Glucose status display
- `CGMStatusHUDView` - CGM connection status
- `LoopStateView` - Loop status indicator
- `BasalStateView` - Basal rate display
- Charts (100+ chart-related views)

---

## 5. STYLING APPROACH

### Environment-Based Theming

Colors are injected via SwiftUI Environment for runtime flexibility:

```swift
// In view code
@Environment(\.colorPalette) var colorPalette: LoopUIColorPalette
@Environment(\.carbTintColor) var carbTintColor: Color
@Environment(\.glucoseTintColor) var glucoseTintColor: Color
@Environment(\.insulinTintColor) var insulinTintColor: Color

// Usage
Text("Glucose")
    .foregroundColor(glucoseTintColor)  // Always teal for glucose
```

**Critical for safety**: Never override medical domain colors (glucose, insulin, carbs). Users learn these color associations for quick data interpretation.

### Composite Color Palettes

```swift
// Location: /LoopWorkspace/LoopKit/LoopKitUI/LoopUIColorPalette.swift

public struct LoopUIColorPalette {
    public let guidanceColors: GuidanceColors              // acceptable, warning, critical
    public let carbTintColor: Color                        // Green
    public let glucoseTintColor: Color                     // Teal
    public let insulinTintColor: Color                     // Orange
    public let loopStatusColorPalette: StateColorPalette   // Status: unknown, normal, warning, error
    public let chartColorPalette: ChartColorPalette        // Chart axes, grid, data
}
```

---

## 6. PROJECT STRUCTURE

### Key Directories

```
Loop-260117-1851/LoopWorkspace/
├── Loop/
│   ├── Loop/                        # Main iOS app target
│   │   ├── Views/                   # SwiftUI views
│   │   ├── View Controllers/        # UIKit controllers (LEGACY - avoid)
│   │   ├── Managers/                # ⚠️ SAFETY-CRITICAL - DO NOT MODIFY
│   │   ├── Models/                  # Data models
│   │   ├── View Models/             # MVVM presentation layer
│   │   └── DefaultAssets.xcassets   # App assets
│   │
│   └── LoopUI/                      # ✅ SAFE TO MODIFY - UI framework
│       ├── Views/
│       │   ├── HomeCards/           # ✅ New Figma components
│       │   └── *.swift              # HUD views, status displays
│       ├── Extensions/              # Color, Image helpers
│       ├── ViewModel/               # Presentation models
│       └── HUDAssets.xcassets       # Icons, status indicators
│
├── LoopKit/                         # ⚠️ CORE FRAMEWORK - MODIFY WITH CAUTION
│   ├── LoopKit/                     # ⚠️ DO NOT MODIFY - Dosing algorithms
│   └── LoopKitUI/                   # ✅ SAFE - Base UI components
│       ├── Views/                   # Reusable SwiftUI/UIKit components
│       ├── Extensions/              # Color palettes, utilities
│       └── Resources/               # Shared assets
│
├── OmniKit/                         # ⚠️ DO NOT MODIFY - Pump driver
├── MinimedKit/                      # ⚠️ DO NOT MODIFY - Pump driver
├── CGMBLEKit/                       # ⚠️ DO NOT MODIFY - CGM driver
├── G7SensorKit/                     # ⚠️ DO NOT MODIFY - CGM driver
└── LoopOnboarding/                  # ✅ SAFE - Onboarding flows
```

### Safety Zones

**✅ SAFE TO MODIFY** (UI/UX only):
- `/Loop/LoopUI/Views/` - SwiftUI views
- `/Loop/LoopUI/Extensions/` - UI helpers
- `/Loop/Loop/Views/` - App-level views
- `/LoopKit/LoopKitUI/` - Shared UI components
- `/LoopOnboarding/` - Onboarding screens

**⚠️ DO NOT MODIFY** (Medical logic):
- Any files with: `DoseStore`, `LoopDataManager`, `LoopAlgorithm`, `LoopMath`
- Pump drivers: `PumpManager`, `OmniKit`, `MinimedKit`
- CGM drivers: `CGMManager`, `CGMBLEKit`, `G7SensorKit`
- Therapy calculations: `BolusRecommendation`, `BasalRateSchedule`
- Safety systems: `AlertManager`

---

## 7. INTEGRATING FIGMA DESIGNS

### Workflow for MCP-Based Figma Integration

When using Figma MCP tools to generate code from designs:

#### Step 1: Extract Design Context
```
Use mcp__figma__get_design_context with the Figma node ID
```

#### Step 2: Map Figma Tokens to Loop Tokens

**Colors**:
- Figma blue → `Color.insuBlue`
- Figma dark blue → `Color.insuDarkBlue`
- Figma gray → `Color.insuGray`
- Glucose/medical data → Use `Color.glucose`, `Color.insulin`, `Color.carbs`

**Typography**:
- Match Figma font sizes to `InsuTypography` constants
- If no exact match, add new constant to `InsuTypography` struct

**Spacing**:
- Extract padding/margin values
- Add to `InsuSpacing` if reusable (3+ uses)

#### Step 3: Build Components

Follow the **nested ZStack card pattern**:

```swift
public struct NewCardView: View {
    // 1. Define properties (data to display)
    let value: Double
    let unit: String
    let onAction: () -> Void

    // 2. Init with escaping closures for callbacks
    public init(value: Double, unit: String, onAction: @escaping () -> Void) {
        self.value = value
        self.unit = unit
        self.onAction = onAction
    }

    // 3. Build view
    public var body: some View {
        Button(action: onAction) {
            ZStack {
                // Outer card
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(Color.insuBlue)

                // Inner content
                VStack(spacing: 8) {
                    Text("\(value, specifier: "%.2f")")
                        .font(InsuTypography.cardLargeValue)
                        .foregroundColor(Color.insuTextPrimary)

                    Text(unit)
                        .font(InsuTypography.cardUnit)
                        .foregroundColor(Color.insuGray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(InsuSpacing.innerCardCornerRadius)
                .padding(6)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 4. Always include preview
struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardView(value: 5.5, unit: "mmol/L", onAction: {})
            .frame(width: 171, height: 118)
            .padding()
    }
}
```

#### Step 4: Use SF Symbols for Icons

**Do not** export custom icons from Figma for standard UI elements. Map to SF Symbols:

| Figma Icon Type | SF Symbol |
|----------------|-----------|
| Pause | `pause.fill` |
| Play | `play.fill` |
| Activity/Running | `figure.run` |
| Notifications | `bell.fill` |
| Settings | `gearshape.fill` |
| Arrow up | `arrow.up` |
| Arrow down | `arrow.down` |
| Circular arrow | `arrow.triangle.2.circlepath.circle.fill` |

**Only export** medical device-specific icons (pump, sensor, reservoir levels).

#### Step 5: Validate Against Safety Rules

Before finalizing:
- [ ] Component is in `/LoopUI/Views/` or `/LoopUI/Views/HomeCards/`
- [ ] No modifications to dosing logic, pump drivers, or CGM drivers
- [ ] Medical colors (glucose/teal, insulin/orange, carbs/green) used correctly
- [ ] SF Symbols used instead of custom icons where possible
- [ ] Follows nested ZStack card pattern for consistency
- [ ] Preview included for testing in Xcode Canvas

---

## 8. MVVM ARCHITECTURE

### ViewModel Pattern

Components receive data via `ObservableObject` ViewModels:

```swift
// ViewModel (data source)
public class HomeViewModel: ObservableObject {
    @Published var glucoseValue: Double = 0.0
    @Published var glucoseUnit: String = "mg/dL"
    @Published var trendArrow: String = "→"
    @Published var isGlucoseStale: Bool = false
    // ... more properties
}

// View (presentation)
public struct HomeCardContainer: View {
    @ObservedObject var viewModel: HomeViewModel

    public var body: some View {
        Text("\(viewModel.glucoseValue, specifier: "%.1f")")
            .opacity(viewModel.isGlucoseStale ? 0.5 : 1.0)
    }
}
```

**Pattern**: Views are stateless and driven by ViewModels. Business logic stays in ViewModels or Managers.

---

## 9. ACCESSIBILITY CONSIDERATIONS

### Voice Over Support

```swift
// Add accessibility labels for icons
Image(systemName: "pause.fill")
    .accessibilityLabel("Pause glucose monitoring")

// Describe data values
Text("\(glucoseValue)")
    .accessibilityLabel("Glucose: \(glucoseValue) \(glucoseUnit)")
    .accessibilityHint("Current blood glucose reading")
```

### Dynamic Type

All text uses `Font.system()` which respects user's Dynamic Type settings. **Do not use fixed sizes for critical medical data**.

### Color Contrast

- Primary text on white: Black (21:1 contrast)
- Button text on dark blue: White (8.5:1 contrast)
- All meet WCAG AA standards (4.5:1 minimum)

---

## 10. LOCALIZATION

### String Localization

Strings are managed via Xcode String Catalogs (`.xcstrings`):

```swift
// Location: /Loop/LoopUI/Localizable.xcstrings (99K+ characters)

// In code - use localized strings
Text("Pause Glucose")
    // Auto-extracted to Localizable.xcstrings

// For medical units (do not localize)
Text("mg/dL")  // Keep as-is
```

**Rule**: UI strings are localized, medical units and values are not.

---

## 11. ASSET MANAGEMENT

### Adding New Assets

1. **For UI icons**: Use SF Symbols first
2. **For custom medical icons**:
   ```
   Add to: /Loop/LoopUI/HUDAssets.xcassets/
   Format: PDF (vector) or @2x/@3x PNG sets
   Naming: lowercase-with-hyphens (e.g., `reservoir-level-high`)
   ```

3. **Usage in code**:
   ```swift
   Image("reservoir-level-high", bundle: Bundle(for: LoopUIManager.self))
   ```

### Asset Organization

```
HUDAssets.xcassets/
├── battery/
│   ├── battery-100.imageset/
│   ├── battery-75.imageset/
│   └── battery-low.imageset/
├── reservoir/
│   └── reservoir-*.imageset/
└── status-bar-symbols/
    └── *.imageset/
```

---

## 12. BUILDING & TESTING

### Build System

**Xcode Workspace**: `/LoopWorkspace/LoopWorkspace.xcworkspace`

**Build from Terminal**:
```bash
cd /path/to/insuliproto/LoopWorkspace
xcodebuild -workspace LoopWorkspace.xcworkspace -scheme Loop -sdk iphonesimulator
```

### SwiftUI Previews

Every component **must** include a preview:

```swift
struct ComponentName_Previews: PreviewProvider {
    static var previews: some View {
        ComponentName(parameter: value)
            .previewDisplayName("Component Description")
            .preferredColorScheme(.light)
    }
}
```

**Tip**: Use `.preferredColorScheme(.dark)` to test dark mode appearance.

### Testing New UI Components

1. Add component to `/LoopUI/Views/HomeCards/`
2. Build SwiftUI preview in Xcode Canvas (⌘ + Option + P)
3. Test with different data states (empty, loading, error, success)
4. Verify on multiple device sizes (SE, standard, Plus/Max)
5. Test dark mode appearance
6. Verify VoiceOver support

---

## 13. COMMON PATTERNS & SNIPPETS

### Pattern: Conditional Styling

```swift
// Stale data indicator
.opacity(isDataStale ? 0.5 : 1.0)
.overlay(
    isDataStale ?
    Image(systemName: "exclamationmark.triangle")
        .foregroundColor(.orange)
    : nil
)
```

### Pattern: Button with Press Effect

```swift
Button(action: action) {
    Text("Action")
}
.buttonStyle(InsuPrimaryButtonStyle())
// Press effect built into InsuPrimaryButtonStyle (0.98 scale)
```

### Pattern: Animated Page Indicator

```swift
// From HomeCardContainer.swift
HStack(spacing: 5) {
    ForEach(0..<3) { index in
        RoundedRectangle(cornerRadius: 5)
            .fill(currentPage == index ? Color.insuDarkBlue : Color.gray.opacity(0.4))
            .frame(width: currentPage == index ? 50 : 23, height: 11)
            .animation(.easeInOut(duration: 0.3), value: currentPage)
    }
}
```

### Pattern: Number Formatting

```swift
// Glucose values (1 decimal place)
Text("\(glucoseValue, specifier: "%.1f")")

// IOB/Insulin (2 decimal places)
Text("\(iobValue, specifier: "%.2f")")

// Reservoir (integer)
Text("\(Int(reservoirLevel))")
```

---

## 14. CODE REVIEW CHECKLIST

Before committing Figma-integrated code:

**Safety**:
- [ ] No changes to files in: `LoopKit/LoopKit/`, pump drivers, CGM drivers, `Managers/`
- [ ] Medical domain colors used correctly (glucose=teal, insulin=orange, carbs=green)
- [ ] No hardcoded medical values or therapy settings

**Design System**:
- [ ] Uses `InsuTypography` constants (not arbitrary font sizes)
- [ ] Uses `InsuSpacing` constants (not magic numbers)
- [ ] Uses INSU color palette (`Color.insuBlue`, etc.)
- [ ] Follows nested ZStack card pattern for cards
- [ ] Uses SF Symbols where appropriate

**Code Quality**:
- [ ] Public API for LoopUI components (`public struct`, `public init`)
- [ ] SwiftUI preview included
- [ ] Accessibility labels for icons/images
- [ ] Localized strings for UI text
- [ ] No force unwraps (`!`) without safety comments

**Architecture**:
- [ ] MVVM pattern followed (View + ObservableObject ViewModel)
- [ ] No business logic in Views
- [ ] Callbacks use `@escaping` closures

---

## 15. EXAMPLES: BEFORE & AFTER

### ❌ INCORRECT: Figma Export Without Adaptation

```swift
// Raw Figma export - DO NOT DO THIS
struct BadCard: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#A4C8E1"))  // ❌ Hardcoded hex
                .cornerRadius(20)             // ❌ Magic number

            Text("Value")
                .font(.system(size: 50))      // ❌ Arbitrary size
                .foregroundColor(.black)
        }
    }
}
```

### ✅ CORRECT: Adapted to Loop Design System

```swift
// Properly integrated component
public struct GoodCard: View {
    let value: String

    public init(value: String) {
        self.value = value
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)  // ✅ Design token
                .fill(Color.insuBlue)                                     // ✅ Named color

            VStack {
                Text(value)
                    .font(InsuTypography.cardLargeValue)                  // ✅ Typography token
                    .foregroundColor(Color.insuTextPrimary)               // ✅ Semantic color
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(6)
        }
    }
}

struct GoodCard_Previews: PreviewProvider {
    static var previews: some View {
        GoodCard(value: "120")
            .frame(width: 171, height: 118)
    }
}
```

---

## 16. TROUBLESHOOTING

### Common Build Errors

**"Cannot find 'InsuTypography' in scope"**
- Ensure `HomeCardStyle.swift` is included in LoopUI target
- Check import: `import LoopUI`

**"Module 'LoopUI' not found"**
- Build the LoopUI framework first
- Check target dependencies in Xcode project settings

**Assets not loading**
- Verify bundle: `Bundle(for: LoopUIManager.self)` or `Bundle.module`
- Check asset is in correct `.xcassets` folder and added to target

**Preview not working**
- Ensure preview provider is at file-level (not nested in class)
- Check all dependencies are available in preview target
- Try: Editor → Canvas → Reset Canvas

---

## 17. RESOURCES

### Key Files Reference

| Purpose | File Path |
|---------|-----------|
| Color tokens | `/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift` |
| Typography | `/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift` |
| Spacing | `/Loop/LoopUI/Views/HomeCards/HomeCardStyle.swift` |
| Button styles | `/LoopKit/LoopKitUI/Views/ActionButtonStyle.swift` |
| Environment colors | `/LoopKit/LoopKitUI/Extensions/Environment+Colors.swift` |
| Component examples | `/Loop/LoopUI/Views/HomeCards/*.swift` |

### Swift/SwiftUI References

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [SF Symbols Browser](https://developer.apple.com/sf-symbols/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

## FINAL NOTES

**When in doubt**:
1. Check existing home card components for patterns
2. Ask for clarification before modifying medical/dosing code
3. Prioritize patient safety over design perfection
4. Use design tokens instead of arbitrary values
5. Follow SwiftUI best practices and MVVM architecture

**Remember**: This is a medical device. Consistency, clarity, and safety are more important than pixel-perfect Figma reproduction.
