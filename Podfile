
target 'Teremok-TV' do

platform:ios, '10.0'
use_frameworks!
inhibit_all_warnings!

pod 'Alamofire'
pod 'AlamofireImage'
pod 'SwiftyJSON'
pod 'ObjectMapper'

pod 'Reveal-SDK', :configurations => ['Debug']

pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
pod 'IQKeyboardManagerSwift', '~> 6.0'
pod 'InfiniteScrolling'
pod 'lottie-ios' #animation
pod 'M13Checkbox'

pod 'Firebase/Core'# analytics
pod 'Fabric'
pod 'Crashlytics'

pod 'SwiftyStoreKit'

pod 'SQLite.swift' # datastorage
pod 'KeychainAccess' # save sensitive data to Keychain

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
            config.build_settings['CLANG_ENABLE_OBJC_WEAK'] ||= 'YES'
        end
    end
end

end
