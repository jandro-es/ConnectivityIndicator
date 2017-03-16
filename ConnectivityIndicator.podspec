#
# Be sure to run `pod lib lint ConnectivityIndicator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConnectivityIndicator'
  s.version          = '1.0.0'
  s.summary          = 'Simple animated control to display activity or connectivity status'

  s.description      = <<-DESC
Simple animated control wich informs the user of the status of an activity or a connection.
                       DESC

  s.homepage         = 'https://github.com/jandro-es/ConnectivityIndicator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jandro-es' => 'jandrob1978@gmail.com' }
  s.source           = { :git => 'https://github.com/jandro-es/ConnectivityIndicator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/jandro_es'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ConnectivityIndicator/Classes/**/*'
end
