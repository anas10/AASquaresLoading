#
#  Be sure to run `pod spec lint AASquaresLoading.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AASquaresLoading"
  s.version      = "0.1"
  s.summary      = "Simple loading animation using squares"

  s.homepage     = "https://github.com/anas10/AASquaresLoading"
  s.license      = "MIT"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Anas AIT ALI" => "aitali.anas@gmail.com" }
  s.social_media_url   = "http://twitter.com/anas10fr"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/anas10/AASquaresLoading.git", :tag => s.version.to_s }
  s.source_files  = "Source"
  s.frameworks = 'UIKit'
end
