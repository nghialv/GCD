Pod::Spec.new do |s|
  s.name         = "GCD"
  s.version      = "0.2"
  s.summary      = "A wrapper of Grand Central Dispatch written in Swift"
  s.homepage     = "https://github.com/nghialv/GCD"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "nghialv" => "nghialv2607@gmail.com" }
  s.social_media_url   = "https://twitter.com/nghialv2607"
  s.platform     = :ios
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/nghialv/GCD.git", :tag => "0.2" }
  s.source_files  = "GCD.swift"
  s.requires_arc = true
end
