source 'https://rubygems.org'

gem 'cocoapods', '1.5.0'

# xcpretty still does not support testing multiple devices in parallel
gem 'xcpretty', :git => 'https://github.com/Raizlabs/xcpretty.git', :branch => 'feature/parallel-testing-support'

# Danger
group :test, :danger do
  gem 'slather'
  gem 'circleci_artifact'
  gem 'xcov'

  # Our fork allows us to limit the max concurrent simulators, which is needed on CircleCI
  gem 'fastlane', :git => 'https://github.com/Raizlabs/fastlane.git', :branch => 'scan/max_concurrent_simulators'
end

group :danger do
  gem 'danger'
  gem 'danger-swiftlint'
  gem 'danger-xcov'
  gem 'danger-junit'
end

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
