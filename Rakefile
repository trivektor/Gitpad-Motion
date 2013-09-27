# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
require 'rubygems'
require 'motion-cocoapods'
require 'afmotion'
require 'bubble-wrap'
require 'motion-i18n'
require 'formotion'
require 'teacup'
require 'sugarcube'

Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Gitpad-Motion'
  app.identifier = 'com.gitpadmotion.'
  app.device_family = [:ipad]
  app.interface_orientations = [:landscape_left, :landscape_right]
  app.sdk_version = '6.1'
  app.provisioning_profile = ENV['MOTION_PROVISIONING_PROFILE']
  app.codesign_certificate = ENV['MOTION_CODESIGN_CERTIFICATE']
  app.detect_dependencies = false

  # Icons
  app.icons = [
    'icon.png',
    'icon@2x.png'
  ]

  app.prerendered_icon = true

  # Frameworks
  frameworks = %w(
    QuartzCore
    Security
    CoreAnimation
  )
  frameworks.each { |framework| app.frameworks << framework }

  # Keychain
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # Custom fonts
  app.fonts = [
    'FontAwesome.otf',
    'roboto/Roboto-Medium.ttf',
    'roboto/Roboto-Light.ttf',
    'roboto/Roboto-Bold.ttf',
    'roboto/Roboto-Regular.ttf'
  ]

  # CocoaPods
  app.pods do
    pod 'AFNetworking', '1.3.2'
    pod 'SSKeychain'
    pod 'ViewDeck', '2.2.11'
    pod 'MBProgressHUD'
    pod 'FontAwesomeIconFactory'
    pod 'FlatUIKit'
    pod 'TDSemiModal'
    pod 'iOS7Colors', '~> 2.0.0'
    pod 'NSData+Base64'
    pod 'MMMarkdown'
    pod 'XYPieChart'
  end

  app.vendor_project('vendor/IBActionSheet', :static, :cflags => '-fobjc-arc')
  app.vendor_project('vendor/RelativeDateDescriptor', :static, :cflags => '-fobjc-arc')
end