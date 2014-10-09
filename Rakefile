# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

require 'bubble-wrap/core'
require 'motion-support/core_ext/object'

Motion::Project::App.setup do |app|

  app.name = 'timeline_sample'
  app.identifier = 'com.your_domain_here.timeline_sample'
  app.short_version = '0.1.0'
  app.version = app.short_version

  app.sdk_version = '8.0'
  app.deployment_target = '7.0'
  # Or for iOS 6
  #app.sdk_version = '6.1'
  #app.deployment_target = '6.0'

  app.icons = ["icon@2x.png", "icon-29@2x.png", "icon-40@2x.png", "icon-60@2x.png", "icon-76@2x.png", "icon-512@2x.png"]

  # prerendered_icon is only needed in iOS 6
  #app.prerendered_icon = true

  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.frameworks += [
    'Accounts',
    'AudioToolbox',
    'CFNetwork',
    'CoreGraphics',
    'CoreLocation',
    'MobileCoreServices',
    'QuartzCore',
    'Security',
    'Social',
    'StoreKit',
    'SystemConfiguration']

  app.libs += [
    '/usr/lib/libz.dylib',
    '/usr/lib/libsqlite3.dylib']

  app.pods do
    pod 'SIAlertView'
    pod 'AFNetworking'
    pod 'SVProgressHUD'
    pod 'Facebook-iOS-SDK'
    pod 'Parse'
    pod 'ParseFacebookUtils'
    # pod 'Parse-iOS-SDK' http://stackoverflow.com/questions/25575606/where-is-pffacebookutils-framework-on-cocoapods-repo
    pod 'FontAwesomeKit/IonIcons'
    pod 'MONActivityIndicatorView'
    pod 'SlackTextViewController'
  end

  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false

  FB_APP_ID = '630450980402337'
  app.info_plist['FacebookAppID'] = FB_APP_ID
  app.info_plist['CFBundleURLTypes'] = [{ CFBundleURLSchemes: ["fb#{FB_APP_ID}"] }]

end
