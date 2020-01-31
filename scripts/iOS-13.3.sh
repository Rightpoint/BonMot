#!/bin/sh
# Any arguments passed are passed to xcodebuild

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-iOS \
  -sdk iphonesimulator \
  -destination "platform=iOS Simulator,name=iPhone 6s,OS=13.3" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= $@\
  | bundle exec xcpretty
