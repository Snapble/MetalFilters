Pod::Spec.new do |spec|
  spec.name         = "MetalFilters"
  spec.version      = "1.0.0"
  spec.summary      = "Instagram filters implemented in Metal "
  spec.description  = "Just a filter"
  spec.homepage     = "https://github.com/jackyoustra/MetalFilters"
  spec.license      = "MIT"
  spec.author       = { "alexiscn" => "alexiscn@email.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = "11.1"
  spec.source       = { :git => "git@github.com:jackyoustra/MetalFilters.git", :tag => spec.version }
  spec.swift_versions = '5.0'
  spec.source_files  = "MetalFilters/**/*.{swift,metal,h}"
  spec.exclude_files = "MetalFilters/ViewControllers"
  spec.resource = "MetalFilters/Supports/FilterAssets.bundle"
  spec.requires_arc = true
  spec.xcconfig = { 'MTL_HEADER_SEARCH_PATHS' => '${PODS_CONFIGURATION_BUILD_DIR}/MetalPetal/MetalPetal.framework/Headers'}

  spec.weak_frameworks = 'MetalKit'

  spec.dependency 'MetalPetal'
  spec.dependency 'MetalPetal/Swift'
end
