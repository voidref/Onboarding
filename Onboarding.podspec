# Be sure to run `pod lib lint Onboarding.podspec'

Pod::Spec.new do |s|
  s.name             = "Onboarding"
  s.version          = "0.1.2"
  s.summary          = "An easy multipage onboarding UI controller."

  s.description      = "Starting with a few pages of onboarding is near ubiquitous in today's iOS apps, but UIPageViewController is honestly an overly complex way to accomplish this, often with layout problems for things like a skip button. This library attempts to make it easier to do."

  s.homepage         = "https://github.com/voidref/Onboarding"
  # s.screenshots     = 
  s.license          = 'MIT'
  s.author           = { "voidref" => "voidref@gmail.com" }
  s.source           = { :git => "https://github.com/voidref/Onboarding.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Sources/**/*'
  s.resource_bundles = {
    'Onboarding' => []
  }

  s.frameworks = 'UIKit'
end
