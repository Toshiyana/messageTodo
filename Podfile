platform :ios, '9.0'

target 'messageTodo' do
  use_frameworks!

  # Pods for messageTodo
  pod 'RealmSwift'
  pod 'SwipeCellKit'
  pod 'CropViewController'
  pod 'Google-Mobile-Ads-SDK'
  pod 'FirebaseAnalytics'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end

  target 'messageTodoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'messageTodoUITests' do
    # Pods for testing
  end

end
