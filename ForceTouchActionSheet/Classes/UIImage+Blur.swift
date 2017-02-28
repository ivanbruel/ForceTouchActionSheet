//
//  UIImage+Blur.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit
import Accelerate

// Based on https://github.com/globchastyy/SwiftUIImageEffects/blob/master/Source/UIImageEffects.swift
extension UIImage {


  public func blur(blurRadius: CGFloat) -> UIImage {
    // Check pre-conditions.
    if (size.width < 1 || size.height < 1) {
      print("*** error: invalid size: \(size.width) x \(size.height). Both dimensions must be >= 1: \(self)")
      return self
    }
    guard let cgImage = self.cgImage else {
      print("*** error: image must be backed by a CGImage: \(self)")
      return self
    }

    let __FLT_EPSILON__ = CGFloat(FLT_EPSILON)
    let screenScale = UIScreen.main.scale
    let imageRect = CGRect(origin: CGPoint.zero, size: size)
    var effectImage = self

    let hasBlur = blurRadius > __FLT_EPSILON__

    if hasBlur {
      func createEffectBuffer(_ context: CGContext) -> vImage_Buffer {
        let data = context.data
        let width = vImagePixelCount(context.width)
        let height = vImagePixelCount(context.height)
        let rowBytes = context.bytesPerRow

        return vImage_Buffer(data: data, height: height, width: width, rowBytes: rowBytes)
      }

      UIGraphicsBeginImageContextWithOptions(size, false, screenScale)
      guard let effectInContext = UIGraphicsGetCurrentContext() else { return self }

      effectInContext.scaleBy(x: 1.0, y: -1.0)
      effectInContext.translateBy(x: 0, y: -size.height)
      effectInContext.draw(cgImage, in: imageRect)

      var effectInBuffer = createEffectBuffer(effectInContext)

      UIGraphicsBeginImageContextWithOptions(size, false, screenScale)

      guard let effectOutContext = UIGraphicsGetCurrentContext() else { return self }
      var effectOutBuffer = createEffectBuffer(effectOutContext)


      if hasBlur {
        // A description of how to compute the box kernel width from the Gaussian
        // radius (aka standard deviation) appears in the SVG spec:
        // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
        //
        // For larger values of 's' (s >= 2.0), an approximation can be used: Three
        // successive box-blurs build a piece-wise quadratic convolution kernel, which
        // approximates the Gaussian kernel to within roughly 3%.
        //
        // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
        //
        // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
        //
        let inputRadius = blurRadius * screenScale
        let d = floor(inputRadius * 3.0 * CGFloat(sqrt(2 * M_PI) / 4 + 0.5))
        var radius = UInt32(d)
        if radius % 2 != 1 {
          radius += 1 // force radius to be odd so that the three box-blur methodology works.
        }

        let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)

        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
      }

        effectImage = UIGraphicsGetImageFromCurrentImageContext()!


      UIGraphicsEndImageContext()

      UIGraphicsEndImageContext()
    }

    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(size, false, screenScale)

    guard let outputContext = UIGraphicsGetCurrentContext() else { return self }

    outputContext.scaleBy(x: 1.0, y: -1.0)
    outputContext.translateBy(x: 0, y: -size.height)

    // Draw base image.
    outputContext.draw(cgImage, in: imageRect)

    // Draw effect image.
    if hasBlur {
      outputContext.saveGState()
      outputContext.draw(effectImage.cgImage!, in: imageRect)
      outputContext.restoreGState()
    }

    // Output image is ready.
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return outputImage ?? self
  }
}
