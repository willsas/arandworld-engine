Pod::Spec.new do |s|

s.name         = "ArandworldEngine"
s.version      = "0.1.0"
s.summary      = "Arandworld ios engine module"

s.homepage     = "https://github.com/willsas"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

s.license      = "MIT"

s.author       = { "willasaskara@gmail.com" => "willasaskara@gmail.com" }

s.platform     = :ios, "13.0"

s.source       = { :path => "." }

s.source_files  = "ArandworldEngine", "arandworld-engine/**/*.{h,m,swift,xib}"

s.resources = "arandworld-engine/**/*.{xcassets, ttf}"
s.resource_bundles = {
    'ArandworldEngine' => ['arandworld-engine/**/*.{lproj,xib,xcassets,imageset,png,ttf,storyboard}']
}

s.framework        = 'UIKit', 'AVFoundation'
s.requires_arc    = false

s.dependency 'Amplify'
s.dependency 'AmplifyPlugins/AWSS3StoragePlugin'
s.dependency 'AmplifyPlugins/AWSCognitoAuthPlugin'

end
