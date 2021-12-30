Pod::Spec.new do |spec|

    spec.name         = "swift-algorand-sdk"
    spec.version      = "1.0.0"
    spec.summary      = "A Swift SDK to interact with Algorand blockchain"

    spec.description  = <<-DESC
  A Swift SDK that allows interaction with the Algorand blockchain. It also supports interecting with the V2 indexer and Algo Apis
                   DESC

    spec.homepage     = "https://github.com/Jesulonimi21/Swift-Algorand-Sdk"

    spec.license      = "MIT"

    spec.author             = "Akingbesote Jesulonimi"
    spec.social_media_url   = "https://github.com/Jesulonimi21"

    spec.ios.deployment_target = "10.0"
    spec.osx.deployment_target = "10.12"
    spec.watchos.deployment_target = "3.0"
    spec.tvos.deployment_target = "10.0"
    
    spec.static_framework = true
    
    spec.source = { :git => "https://github.com/Jesulonimi21/Swift-Algorand-Sdk.git", :tag => "#{spec.version}" }
    
    spec.swift_version = ["5.3"]
    
    spec.source_files = "Sources/swift-algorand-sdk/**/*.{h,c,swift}"
       
    spec.resource_bundle = { "bundle" => "Sources/swift-algorand-sdk/Resources/*"
    }
    spec.dependency "Ed25519", "~> 1.0"
    spec.dependency "Alamofire", "~> 5.2"
    spec.dependency "MessagePacker"
    spec.dependency "MessagePack-FlightSchool", "~> 1.2"
    spec.dependency "CryptoSwift", "~> 1.4"
end
