
Pod::Spec.new do |s|
  s.name             = 'SwipeMenu'
  s.version          = '2.0.0'
  s.summary          = 'Swipe menu is a little piece that add you support to display a menu easily'

  s.description      = <<-DESC
SwipeMenu offers you a fast implementation to display a menu with two items:

- The menu controller
- The content controller

in a few lines of code.
                       DESC

  s.homepage         = 'https://github.com/daviwiki/swift-menu-controller'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'David Martínez'
  s.source           = { :git => 'https://github.com/daviwiki/swift-menu-controller.git', :tag => s.version.to_s }

  s.swift_version = '4.1'
  s.ios.deployment_target = '10.0'

  s.source_files    = 'SwipeMenu/Classes/**/*'
  s.framework       = 'UIKit'

end
