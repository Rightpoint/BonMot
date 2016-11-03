#!/bin/sh

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-tvOS \
  -sdk appletvsimulator \
  -destination "id=48B0E1AB-F5EB-40FB-9372-A16B93349B12" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty

set -o pipefail && TOOLCHAINS=com.apple.dt.toolchain.Swift_2_3 && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-tvOS \
  -sdk appletvsimulator \
  -destination "id=48B0E1AB-F5EB-40FB-9372-A16B93349B12" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty
