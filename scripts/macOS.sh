#!/bin/sh
# Any arguments passed are passed to xcodebuild

set -o pipefail && \
  xcodebuild clean build test \
  -project BonMot.xcodeproj \
  -scheme BonMot-OSX \
  -sdk macosx \
  -destination "arch=x86_64" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGN_IDENTITY= $@\
  | bundle exec xcpretty
