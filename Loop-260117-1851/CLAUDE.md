# CLAUDE.md - AI Assistant Guidelines for Loop/INSU

## SAFETY-CRITICAL RESTRICTIONS

**This is a medical device application for automated insulin delivery. Patient safety is paramount.**

### DO NOT MODIFY files related to:

- **Insulin delivery algorithms** - `LoopDataManager`, `DoseStore`, `LoopAlgorithm`, `LoopMath`
- **Pump communication** - `PumpManager`, `PumpOps`, any pump drivers in `RileyLink`, `OmniKit`, `MinimedKit`
- **CGM communication** - `CGMManager`, sensor drivers in `CGMBLEKit`, `G7SensorKit`, `LibreTransmitter`
- **Dosing calculations** - `BolusRecommendation`, `BasalRateSchedule`, `TempBasalRecommendation`
- **Therapy settings validation** - `TherapySettings`, glucose targets, insulin sensitivity, carb ratios
- **Alert/safety systems** - `AlertManager`, critical alerts, safety notifications
- **HealthKit integration** - Health data storage and retrieval for medical data

These components directly affect patient safety and insulin delivery.

### ALLOWED MODIFICATIONS

- UI/UX changes (Views, ViewControllers) that don't affect medical logic
- Onboarding flows (non-therapy related screens)
- Styling, theming, and visual design
- Navigation and presentation logic
- Mock/placeholder UI screens
- Non-medical settings and preferences

## Project Structure

- `/LoopWorkspace/Loop/Loop/` - Main iOS app
- `/LoopWorkspace/Loop/Loop/Views/` - SwiftUI views (safe to modify)
- `/LoopWorkspace/Loop/Loop/Managers/` - App managers (modify with caution)
- `/LoopWorkspace/LoopKit/` - Core algorithms (DO NOT MODIFY)
- `/LoopWorkspace/RileyLink*/` - Pump communication (DO NOT MODIFY)
- `/LoopWorkspace/CGMBLEKit/` - CGM drivers (DO NOT MODIFY)

## When in Doubt

If you're unsure whether a change could affect insulin delivery or patient safety, **DO NOT make the change**. Ask for clarification first.
