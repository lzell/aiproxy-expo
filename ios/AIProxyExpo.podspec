Pod::Spec.new do |s|
  s.name           = 'AIProxyExpo'
  s.version        = '0.140.2'
  s.summary        = 'AIProxy Expo Module'
  s.description    = 'Expo native module for AIProxy SDK integration'
  s.author         = 'Lou Zell'
  s.homepage       = 'https://github.com/lzell/aiproxy-expo'
  s.license        = { :type => 'MIT' }
  s.platforms      = { :ios => '17.0' }
  s.source         = { :git => 'https://github.com/lzell/aiproxy-expo.git', :tag => s.version.to_s }
  s.static_framework = true

  s.dependency 'ExpoModulesCore'
  s.dependency 'AIProxy', '0.140.2'

  s.source_files = '*.swift'
end
