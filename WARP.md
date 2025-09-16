# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a Flutter application for iOS that demonstrates Apple PassKit functionality. It uses a feature-based architecture with separate packages for the API client, data models, and repositories. State management is handled by the BLoC pattern.

## Common Commands

### Running the App

This project has three flavors: development, staging, and production. Use the following commands to run the desired flavor:

*   **Development:** `flutter run --flavor development --target lib/main_development.dart`
*   **Staging:** `flutter run --flavor staging --target lib/main_staging.dart`
*   **Production:** `flutter run --flavor production --target lib/main_production.dart`

**Note:** This app works on iOS only.

### Running Tests

To run all unit and widget tests, use the following command:

`flutter test --coverage --test-randomize-ordering-seed random`

To generate and view the coverage report:

1.  `genhtml coverage/lcov.info -o coverage/`
2.  `open coverage/index.html`

### Internationalization

To generate translations, run the following command:

`flutter gen-l10n --arb-dir="lib/l10n/arb"`

## Code Architecture

The project is structured as a Flutter application with several local packages:

*   `api_client`: Handles communication with the backend API.
*   `api_models`: Defines the data models used throughout the application.
*   `pass_repository`: Manages PassKit-related data and logic.
*   `user_repository`: Manages user-related data.

The application follows the BLoC (Business Logic Component) pattern for state management, separating business logic from the UI. Feature-specific Blocs can be found in the `lib` directory, organized by feature.

