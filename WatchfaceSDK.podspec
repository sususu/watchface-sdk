Pod::Spec.new do |s|
  s.name             = 'WatchfaceSDK'
  s.version          = '1.0.3'
  s.summary          = 'A short description of WatchfaceSDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/HWdan/WatchfaceSDK'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HWdan' => 'huangwentai@huawo-wear.com' }
  s.source           = { :git => 'https://gitee.com/huangwt1573/watchface-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version    = '4.2'
  s.source_files = 'WatchfaceSDK/Classes/Watchface/**/*','WatchfaceSDK/Classes/OTA/**/*'
  s.resources = ['WatchfaceSDK/Assets/*']

  s.vendored_frameworks = 'WatchfaceSDK/SFDialPlateSDK.framework', 'WatchfaceSDK/eZIPSDK.framework', 'WatchfaceSDK/SifliOTAManagerSDK.framework','WatchfaceSDK/VideoWatchfaceSDK.framework'
  
  s.frameworks = 'AudioToolbox', 'CoreMedia', 'VideoToolbox'
  s.libraries = 'z', 'bz2', 'iconv'

  s.dependency 'Zip', '~> 2.1'
  s.dependency 'SSZipArchive'
  s.dependency 'Masonry'
  s.pod_target_xcconfig = { 'VALID_ARCHS[sdk=iphonesimulator*]' => '' }
end
