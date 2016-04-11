#
# Be sure to run `pod lib lint Onboarding.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = "Onboarding"
  s.version          = "0.1.0"
  s.summary          = "An easy multipage onboarding UI controller."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "A few pages of onboarding is near ubiquitous in today's iOS apps, but UIPageViewController is honestly an overly complex way to accomplish this, often with layout problems for things like a skip button. This library attempts to make it easier to do."

  s.homepage         = "https://github.com/voidref/Onboarding"
  # s.screenshots     = 
  s.license          = 'MIT'
  s.author           = { "Alan Westbrook" => "alan@rockwoodsoftware.com" }
  s.source           = { :git => "https://github.com/voidref/Onboarding.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'OnboardingLibrary/Sources/**/*'
  s.resource_bundles = {
    'Onboarding' => []
  }

  # s.public_header_files = '**/*.h'
  s.frameworks = 'UIKit'
end
