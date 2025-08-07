Pod::Spec.new do |s|
  s.name         = "AlgoframeMeetSDK"
  s.version      = "1.0.0"
  s.summary      = "Precompiled AlgoframeMeetSDK XCFramework"
  s.description  = "This pod provides the prebuilt AlgoframeMeetSDK as an XCFramework."
  s.homepage     = "http://algoframe.in"
  s.author       = { "Algoframe" => "you@example.com" }

  s.platform     = :ios, "12.0"
  s.requires_arc = true

  s.source       = { :path => "." }

  s.vendored_frameworks = "sdk/out/AlgoframeMeetSDK.xcframework", "sdk/out/hermes.xcframework"
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '"$(PODS_ROOT)/sdk/out"',
  }

  s.dependency 'Giphy', '2.2.12'
  s.dependency 'JitsiWebRTC', '~> 124.0'

  # If your framework contains resources (e.g. main.jsbundle, assets)
  s.resources = ["sdk/out/AlgoframeMeetSDK.xcframework/**/*.{jsbundle,png,json}"]

end
