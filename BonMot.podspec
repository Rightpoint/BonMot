Pod::Spec.new do |s|
  s.name             = "BonMot"
  s.version          = "4.0-beta1"
  s.summary          = "A swifty attributed string generation library."
  s.description      = <<-DESC
  BonMot removes all the mystery from creating beautiful, powerful attributed strings on iOS.
                       DESC
  s.homepage         = "https://github.com/Raizlabs/BonMot"
  s.license          = 'MIT'
  s.author           = { "Zev Eisenberg" => "zev.eisenberg@raizlabs.com" }
  s.source           = { :git => "https://github.com/Raizlabs/BonMot.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ZevEisenberg'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.frameworks = 'UIKit'

  s.default_subspec = 'Core'

  s.subspec 'Core' do |sp|
    sp.source_files = 'Source/*.swift'
  end

  s.subspec 'UIKit' do |sp|
    sp.source_files = 'Source/UIKit/*.swift'
  end

end
