fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### coverage_all

```sh
[bundle exec] fastlane coverage_all
```

Tests & Coverage: iOS, tvOS, macOS. Builds: watchOS.

### test_all

```sh
[bundle exec] fastlane test_all
```

Tests: iOS, tvOS, macOS. Builds: watchOS.

----


## Mac

### mac coverage_macos

```sh
[bundle exec] fastlane mac coverage_macos
```

Runs Tests & Generates Code Coverage Reports for macOS

### mac test_macos

```sh
[bundle exec] fastlane mac test_macos
```

Runs Tests for macOS

----


## iOS

### ios coverage_ios

```sh
[bundle exec] fastlane ios coverage_ios
```

Runs Tests & Generates Code Coverage Reports for latest iOS

### ios test_ios

```sh
[bundle exec] fastlane ios test_ios
```

Runs Tests for latest iOS

### ios coverage_tvos

```sh
[bundle exec] fastlane ios coverage_tvos
```

Runs Tests & Generates Code Coverage Reports for tvOS

### ios test_tvos

```sh
[bundle exec] fastlane ios test_tvos
```

Runs Tests for tvOS

### ios build_watchos

```sh
[bundle exec] fastlane ios build_watchos
```

Build for watchOS

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
