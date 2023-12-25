source 'https://rubygems.org'

gem 'cocoapods'
gem 'fastlane'
gem 'nkf' # added this because a warning told me to. It is a dependency of CFPropertyList which is a dependency of something else, maybe fastlane?
gem 'xcpretty'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
