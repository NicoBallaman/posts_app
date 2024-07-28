## Prerequisites
- Flutter 3.22.3
- Dart 3.4.4

## Installation

1. Clone this repository: 
    `https://github.com/NicoBallaman/posts_app.git`
2. Navigate to the project directory:
    `cd posts_app`
3. Install dependencies:
    `flutter pub get`


## Feature Package Architecture

The project is organized into feature packages, each representing a distinct functional area of the application designed to be scalable, maintainable, and testable. This approach promotes modularity and separation of concerns.

Structure:
components/
└── fav_post
    └── presentation/
core/
features/
├── post_comments/
└── post_list/
lib/
├── application
├── modules
└── main.dart

Each feature package contains:
- `data`:  data sources
- `di`:  feature specific dependency injection
- `domain`: Use cases, repositories definitions and entity models
- `localization`: feature specific localization
- `presentation`: BLoC, screens, and widgets specific to the feature

## Project Structure

The main package of our application is organized as follows:
- `application/`: Contains the core application setup and configuration.
    - `application.dart`: Defines the main application widget.

- `modules/`: App feature modules, each representing a distinct functional area of the app.
  - `posts_module/`: Module to handle posts-related functionality.
    - `pages/`: Contains the UI pages related to the posts feature.
    - `post_module.dart`: Defines the module's structure, routes, dependencies and localizations.

- `ioc_manager.dart`: Manages dependency injection for the entire application.

- `main.dart`: The entry point of the application, defines and initializes all modules of the app (modules di and routes)



## Main Libraries

- `flutter_bloc`: For state management and separation of business logic from the UI
- `go_router`: For declarative routing and navigation
- `dio`: For making HTTP requests and handling API interactions
- `get_it`: For dependency injection
- `infinite_scroll_pagination`: For implementing infinite scrolling lists
- `mockito`: For creating mock objects in unit tests
- `bloc_test`: For testing BLoC classes

## Testing

Each feature contains unit test for bloc and repositories. To run unit tests:
1. cd to component/feature
2. `flutter test`