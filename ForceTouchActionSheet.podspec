#
# Be sure to run `pod lib lint ForceTouchActionSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ForceTouchActionSheet'
  s.version          = '0.2'
  s.summary          = 'ForceTouchActionSheet is a UI component to replicate iOS\'s Springboard force touch on icons for shortcuts.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  ForceTouchActionSheet is a UI component to replicate iOS's Springboard force touch on icons for shortcuts.
  It blurs the background gradually while force touching an item and shows the popup when force reaches the maximum.
                       DESC

  s.homepage         = 'https://github.com/ivanbruel/ForceTouchActionSheet'
  s.screenshots      = 'https://raw.githubusercontent.com/ivanbruel/ForceTouchActionSheet/master/Resources/forcetouch_demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ivan Bruel' => 'ivan.bruel@gmail.com' }
  s.source           = { :git => 'https://github.com/ivanbruel/ForceTouchActionSheet.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ivanbruel'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ForceTouchActionSheet/Classes/**/*'
  s.frameworks = 'UIKit'
end
