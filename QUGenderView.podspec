#
# Be sure to run `pod lib lint QUGenderView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QUGenderView'
  s.version          = '0.1.0'
  s.summary          = 'Cool Animation for gender selection in your iOS Application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Cool Animation for gender selection in your iOS Application.
GenderView is the main class which holds all control of animation as well as user interaction on gender selection.
you can user this class in few steps. Initializer method of GenderView takes a color as parameter which is the clothing color of male and female.
                       DESC

  s.homepage         = 'https://github.com/syedqamara/QUGenderView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'syedqamara' => 'syedqamar.a1@gmail.com' }
  s.source           = { :git => 'https://github.com/syedqamara/QUGenderView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
#s.swiftversion = "4.1"
  s.source_files = 'QUGenderView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QUGenderView' => ['QUGenderView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
