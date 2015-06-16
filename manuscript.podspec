#
# Be sure to run `pod lib lint manuscript.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "manuscript"
  s.version          = "0.0.1"
  s.summary          = "An Objective-C attributed string generation library."
  s.description      = <<-DESC
  Manuscript removes all the mystery from creating beautiful, powerful attributed strings on iOS.
                       DESC
  s.homepage         = "https://github.com/ZevEisenberg/manuscript"
  s.license          = 'MIT'
  s.author           = { "Zev Eisenberg" => "zev.eisenberg@raizlabs.com" }
  s.source           = { :git => "https://github.com/ZevEisenberg/manuscript.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ZevEisenberg'

  s.platform     = :ios, '8.3'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'manuscript' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
