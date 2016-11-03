#!/bin/sh

set -o pipefail && \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "platform=watchOS Simulator,name=Apple Watch - 38mm" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty

set -o pipefail && TOOLCHAINS=com.apple.dt.toolchain.Swift_2_3 && \
  xcodebuild clean build \
  -project BonMot.xcodeproj \
  -scheme BonMot-watchOS \
  -sdk watchsimulator \
  -destination "platform=watchOS Simulator,name=Apple Watch - 38mm" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty \
