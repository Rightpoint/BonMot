Pod::Spec.new do |s|
  s.name             = "BonMot_Testing"
  s.version          = "2.4.1"
  s.summary          = "Private testing extensions for BonMot"
  s.homepage         = "https://github.com/Raizlabs/BonMot"
  s.license          = 'MIT'
  s.author           = { "Zev Eisenberg" => "zev.eisenberg@raizlabs.com" }
  s.source           = { :git => "https://github.com/Raizlabs/BonMot.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.frameworks = 'UIKit'

  s.source_files = 'Pod', '*.h'
end
