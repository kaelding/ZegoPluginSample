Pod::Spec.new do |s|

  s.name                    = 'ZegoSignalingPlugin'
  s.version                 = '1.0.0'
  s.summary                 = 'ZegoSignalingPlugin'

  s.description             = 'The ZIMKit written in Swift'
  s.homepage                = 'https://www.zegocloud.com/'
  s.documentation_url       = 'https://docs.zegocloud.com/article/14859'
  s.license                 = { :type => "Copyright", :text => "Copyright @2021-2022 ZEGOCLOUD. All Rights Reserved.\n" }
  s.author                  = {"ZEGOCLOUD" => "zegocloud.com"}

  
  s.source                  = { :git => 'https://github.com/zegocloud/zimkit_swift.git',
                                :tag => s.version.to_s }
  s.cocoapods_version       = '>= 1.10.0'
  s.swift_version           = ['5.0']
  
  s.ios.deployment_target   = '12.0'
  s.source_files            = 'SignalingPlugin/**/*.swift'
  
  s.dependency 'ZIM', '~> 2.5.0'
  s.dependency 'ZPNs', '~> 2.0.1'
  s.dependency 'ZegoPluginAdapter'

end
