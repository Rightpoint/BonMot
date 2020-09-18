fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### coverage_all
```
fastlane coverage_all
```
Tests & Coverage: iOS, tvOS, macOS. Builds: watchOS.
### test_all
```
fastlane test_all
```
Tests: iOS, tvOS, macOS. Builds: watchOS.

----

## Mac
### mac coverage_macos
```
fastlane mac coverage_macos
```
Runs Tests & Generates Code Coverage Reports for macOS
### mac test_macos
```
fastlane mac test_macos
```
Runs Tests for macOS

----

## iOS
### ios coverage_ios
```
fastlane ios coverage_ios
```
Runs Tests & Generates Code Coverage Reports for latest iOS
### ios test_ios
```
fastlane ios test_ios
```
Runs Tests for latest iOS
### ios coverage_tvos
```
fastlane ios coverage_tvos
```
Runs Tests & Generates Code Coverage Reports for tvOS
### ios test_tvos
```
fastlane ios test_tvos
```
Runs Tests for tvOS
### ios build_watchos
```
fastlane ios build_watchos
```
Build for watchOS

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
