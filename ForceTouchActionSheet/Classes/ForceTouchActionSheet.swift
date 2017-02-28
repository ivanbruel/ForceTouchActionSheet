//
//  ForceTouchActionSheet.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit

public class ForceTouchActionSheet: NSObject {

  private let view: UIView
  private let completion: (Int?) -> Void
  private let actions: [ForceTouchAction]
  private var forceTouchView: ForceTouchView? = nil

  public init(view: UIView, actions: [ForceTouchAction], completion: @escaping (Int?) -> Void) {
    self.view = view
    self.completion = completion
    self.actions = actions

    super.init()
    
    view.addGestureRecognizer(
      ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchRecognized(_:))))
  }

  func forceTouchRecognized(_ gestureRecognizer: ForceTouchGestureRecognizer) {
    let force = gestureRecognizer.forceValue
    if forceTouchView == nil && gestureRecognizer.state == .began {
      prepare()
    } else if gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended {
      if let forceTouchView = forceTouchView, !forceTouchView.isShowing {
        destroy()
      }
    }
    forceTouchView?.show(percentage: force)
  }

  private func prepare() {
    guard let windowImage = view.snapshotWindow(), let image = view.snapshot() else {
      print("Could not snapshot window or view")
      return
    }
    let cornerRadius = view.layer.cornerRadius
    let frame = view.absoluteFrame
    let forceTouchView = ForceTouchView(backgroundImage: windowImage, image: image,
                                        imageFrame: frame, imageCornerRadius: cornerRadius,
                                        actions: actions, completion: { index in
                                          self.completion(index)
                                          self.destroy()
    })
    guard let window = UIApplication.shared.keyWindow else {
      print("Could not find key window")
      return
    }

    window.addSubview(forceTouchView)
    self.forceTouchView = forceTouchView
  }

  private func destroy() {
    forceTouchView?.removeFromSuperview()
    forceTouchView = nil
  }
}
