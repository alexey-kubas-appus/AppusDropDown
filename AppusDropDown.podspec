#
#  Be sure to run `pod spec lint AppusDropDown.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "AppusDropDown"
  s.version      = "0.0.1"
  s.summary      = "AppusDropDown allow you to use a drop down with single or multiply selection"
  s.homepage     = "http://appus.pro"
s.license      = { :type => "Apache", :file => "LICENSE" }
  s.author             = { "Alexey Kubas" => "alexey.kubas@appus.me" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/alexey-kubas-appus/AppusDropDown.git", :tag => "0.0.1" }
  s.source_files = "AppusDropDown", "AppusDropDown/*.{h,m}"
  s.frameworks             = 'Foundation', 'UIKit'
  s.requires_arc = true
end
