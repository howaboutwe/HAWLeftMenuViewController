Pod::Spec.new do |s|
  s.name	= "HAWLeftMenuViewController"
  s.version	= "0.1.0"
  s.summary	= "A simple implementation of a slide-to-reveal menu view controller"
  s.description	= <<-DESC
		  A view controller that supports a slide-to-reveal pan, tap, or manually triggered
		  menu below the main view controller. Intentionally simplified from more complex
		  implementation.
		  DESC
  s.homepage	= "https://github.com/howaboutwe/HAWLeftMenuViewController"
  s.license	= { :type => 'MIT', :file => 'LICENSE' }
  s.author	= { "Jerry Wong" => "jerry@howaboutwe.com" }
  s.platform	= :ios, '7.0'
  s.source	= { :git => "https://github.com/howaboutwe/HAWLeftMenuViewController.git", :tag => "0.1.0" }
  s.source_files	= "HAWLeftMenuViewController/**/*.{h,m}"
  s.requires_arc	= true
end
