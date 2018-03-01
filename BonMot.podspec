Pod::Spec.new do |s|
  s.name             = "BonMot"
  s.version          = "5.2"
  s.summary          = "Beautiful, easy attributed strings in Swift"
  s.swift_version    = "4.0"
  s.description      = <<-DESC
  BonMot removes all the mystery from creating beautiful, powerful attributed strings in Swift.
                       DESC
  s.homepage         = "https://github.com/Raizlabs/BonMot"
  s.license          = 'MIT'
  s.author           = { "Zev Eisenberg" => "zev.eisenberg@raizlabs.com" }
  s.source           = { :git => "https://github.com/Raizlabs/BonMot.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ZevEisenberg'
  s.requires_arc = true

  s.ios.deployment_target = '9.0'
  s.ios.source_files = 'Sources/**/*.swift'

  s.tvos.deployment_target = '9.0'
  s.tvos.source_files = 'Sources/**/*.swift'

  s.osx.deployment_target = '10.11'
  s.osx.source_files = 'Sources/*.swift'

  s.watchos.deployment_target = '2.2'
  s.watchos.source_files = 'Sources/*.swift'

end
