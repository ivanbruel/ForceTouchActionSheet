//
//  UIImage+Snapshot.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit

extension UIView {

  var absoluteFrame: CGRect {
    return self.convert(bounds, to: nil)
  }

  func snapshot() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)

    drawHierarchy(in: bounds, afterScreenUpdates: true)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  func snapshotWindow() -> UIImage? {
    guard let layer = UIApplication.shared.keyWindow?.layer else { return nil }

    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }

    layer.render(in: context)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
