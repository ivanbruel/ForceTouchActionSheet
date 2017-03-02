//
//  ForceTouchGestureRecognizer.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class ForceTouchGestureRecognizer: UIGestureRecognizer {

  private(set) var forceValue: CGFloat = 0

  var minimumValue: CGFloat = 0.1
  var tolerance: CGFloat = 1

  private var maxValue: CGFloat = 0

  override func reset() {
    super.reset()
    forceValue = 0
    maxValue = 0
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesBegan(touches, with: event)
    if #available(iOS 9.0, *) {
      if touches.count != 1 {
        state = .failed
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesMoved(touches, with: event)
    if #available(iOS 9.0, *) {
      guard let touch = touches.first else { return }
      let value = touch.force / touch.maximumPossibleForce

      if state == .possible {
        if value > minimumValue {
          state = .began
        }
      } else {
        if value < (maxValue - tolerance) {
          state = .ended
        } else {
          maxValue = max(forceValue, maxValue)
          forceValue = value
          state = .changed
        }
      }
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesCancelled(touches, with: event)
    if state == .began || state == .changed {
      state = .cancelled
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
    super.touchesEnded(touches, with: event)
    if state == .began || state == .changed {
      state = .ended
    }
  }
}
