#
# Be sure to run `pod lib lint WatchfaceSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WatchfaceSDK'
  s.version          = '1.0.1'
  s.summary          = 'A short description of WatchfaceSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/HWdan/WatchfaceSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HWdan' => 'huangwentai@huawo-wear.com' }
  s.source           = { :git => 'https://gitee.com/huangwt1573/watchface-sdk.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version    = '4.2'
  s.source_files = 'WatchfaceSDK/Classes/Watchface/**/*'
  
#  s.resource_bundles = {
#    'WatchfaceSDKImg' => ['WatchfaceSDK/Assets/*']
#  }
  s.resources = ['WatchfaceSDK/Assets/*']

  s.vendored_frameworks = 'WatchfaceSDK/SFDialPlateSDK.framework', 'WatchfaceSDK/eZIPSDK.framework'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Zip', '~> 2.1'
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
end
