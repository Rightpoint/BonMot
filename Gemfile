source 'https://rubygems.org'

gem 'cocoapods', '~> 1.7.0'
gem 'xcpretty'

# Danger
group :test, :danger do
  gem 'slather'
  gem 'circleci_artifact'
  # Waiting on 1.5.1 release for xccov_file_direct_path support
  gem 'xcov', :git => 'https://github.com/nakiostudio/xcov.git', :branch => 'master'
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
