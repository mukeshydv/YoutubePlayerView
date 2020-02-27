Pod::Spec.new do |s|
  s.name             = 'YoutubePlayerView'
  s.version          = '1.2.1'
  s.summary          = 'Helper library for iOS developers that want to embed YouTube videos in their iOS apps with the iframe player API.'

  s.description      = <<-DESC
  Helper library for iOS developers that want to play YouTube videos in their iOS apps with the iframe player API.
  This library allows iOS developers to quickly embed YouTube videos within their applications via a custom WKWebView subclass, YoutubePlayerView.
                       DESC

  s.homepage         = 'https://github.com/mukeshydv/YoutubePlayerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mukesh Yadav' => 'mails4ymukesh@gmail.com' }
  s.source           = { :git => 'https://github.com/mukeshydv/YoutubePlayerView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/YoutubePlayerView/*.swift'
end
