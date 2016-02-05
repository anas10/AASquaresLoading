Pod::Spec.new do |s|
  s.name         = "AASquaresLoading"
  s.version      = "0.3.2"
  s.summary      = "Simple loading animation using squares"

  s.homepage     = "https://github.com/anas10/AASquaresLoading"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Anas AIT ALI" => "aitali.anas@gmail.com" }
  s.social_media_url   = "http://twitter.com/anasaitali"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/anas10/AASquaresLoading.git", :tag => s.version.to_s }
  s.source_files  = "Source/AASquaresLoading.swift"

  s.requires_arc = true

end