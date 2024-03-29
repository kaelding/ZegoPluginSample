Pod::Spec.new do |s|

  s.name                    = 'ZIMKit'
  s.version                 = '1.2.0'
  s.summary                 = 'ZIMKit'

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
  s.source_files            = 'ZIMKit/**/*.swift'
  
  s.resource_bundles        = {
    'ZIMKitResources' => ['ZIMKit/Resources/**/*']
  }
  
  s.dependency 'ZegoSignalingPlugin'
  s.dependency 'Kingfisher', '7.4.1'

end
