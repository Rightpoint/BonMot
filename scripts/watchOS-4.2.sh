#!/bin/sh

set -o pipefail && \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "platform=watchOS Simulator,name=Apple Watch - 38mm,OS=4.2" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | bundle exec xcpretty
