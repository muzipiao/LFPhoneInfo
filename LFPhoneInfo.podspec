Pod::Spec.new do |s|
  s.name             = 'LFPhoneInfo'
  s.version          = '0.1.9'
  s.summary          = 'iOS 快速获取设备信息。'
  s.description      = <<-DESC
                        LFPhoneInfo 可通过一行代码快速获取设备各种信息的工具类。
                        例如获取设备名称(e.g. iPhone X)，电池剩余电量百分比(e.g. 53%)；
                        获取局域网 IP(192.168.1.3)，网络运营商(中国移动)，检测是否使用了代理 IP；
                        获取设备是否越狱，App 更新时间等等。
                       DESC

  s.homepage         = 'https://github.com/muzipiao'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lifei' => 'lifei_zdjl@126.com' }
  s.source           = { :git => 'https://github.com/muzipiao/LFPhoneInfo.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'LFPhoneInfo/**/*'
  s.frameworks = 'UIKit', 'Foundation', 'SystemConfiguration'
  s.requires_arc = true
end
