source 'https://rubygems.org'

gem 'cocoapods', '1.5.0'

# xcpretty still does not support testing multiple devices in parallel
gem 'xcpretty', :git => 'https://github.com/Raizlabs/xcpretty.git', :branch => 'feature/parallel-testing-support'

# Danger
group :test, :danger do
  gem 'slather'
  gem 'circleci_artifact'
  
  # We need to use our fork until xcov upstream is fixed
  # See https://github.com/nakiostudio/xcov/issues/116 for more details
  gem 'xcov', :git => 'https://github.com/Raizlabs/xcov.git', :branch => '1.4.0-rz'

  # We need to use our fork until fastlane deletes scan's result_bundle_path
  # between builds. See https://github.com/fastlane/fastlane/issues/12349
  gem 'fastlane', :git => 'https://github.com/Raizlabs/fastlane.git', :branch => 'bugfix/scan_result_bundle'
end

group :danger do
  gem 'danger'
  gem 'danger-swiftlint'
  gem 'danger-xcov'
  gem 'danger-junit'
end