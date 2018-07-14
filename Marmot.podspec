#
# Be sure to run `pod lib lint Marmot.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Marmot'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Marmot.'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
  DESC
  
  s.homepage         = 'https://github.com/is.linhay@outlook.com/Marmot'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'is.linhay@outlook.com' => 'is.linhay@outlook.com' }
  s.source           = { :git => 'https://github.com/is.linhay@outlook.com/Marmot.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.platform = :osx
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "8.0"
  
  s.source_files = 'Marmot/Classes/*.{h,swift}'
  
  s.resource_bundles = {
    'Marmot' => ['Marmot/Assets/*.{png,js}']
  }
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Cocoa'
  s.dependency 'SPRoutable', '0.9.9.1.alpha'
  # s.dependency 'AnyFormatProtocol', '0.5.2'
  # s.dependency 'BLFoundation'
  
end
