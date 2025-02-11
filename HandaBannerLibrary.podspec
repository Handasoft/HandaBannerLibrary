#
# Be sure to run `pod lib lint HandaBannerLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HandaBannerLibrary'
  s.version          = '0.1.2'
  s.summary          = 'Library for Handasoft Corp.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Handasoft/HandaBannerLibrary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           =
  s.source           = { :git => 'https://github.com/Handasoft/HandaBannerLibrary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HandaBannerLibrary/Classes/**/*'

    s.subspec 'no-arc' do |sp|
    sp.source_files = 'HandaBannerLibrary/Classes/Ads/Mezzo/JSONKit.{h,m}'
    sp.requires_arc  = false
    end
  # s.resource_bundles = {
  #   'HandaBannerLibrary' => ['HandaBannerLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
