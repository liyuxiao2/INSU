# INSU

A customized fork of the open-source [Loop](https://github.com/LoopKit/Loop) application for automated insulin delivery, featuring a modern redesigned user interface.

## Overview

INSU is an iOS application that helps manage Type 1 diabetes through automated insulin delivery. It interfaces with compatible insulin pumps and continuous glucose monitors (CGMs) to provide closed-loop insulin delivery based on real-time glucose data.

## Features

- **Modern Home Dashboard**: Redesigned SwiftUI-based home screen with card-based UI
- **Real-time Glucose Monitoring**: Live glucose readings with trend indicators
- **Automated Insulin Delivery**: Closed-loop control with compatible pumps
- **Pod Status Tracking**: Monitor insulin reservoir levels and pod expiration
- **Bolus Management**: Easy bolus entry with recommendations
- **Multiple CGM Support**: Compatible with Dexcom G6/G7, Libre, and other sensors
- **Multiple Pump Support**: Compatible with Omnipod and Medtronic pumps

## Requirements

- iOS 16.2 or later
- Xcode 15.0 or later
- Swift 5.5 or later
- Compatible insulin pump (Omnipod or Medtronic)
- Compatible CGM (Dexcom G6/G7, Libre, etc.)

## Project Structure

```
INSU/
├── Loop-260117-1851/
│   └── LoopWorkspace/           # Main Xcode workspace
│       ├── Loop/                # Main iOS app
│       │   ├── Loop/            # App target
│       │   └── LoopUI/          # UI framework
│       │       └── Views/
│       │           └── HomeCards/  # New redesigned home UI
│       ├── LoopKit/             # Core algorithms (DO NOT MODIFY)
│       ├── LoopOnboarding/      # Onboarding flows
│       ├── RileyLinkKit/        # RileyLink communication
│       ├── OmniKit/             # Omnipod pump driver
│       ├── MinimedKit/          # Medtronic pump driver
│       ├── CGMBLEKit/           # CGM BLE communication
│       ├── G7SensorKit/         # Dexcom G7 driver
│       └── LibreTransmitter/    # Libre CGM driver
└── LoopWorkspace/               # Symlink to workspace
```

## Building the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/liyuxiao2/INSU.git
   cd INSU
   ```

2. Open the workspace in Xcode:
   ```bash
   open Loop-260117-1851/LoopWorkspace/LoopWorkspace.xcworkspace
   ```

3. Configure signing:
   - Select the Loop target
   - Set your development team in Signing & Capabilities
   - Update the bundle identifier if needed

4. Build and run on your device or simulator

## Home Screen Redesign

The new home screen features a modern card-based interface built with SwiftUI:

- **Dashboard Card**: Large glucose display with trend arrow and IOB
- **Pod Status Card**: Reservoir level and pod expiration info
- **Insulin Mode Card**: Current delivery mode (automated/manual)
- **Last Bolus Card**: Recent bolus information
- **Bottom Navigation Bar**: Quick access to Home, Stats, History, and Profile

### Color Palette

| Color | Hex Code | Usage |
|-------|----------|-------|
| Insu Blue | #A4C8E1 | Primary accent |
| Dark Blue | #1F3C6E | Headers, titles |
| Background | #F5F6F7 | Main background |
| Card Background | #FFFFFF | Card surfaces |

## Safety Information

This is a medical device application for automated insulin delivery. **Patient safety is paramount.**

### Protected Components (DO NOT MODIFY)

- Insulin delivery algorithms (`LoopKit`)
- Pump communication drivers
- CGM communication drivers
- Dosing calculations
- Therapy settings validation
- Alert/safety systems
- HealthKit integration

### Modifiable Components

- UI/UX views and styling
- Onboarding flows (non-therapy related)
- Navigation and presentation
- Visual design elements

## Contributing

When contributing to this project:

1. **Never modify safety-critical code** listed above
2. Follow the existing code style and architecture
3. Test thoroughly on simulators before device testing
4. Create feature branches from `main`
5. Submit pull requests with clear descriptions

## Technology Stack

- **Swift** - Primary language
- **SwiftUI** - Modern UI framework (new components)
- **UIKit** - Legacy UI framework
- **Combine** - Reactive programming
- **HealthKit** - Health data integration
- **CoreBluetooth** - Device communication

## License

This project is based on Loop, which is licensed under the MIT License. See the original [Loop repository](https://github.com/LoopKit/Loop) for license details.

## Disclaimer

This software is intended for investigational use only. It is not approved by the FDA or any regulatory body for commercial distribution. Users assume all risks associated with the use of this software for diabetes management.

## Acknowledgments

- [LoopKit](https://github.com/LoopKit) - Original Loop development team
- [Loop Community](https://loopandlearn.org/) - Documentation and support
- All contributors to the Loop ecosystem
