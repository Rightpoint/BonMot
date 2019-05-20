#!/bin/sh
# Any arguments passed are passed to xcodebuild

set -o pipefail && \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "platform=watchOS Simulator,name=Apple Watch Series 3 - 38mm,OS=5.1" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= $@\
  | bundle exec xcpretty
