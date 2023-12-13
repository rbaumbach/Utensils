Pod::Spec.new do |spec|
  spec.name                  = 'Utensils'
  spec.version               = '0.2.0'
  spec.summary               = 'A set of useful iOS tools.'
  spec.homepage              = 'https://github.com/rbaumbach/utensils'
  spec.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  spec.author                = { 'Ryan Baumbach' => 'github@ryan.codes' }
  spec.source                = { :git => 'https://github.com/rbaumbach/Utensils.git', :tag => spec.version.to_s }
  spec.requires_arc          = true
  spec.platform              = :ios
  spec.ios.deployment_target = '12.0'
  spec.source_files          = 'Sources/Utensils/**/*.{swift}'
  spec.swift_version         = '5.1.2'

  spec.dependency 'Capsule', '~> 1.3.2'
end
