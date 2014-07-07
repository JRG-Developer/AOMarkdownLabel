Pod::Spec.new do |s|
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.name         = "AOMarkdownLabel"
  s.version      = "0.0.1"
  s.summary      = "AOMarkdown is a drop-in replacement for UILabel that supports simple Github flavored markdown, link embedding, and dynamic type text."
  s.homepage     = "https://github.com/JRG-Developer/AOMarkdownLabel.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Joshua Greene" => "josh@app-order.com" }
  s.source   	   = { :git => "https://github.com/JRG-Developer/AOMarkdownLabel.git",
                     :tag => "#{s.version}"}
  s.requires_arc = true
  
  ss.framework = "UIKit"
  s.source_files = "AOMarkdownLabel/*.{h,m}"
end