require 'circleci_artifact'

# Make it more obvious that a PR is a work in progress and shouldn't be merged yet.
has_wip_label = github.pr_labels.any? { |label| label.include? "WIP" }
has_wip_title = github.pr_title.include? "[WIP]"

if has_wip_label || has_wip_title
    warn("PR is classed as Work in Progress")
end

# Warn when there is a big PR.
warn("Big PR") if git.lines_of_code > 500

# Mainly to encourage writing up some reasoning about the PR, rather than just leaving a title.
if github.pr_body.length < 3 && git.lines_of_code > 10
  warn("Please provide a summary in the Pull Request description")
end

src_root = File.expand_path('../', __FILE__)

SCHEME = "BonMot-iOS"

result_bundle_path = "#{src_root}/build/#{SCHEME}/scan/#{SCHEME}.xcresult-coverage"
xccoverage_files = Dir.glob("#{result_bundle_path}/**/action.xccovreport").sort_by { |filename| File.mtime(filename) }.reverse
xccov_file_direct_path = xccoverage_files.first

xcov.report(
  project: "#{src_root}/BonMot.xcodeproj",
  scheme: SCHEME,
  output_directory: "#{src_root}/build/#{SCHEME}/xcov",
  xccov_file_direct_path: xccov_file_direct_path
)

## ** SwiftLint ***
swiftlint.binary_path = "/usr/local/bin/swiftlint"
swiftlint.config_file = "#{src_root}/.swiftlint.yml"

# Run SwiftLint and warn us if anything fails it
swiftlint.directory = src_root
swiftlint.lint_files inline_mode: true

# Getting artifact URLs from CircleCI

# You must set up the CIRCLE_API_TOKEN manually using these instructions
# https://github.com/Rightpoint/ios-template/tree/master/PRODUCTNAME#danger
token = ENV['CIRCLE_API_TOKEN']
# These are already in the Circle environment
# https://circleci.com/docs/2.0/env-vars/#build-specific-environment-variables
username = ENV['CIRCLE_PROJECT_USERNAME']
reponame = ENV['CIRCLE_PROJECT_REPONAME']
build = ENV['CIRCLE_BUILD_NUM']

if !(token.nil? or username.nil? or reponame.nil? or build.nil?)
  fetcher = CircleciArtifact::Fetcher.new(token: token, username: username, reponame: reponame, build: build)

  xcov = CircleciArtifact::Query.new(url_substring: 'xcov/index.html')
  slather = CircleciArtifact::Query.new(url_substring: 'slather/index.html')
  xcpretty = CircleciArtifact::Query.new(url_substring: 'scan/report.html')
  xchtmlreport = CircleciArtifact::Query.new(url_substring: 'scan/index.html')
  queries = [xcov, slather, xcpretty, xchtmlreport]
  results = fetcher.fetch_queries(queries)

  xcov_url = results.url_for_query(xcov)
  slather_url = results.url_for_query(slather)
  xcpretty_url = results.url_for_query(xcpretty)
  xchtmlreport_url = results.url_for_query(xchtmlreport)

  if !xchtmlreport_url.nil?
    message "[Test Results](#{xchtmlreport_url})"
  else
    message "Tests in progress..."
  end

  if !slather_url.nil?
    message "[Code Coverage](#{slather_url})"
  end
else
  warn "Missing CircleCI artifacts. Most likely the [CIRCLE_API_TOKEN](https://github.com/Rightpoint/circleci_artifact#getting-started) is not set, or Danger is not running on CircleCI."
end

# Test Reporting

junit.parse "#{src_root}/build/BonMot-iOS/scan/BonMot-iOS.xcresult/report.junit"
junit.report
