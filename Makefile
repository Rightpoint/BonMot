test_ios:
	xcodebuild test -scheme BonMot -destination "platform=iOS Simulator,name=iPhone 15" | xcbeautify

test_macos:
	xcodebuild test -scheme BonMot -destination platform=macOS,arch=arm64 | xcbeautify

test_tvos:
	xcodebuild test -scheme BonMot -destination "platform=tvOS Simulator,name=Apple TV" | xcbeautify

test_watchos:
	xcodebuild test -scheme BonMot -destination "platform=watchOS Simulator,name=Apple Watch Series 9 (45mm)" | xcbeautify

test_all:
	# Platforms listed in order of convenience to run, so if there's a failure early it's easier to test.
	test_macos
	test_ios
	test_tvos
	test_watchos
