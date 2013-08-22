# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'
require 'rubygems'
require 'motion-cocoapods'
require 'afmotion'
require 'bubble-wrap'

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
  app.frameworks << "QuartzCore"

  app.pods do
    pod 'AFNetworking', '1.3.2'
  end
end