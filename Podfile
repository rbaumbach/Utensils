source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target :Utensils do
  pod 'Capsule', '~> 1.3.4'

  pod 'SwiftLint', '0.54.0'
end

def shared_spec_pods
  pod 'Capsule', '~> 1.3.4'

  pod 'Quick', '5.0.1'
  pod 'Moocher', '0.4.0'
end

target :Specs do
  shared_spec_pods
end

target :IntegrationSpecs do
  shared_spec_pods
end
