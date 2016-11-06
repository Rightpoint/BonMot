#!/bin/sh

## Circle's OS X image is messed up
## https://discuss.circleci.com/t/multiple-ios-simulators-available-for-single-os-device-configurations/7854
## If you are getting an error "Unable to find a destination matching the provided destination specifier:"
## replace platform=watchOS Simulator,name=Apple Watch - 38mm,OS=10.0 with id=$ID where $ID is one of
## of the ones provided

set -o pipefail && \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "id=8B69EEB7-101D-46FA-AB3C-A8B7BCCF004B" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty

set -o pipefail && TOOLCHAINS=com.apple.dt.toolchain.Swift_2_3 \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "id=8B69EEB7-101D-46FA-AB3C-A8B7BCCF004B" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty \
