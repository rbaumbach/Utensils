source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Capsule', '1.4.0'
end

target :Utensils do
  shared_pods

  pod 'SwiftLint', '0.54.0'
end

def shared_spec_pods
  shared_pods

  pod 'Quick', '5.0.1'
  pod 'Moocher', '0.4.0'
end

target :Specs do
  shared_spec_pods
end

target :IntegrationSpecs do
  shared_spec_pods

  pod 'Moocher/Polling', '0.4.0'
end
