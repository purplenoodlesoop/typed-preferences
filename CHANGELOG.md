# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] – 2022-12-02
### Added
- Added methods to `PreferencesDriverObserver` that run before the `on*` methods – `beforeSet`, `beforeGet`, ...

### Changed
- [BREAKING] `PreferencesDriverObserver`'s methods' generics now must extend `Object`
- Internal Observers-related refactoring to enforce Separation of Concerns

## [0.1.0+1] – 2022-10-20
### Added
- Shields to README

### Fixed
- Imports in example
- Readme formatting

## [0.1.0] – 2022-10-20
### Added
- Initial version