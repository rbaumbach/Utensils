source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Capsule', '1.6.0'
end

target :Utensils do
  platform :ios, '12.0'
  shared_pods

  pod 'SwiftLint', '0.54.0'
end

def shared_spec_pods
  shared_pods

  pod 'Quick', '7.3.0'
  pod 'Moocher', '0.4.1'
end

target :Specs do
  platform :ios, '15.0'
  shared_spec_pods
end

target :IntegrationSpecs do
  platform :ios, '15.0'
  shared_spec_pods

  pod 'Moocher/Polling', '0.4.1'
end
