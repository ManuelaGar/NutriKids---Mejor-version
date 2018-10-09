# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'NutriKids' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NutriKids

pod 'ChameleonFramework'
pod 'Firebase'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Core'
pod 'Firebase/Storage'
pod 'SVProgressHUD'
pod 'IGRPhotoTweaks', '~> 1.0.0'
pod 'HorizontalDial'
pod 'SwiftyJSON'
pod 'Alamofire'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
