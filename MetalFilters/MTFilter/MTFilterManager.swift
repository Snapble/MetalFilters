//
//  MTFilterManager.swift
//  MetalFilters
//
//  Created by xushuifeng on 2018/6/10.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import UIKit
import MetalPetal

public class MTFilterManager {

    public static var sharedContext: MTIContext? = nil

    public static let shared = MTFilterManager()

    public static let allFilters: [MTFilter.Type] = [
        MTNormalFilter.self,
        MTClarendonVideoFilter.self,
        MTGinghamVideoFilter.self,
        MTMoonVideoFilter.self,
        MTLarkFilter.self,
        MTReyesFilter.self,
        MTJunoFilter.self,
        MTSlumberFilter.self,
        MTCremaFilter.self,
        MTLudwigFilter.self,
        MTAdenFilter.self,
        MTPerpetuaFilter.self,
        MTAmaroFilter.self,
        MTMayfairFilter.self,
        MTRiseFilter.self,
        MTHudsonFilter.self,
        MTValenciaFilter.self,
        MTXpro2Filter.self,
        MTSierraFilter.self,
        MTWillowFilter.self,
        MTLoFiFilter.self,
        MTEarlybirdFilter.self,
        MTBrannanFilter.self,
        MTInkwellFilter.self,
        MTHefeFilter.self,
        MTNashvilleFilter.self,
        MTSutroFilter.self,
        MTToasterFilter.self,
        MTWaldenFilter.self,
        MT1977Filter.self,
        MTKelvinFilter.self,
        MTStinsonVideoFilter.self,
        MTVesperVideoFilter.self,
        MTMavenVideoFilter.self,
        MTGinzaVideoFilter.self,
        MTSkylineVideoFilter.self,
        MTDogpatchVideoFilter.self,
        MTBrooklynVideoFilter.self,
        MTHelenaVideoFilter.self,
        MTAshbyVideoFilter.self,
        MTCharmesVideoFilter.self
    ]

    private var resourceBundle: Bundle
    
    private var context: MTIContext?

    public init() {
        self.context = MTFilterManager.sharedContext!
        
        let bundle = Bundle(for: MTFilterManager.self)
        let url = bundle.url(forResource: "FilterAssets", withExtension: "bundle")!
        resourceBundle = Bundle(url: url)!
    }

    public func url(forResource name: String) -> URL? {
        return resourceBundle.url(forResource: name, withExtension: nil)
    }
    
    public func generateThumbnailsForImage(_ image: UIImage, with type: MTFilter.Type) -> UIImage? {
        let inputImage = MTIImage(cgImage: image.cgImage!, options: [.SRGB: false], isOpaque: true)
        let filter = type.init()
        filter.inputImage = inputImage
        if let cgImage = try? context?.makeCGImage(from: filter.outputImage!) {
            return UIImage(cgImage: cgImage)
        }
        
//        let filter = MTISaturationFilter()
//        filter.saturation = 0
//        filter.inputImage = inputImage
//
//        if let cgImage = try? context?.makeCGImage(from: filter.outputImage!) {
//            return UIImage(cgImage: cgImage)
//        }
        return nil
    }

    public func generate(image: MTIImage) -> UIImage? {
        if let cgImage = try? context?.makeCGImage(from: image) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }

    public func generateCIImage(image: MTIImage) -> CIImage? {
        if let cgImage = try? context?.makeCIImage(from: image) {
            return cgImage
        }
        return nil
    }
}
