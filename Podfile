# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'JChat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'YHPopupView'
  pod 'YHPhotoKit'
  pod 'MJRefresh', '~> 3.1.12'
  pod 'FMDB', '~> 2.6.2'
  pod 'BaiduMapKit', '~> 3.3.2'
  pod 'JMessage', '~> 3.3.0’
  pod 'RxSwift', '~> 4.2'
  pod 'RxCocoa', '~> 4.2'

  # Pods for JChat

  target 'JChatTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'JChatUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
