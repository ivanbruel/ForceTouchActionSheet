//
//  ForceTouchActionSheet.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit

public class ForceTouchActionSheet: NSObject {

  public var completion: ((Int?) -> Void)?
  public var actions: [ForceTouchAction]
  public var isBlurDisabled: Bool

  private let view: UIView
  private var forceTouchView: ForceTouchView? = nil

  public init(view: UIView, actions: [ForceTouchAction], isBlurDisabled: Bool = false, completion: @escaping (Int?) -> Void) {
    self.view = view
    self.completion = completion
    self.actions = actions
    self.isBlurDisabled = isBlurDisabled

    super.init()

    setup()

  }

  private func setup() {
    if view.traitCollection.forceTouchCapability == .available {
      setupForceTouch()
    } else {
      setupLongPress()
    }
  }

  private func setupForceTouch() {
    let gesture = ForceTouchGestureRecognizer(target: self, action: #selector(forceTouchRecognized(_:)))
    gesture.cancelsTouchesInView = false
    gesture.minimumValue = 0.2
    view.addGestureRecognizer(gesture)
  }

  private func setupLongPress() {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(_:)))
    gesture.cancelsTouchesInView = false
    view.addGestureRecognizer(gesture)
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

  func longPressRecognized(_ gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == .began {
      prepare()
      forceTouchView?.show()
    }
  }

  private func prepare() {
    guard actions.count > 0 else {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)
      return
    }
    guard let windowImage = view.snapshotWindow(), let image = view.snapshot() else {
      print("Could not snapshot window or view")
      return
    }
    let cornerRadius = view.layer.cornerRadius
    let frame = view.absoluteFrame
    let forceTouchView = ForceTouchView(backgroundImage: windowImage, image: image,
                                        imageFrame: frame, imageCornerRadius: cornerRadius,
                                        actions: actions, isBlurDisabled: isBlurDisabled, completion: { index in
                                          self.completion?(index)
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
