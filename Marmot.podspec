Pod::Spec.new do |s|
  s.name             = 'Marmot'
  s.version          = '0.1.2'
  s.summary          = 'A javascript bridge with khala.'
  s.homepage         = 'https://github.com/Marmot-App/Marmot-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'linhay' => 'is.linhey@outlook.com' }
  s.source           = { :git => 'https://github.com/Marmot-App/Marmot-iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  s.source_files = 'Marmot/Classes/**/*'
  s.resource_bundles = { 'Marmot' => ['Marmot/Assets/*.js'] }
  s.dependency 'Khala', '0.1.0'
end
