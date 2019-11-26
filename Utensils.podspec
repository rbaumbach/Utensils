Pod::Spec.new do |spec|
  spec.name                  = 'Utensils'
  spec.version               = '0.0.1'
  spec.summary               = 'A bunch of useful tools in the iOS toolbox.'
  spec.homepage              = 'https://github.com/rbaumbach/utensils'
  spec.license               = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
  spec.author                = { 'Ryan Baumbach' => 'github@ryan.codes' }
  spec.source                = { :git => 'https://github.com/rbaumbach/utensils.git', :tag => spec.version.to_s }
  spec.requires_arc          = true
  spec.platform              = :ios
  spec.ios.deployment_target = '10.0'
  spec.source_files          = 'Utensils/Source/**/*.{swift}'
  spec.swift_version         = '5.1.2'
end
