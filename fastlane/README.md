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
or alternatively using `brew cask install fastlane`

# Available Actions
### coverage_all
```
fastlane coverage_all
```
Tests: iOS, tvOS, macOS. Builds: watchOS.

----

## Mac
### mac coverage_macos
```
fastlane mac coverage_macos
```
Runs Tests & Generates Code Coverage Reports for macOS

----

## iOS
### ios coverage_ios
```
fastlane ios coverage_ios
```
Runs Tests & Generates Code Coverage Reports for iOS 10.3.1 and latest iOS
### ios coverage_ios_10_3
```
fastlane ios coverage_ios_10_3
```
Runs Tests & Generates Code Coverage Reports for iOS 10.3.1
### ios coverage_ios_latest
```
fastlane ios coverage_ios_latest
```
Runs Tests & Generates Code Coverage Reports for latest iOS
### ios coverage_tvos
```
fastlane ios coverage_tvos
```
Runs Tests & Generates Code Coverage Reports for tvOS
### ios build_watchos
```
fastlane ios build_watchos
```
Build for watchOS

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
