# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'HOFFER' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HOFFER
	
    pod 'TweeTextField'                     # For Animated Text Field
    pod 'SpinKit'                           # For Loader
    pod 'TweeTextField'                     # For Animated Text Field
    pod 'AFNetworking'

    pod 'MSWeakTimer'
    pod 'CocoaMQTT'
    pod 'SDWebImage'
    pod 'SVProgressHUD'
    pod 'Kingfisher'
    pod 'IQKeyboardManagerSwift'
    pod 'Toast-Swift', '~> 5.0.1'
   

  #target 'HOFFERTests' do
   # inherit! :search_paths
    # Pods for testing
  #end

  #target 'HOFFERUITests' do
   # inherit! :search_paths
    # Pods for testing
  #end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        xcconfig_path = config.base_configuration_reference.real_path
        xcconfig = File.read(xcconfig_path)
        xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
        File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end
