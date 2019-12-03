source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'Capsule', '~> 0.1.1'
end

target :Utensils do
  pod 'SwiftLint', '0.37.0'

  shared_pods
end

target :Specs do
    pod 'Quick', '2.2.0'
    pod 'Nimble', '8.0.4'

    shared_pods
end
