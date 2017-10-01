#!/bin/sh

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-tvOS \
  -sdk appletvsimulator \
  -destination "platform=tvOS Simulator,name=Apple TV 1080p,OS=10.2" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | bundle exec xcpretty
