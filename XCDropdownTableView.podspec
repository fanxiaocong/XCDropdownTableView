Pod::Spec.new do |s|

  s.name         = "XCDropdownTableView"
  s.version      = "1.0.2"
  s.summary      = "DropdownTableView"

  s.description  = "DropdownTableView自定义下拉列表视图"

  s.homepage     = "https://github.com/fanxiaocong/XCDropdownTableView"

  s.license      = "MIT"


  s.author       = { "樊小聪" => "1016697223@qq.com" }


  s.source       = { :git => "https://github.com/fanxiaocong/XCDropdownTableView.git", :tag => s.version }


  s.source_files = "XCDropdownTableView"
  s.requires_arc = true
  s.platform     = :ios, "8.0"
  s.frameworks   =  'UIKit'

end


