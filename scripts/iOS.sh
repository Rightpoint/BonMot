#!/bin/sh

## Currently hardcoding the destination id while circle's OS X image is messed up
## https://discuss.circleci.com/t/multiple-ios-simulators-available-for-single-os-device-configurations/7854
## Once fixed replace "id=$ID" with "platform=iOS Simulator,name=iPhone 6S,OS=10.0"

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-iOS \
  -sdk iphonesimulator \
  -destination "id=55CA63D0-DBF6-4F35-A5B6-31AA93F6A3E7" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty

set -o pipefail && TOOLCHAINS=com.apple.dt.toolchain.Swift_2_3 \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-iOS \
  -sdk iphonesimulator \
  -destination "id=55CA63D0-DBF6-4F35-A5B6-31AA93F6A3E7" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty \
