//
//  File.swift
//  
//
//  Created by 이보라 on 8/10/24.
//

import Foundation

//외부 Package 번들 가져오기
private class BundleFinder {}

extension Foundation.Bundle {
    public static var supportModule: Bundle = {
        let bundleName = "SupportKit_SupportKit"
        
        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleFinder.self).resourceURL,
            Bundle.main.bundleURL,
        ]
    
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        fatalError("unable to find bundle named BioSwift_BioSwift")
    }()
}
