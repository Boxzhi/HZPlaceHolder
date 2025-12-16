#
#  Be sure to run `pod spec lint HZPlaceHolder.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name = 'HZPlaceHolder'
  s.version = '1.3.2'
  s.license = 'MIT'
  s.summary = 'Quickly create a null data placeholder view'
  s.homepage = 'https://github.com/Boxzhi/HZPlaceHolder'
  s.author = { 'HeZhizhi' => 'coderhzz@163.com' }
  s.social_media_url = 'https://www.jianshu.com/u/9767e7dda727'
  s.source = { :git => 'git@github.com:Boxzhi/HZPlaceHolder.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.framework = 'UIKit'
  s.requires_arc = true
  s.swift_version = '5.0'
  s.static_framework = true

  # s.default_subspec = 'PlaceHolderView'

  s.subspec 'PlaceHolderView' do |placeHolderView|
    placeHolderView.source_files = 'HZPlaceHolder/PlaceHolderView/*.swift'
  end

  s.subspec 'Refresh' do |refresh|
    refresh.source_files = 'HZPlaceHolder/Refresh/*.swift'
    refresh.dependency 'MJRefresh'
  end

end