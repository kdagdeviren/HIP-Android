# MVVM.prompt.md

## Language Rules
- **Code and comments must be in English.**
- **All explanations and reasoning must be in Turkish.**

## Project Main Prompt

### Architecture
- Use **Clean Architecture** with MVVM pattern.
- Layers:
  - `core` → utils, configs, service locator
  - `features` → each feature has its own MVVM structure:
    - `data` → remote/local sources, repository implementations
    - `domain` → entities & use cases
    - `presentation` → views, viewmodels, widgets

### State Management
- Use **Provider**.
- ViewModels must extend `ChangeNotifier`.
- Inject with `ChangeNotifierProvider` or `MultiProvider`.

### Rules
- **View**: only UI code. Uses `Consumer` / `Selector` to listen ViewModel.
- **ViewModel**: contains business logic, calls UseCases, manages state.
- **UseCase**: single responsibility, encapsulates one business operation.
- **Repository**: abstracts data sources.
- **Entity**: pure data models in domain layer.

### Notes
- Each new feature must have its own folder structure.
- Use `Provider` or `MultiProvider` for Dependency Injection.
- Each layer should be testable independently.
