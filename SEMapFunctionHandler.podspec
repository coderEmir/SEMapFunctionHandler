#
# Be sure to run `pod lib lint SEMapFunctionHandler.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SEMapFunctionHandler'
  s.version          = '0.1.0'
  s.summary          = 'GaoDe map component.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "GaoDe map component for iOS"

  s.homepage         = 'https://github.com/seeEmil/SEMapFunctionHandler'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'seeEmil' => '864009759@qq.com' }
  s.source           = { :git => 'https://github.com/seeEmil/SEMapFunctionHandler.git', :tag => s.version.to_s }

  s.resource_bundles = {
    'SEMapFunctionHandler' => ['SEMapFunctionHandler/Assets/*.png']
  }
  s.ios.deployment_target = '9.0'

  s.source_files = 'SEMapFunctionHandler/Classes/**/{*.swift,*.h}'
  
  s.swift_version='5.0'
  s.static_framework = true
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
  
  s.vendored_frameworks = 'SEMapFunctionHandler/Classes/MAMapKit.framework'
  
  s.dependency 'AMapLocation-NO-IDFA'
  s.dependency 'AMapSearch-NO-IDFA', '~> 6.9.0'
  
  s.dependency 'Reachability'
  s.dependency 'MJRefresh'
  s.dependency 'SnapKit'
end
