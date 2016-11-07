#!/bin/sh

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-OSX \
  -sdk macosx \
  -destination "arch=x86_64" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty
  
set -o pipefail && TOOLCHAINS=com.apple.dt.toolchain.Swift_2_3 \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-OSX \
  -sdk macosx \
  -destination "arch=x86_64" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= \
  | xcpretty
