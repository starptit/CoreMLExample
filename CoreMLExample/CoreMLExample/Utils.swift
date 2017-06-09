//
//  Utils.swift
//  CoreMLExample
//
//  Created by Planday Macbook on 6/9/17.
//  Copyright © 2017 Planday Macbook. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    class func resizeImage(image:UIImage, convertSize:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(convertSize, false, 0)
        let imgRect = CGRect(x: 0, y: 0, width: convertSize.width, height: convertSize.height)
        image.draw(in: imgRect)
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        return resizeImage
    }
    
    class func getPixelBuffer(fromImage image:UIImage) -> CVPixelBuffer{
        let ciImage = CIImage(image: image)
        let ciContext = CIContext(options: nil)
        let cgImage = ciContext.createCGImage(ciImage!, from: ciImage!.extent)
        
        let numPointer = UnsafeMutablePointer<UnsafeRawPointer>.allocate(capacity: 1)
        let numCreate = CFNumberCreate(kCFAllocatorDefault, .intType, numPointer)
        let keys:[CFString] = [kCVPixelBufferCGImageCompatibilityKey, kCVPixelBufferCGBitmapContextCompatibilityKey, kCVPixelBufferBytesPerRowAlignmentKey]
        let values:[CFTypeRef] = [kCFBooleanTrue, kCFBooleanTrue, numCreate!]
        let keysPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        let valuesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 1)
        keysPointer.initialize(to: keys)
        valuesPointer.initialize(to: values)
        
        let options = CFDictionaryCreate(kCFAllocatorDefault, keysPointer, valuesPointer, keys.count, nil, nil)
        let width = cgImage!.width
        let height = cgImage!.height
        
        var pxbuffer:CVPixelBuffer?
        var status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, options, &pxbuffer)
        status = CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let bufferAddress = CVPixelBufferGetBaseAddress(pxbuffer!)
        
        let rgbColor = CGColorSpaceCreateDeviceRGB()
        let bytes = CVPixelBufferGetBytesPerRow(pxbuffer!)
        let context = CGContext(data: bufferAddress,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytes,
                                space: rgbColor,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        context?.concatenate(CGAffineTransform(rotationAngle: 0))
        context?.concatenate(__CGAffineTransformMake(1, 0, 0, -1, 0, CGFloat(height)))
        
        context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)))
        status = CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pxbuffer!
        
    }
}
