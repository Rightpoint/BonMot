source 'https://rubygems.org'

gem 'cocoapods', :git => 'https://github.com/cocoapods/cocoapods.git', :branch => 'master'
gem 'xcpretty'

# Danger
group :test, :danger do
  gem 'slather'
  gem 'circleci_artifact'
  gem 'xcov'
  gem 'fastlane'
end

group :danger do
  gem 'danger'
  gem 'danger-swiftlint'
  gem 'danger-xcov'
  gem 'danger-junit'
end

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
