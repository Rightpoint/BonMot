#
# Be sure to run `pod lib lint BonMot.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BonMot"
  s.version          = "1.2"
  s.summary          = "An Objective-C attributed string generation library."
  s.description      = <<-DESC
  BonMot removes all the mystery from creating beautiful, powerful attributed strings on iOS.
                       DESC
  s.homepage         = "https://github.com/ZevEisenberg/BonMot"
  s.license          = 'MIT'
  s.author           = { "Zev Eisenberg" => "zev.eisenberg@raizlabs.com" }
  s.source           = { :git => "https://github.com/ZevEisenberg/BonMot.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ZevEisenberg'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod', 'Pod/Classes/**/*'
  s.private_header_files = "Pod/Classes/*_Private.h"

  s.frameworks = 'UIKit'
end
