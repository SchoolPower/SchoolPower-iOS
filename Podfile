target "SchoolPower" do
    
    source "https://github.com/CocoaPods/Specs.git"
    platform :ios, "8.0"
    use_frameworks!
    
    pod "MaterialComponents"
    pod "Material"
    pod "SwiftyJSON"
    pod "Charts"
    pod "Google-Mobile-Ads-SDK"
    pod "ActionSheetPicker-3.0"
    pod "VTAcknowledgementsViewController"
    pod "MKRingProgressView"
    pod "CustomIOSAlertView"
    pod "SACountingLabel"
    pod "DGElasticPullToRefresh"
    pod "IQKeyboardManagerSwift"
    pod "XLPagerTabStrip"
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
    
end
