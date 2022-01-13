#
# Be sure to run `pod lib lint RVSubscriptionCenter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RVSubscriptionCenter'
  s.version          = '0.1.0'
  s.summary          = 'RVSubscriptionCenter'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  RVSubscriptionCenter.
                       DESC

  s.homepage         = 'https://github.com/hondaVSP/RVSubscriptionCenter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zac' => 'gong@reachauto.com' }
  s.source           = { :git => 'https://github.com/hondaVSP/RVSubscriptionCenter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.watchos.deployment_target = '6.0'
  
  s.source_files = 'RVSubscriptionCenter/Classes/**/*'
  
  # s.resource_bundles = {
  #   'RVSubscriptionCenter' => ['RVSubscriptionCenter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
