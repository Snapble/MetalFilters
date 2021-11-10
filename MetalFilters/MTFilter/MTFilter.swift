//
//  MTFilter.swift
//  MetalFilters
//
//  Created by xu.shuifeng on 2018/6/7.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import Foundation
import MetalPetal

public class MTFilter: NSObject, MTIUnaryFilter {
    
    public required override init() { }
    
    // MARK: - Should overrided by subclasses
    public class var name: String { return "" }
    
    /// border image Name
    public var borderName: String { return "" }

    /// fragment shader name in Metal
    public var fragmentName: String { return "" }

    /// Textures, key should match parameter name
    public var samplers: [String: String] { return [:] }

    public var parameters: [String: Any] { return [:] }
    
    /// Strength to adjust filter, ranges in [0.0, 1.0]
    /// if value is 0.0, means no filter effect
    /// if values is 1.0, means full filter effect
    public var strength: Float = 1.0
    
    /// override this function to modifiy samplers if needed
    ///
    /// - Returns: final samplers passes into Metal
    public func modifySamplersIfNeeded(_ samplers: [MTIImage]) -> [MTIImage] {
        return samplers
    }

    // MARK: - MTIUnaryFilter

    public var inputImage: MTIImage?
    
    public var outputPixelFormat: MTLPixelFormat = .invalid
    
    public var outputImage: MTIImage? {
        guard let input = inputImage else {
            return inputImage
        }
        
        var images: [MTIImage] = []
        for key in samplers.keys.sorted() {
            let imageName = samplers[key]!
            if imageName.count > 0 {
                let image = samplerImage(named: imageName)!
                images.append(image)
            }
        }
        images = modifySamplersIfNeeded(images)
        images.insert(input, at: 0)
        
        let outputDescriptors = [
            MTIRenderPassOutputDescriptor(dimensions: MTITextureDimensions(cgSize: input.size), pixelFormat: outputPixelFormat)
        ]
        
        var params = parameters
        if params["strength"] == nil {
            params["strength"] = strength
        }
        return kernel.apply(toInputImages: images, parameters: params, outputDescriptors: outputDescriptors).first
    }

    public var kernel: MTIRenderPipelineKernel {
        let vertexDescriptor = MTIFunctionDescriptor(name: MTIFilterPassthroughVertexFunctionName)
        let fragmentDescriptor = MTIFunctionDescriptor(name: fragmentName, libraryURL: MTIDefaultLibraryURLForBundle(Bundle(for: MTFilter.self)))
        let kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: vertexDescriptor, fragmentFunctionDescriptor: fragmentDescriptor)
        return kernel
    }

    public func samplerImage(named name: String) -> MTIImage? {
        if let imageUrl = MTFilterManager.shared.url(forResource: name) {
            if name.hasSuffix(".pvr") {
                let loader = MTKTextureLoader(device: MTFilterManager.sharedContext!.device)
                do {
                    let texture = try loader.newTexture(URL: imageUrl, options: [
                        MTKTextureLoader.Option.SRGB: false
                    ])
                    return MTIImage(texture: texture, alphaType: .alphaIsOne)
                } catch {
                    print(error)
                }
            } else {
                let ciImage = CIImage(contentsOf: imageUrl)
                return MTIImage(ciImage: ciImage!, isOpaque: true)
            }
        }
        return nil
    }

    public var borderImage: MTIImage? {
        return samplerImage(named: borderName)
    }
}
