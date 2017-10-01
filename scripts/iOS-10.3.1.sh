#!/bin/sh

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-iOS \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 6S,OS=10.3.1" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | bundle exec xcpretty
