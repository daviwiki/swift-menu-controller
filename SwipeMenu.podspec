#
# Be sure to run `pod lib lint SwipeMenu.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwipeMenu'
  s.version          = '1.0.0'
  s.summary          = 'Swipe menu is a little piece that add you support to display a menu easily'

  s.description      = <<-DESC
SwipeMenu offers you a rapid implementation to display a menu with two items:

- The menu controller
- The content controller

in a few lines of code.
                       DESC

  s.homepage         = 'https://github.com/daviwiki/swift-menu-controller'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "David Martínez" => "daviddvd19@gmail.com" }
  s.source           = { :git => 'git@github.com:daviwiki/swift-menu-controller.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.source_files    = 'SwipeMenu/Classes/**/*'
  s.framework       = 'UIKit'

end
