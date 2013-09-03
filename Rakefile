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

  # Frameworks
  frameworks = %w(
    QuartzCore
    Security
  )
  frameworks.each { |framework| app.frameworks << framework }

  # Keychain
  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # Custom fonts
  app.fonts = ['FontAwesome.otf', 'roboto/Roboto-Medium.ttf', 'roboto/Roboto-Light.ttf', 'roboto/Roboto-Bold.ttf']

  # CocoaPods
  app.pods do
    pod 'AFNetworking', '1.3.2'
    pod 'SSKeychain'
    pod 'ViewDeck', '2.2.11'
    pod 'MBProgressHUD'
    pod 'FontAwesomeIconFactory'
    pod 'FlatUIKit'
  end
end