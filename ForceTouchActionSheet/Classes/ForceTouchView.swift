//
//  ForceTouchView.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit

class ForceTouchView: UIView, UITableViewDelegate, UITableViewDataSource {

  // MARK: - Constants
  private static let maxBlurRadius: CGFloat = 8
  private static let cellHeight: CGFloat = 60
  private static let tableWidth: CGFloat = 240

  // MARK: - Inner Views
  private lazy var backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()

  private lazy var highlightView: UIView = {
    let highlightView =  UIView()
    highlightView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
    highlightView.layer.masksToBounds = true
    return highlightView
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.separatorColor = UIColor.black.withAlphaComponent(0.5)
    tableView.backgroundColor = .clear
    tableView.isScrollEnabled = false
    tableView.layer.masksToBounds = true
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    tableView.register(ForceTouchTableViewCell.self,
                       forCellReuseIdentifier: ForceTouchTableViewCell.reuseIdentifier)
    tableView.tableFooterView = UIView()
    return tableView
  }()

  // MARK: - Private Properties
  private let backgroundImage: UIImage
  private let image: UIImage
  private let imageFrame: CGRect
  private let imageCornerRadius: CGFloat
  private let actions: [ForceTouchAction]
  private let completion: (Int?) -> Void
  private let isBlurDisabled: Bool

  private var tableViewFrame: CGRect {
    let width = ForceTouchView.tableWidth
    let height = ForceTouchView.cellHeight * CGFloat(actions.count)

    let showBelow = height > imageView.frame.minY
    let showToTheRight = width > imageView.frame.minX

    var xOrigin = showToTheRight ? imageView.frame.origin.x : imageView.frame.maxX - width
    xOrigin = max(10, xOrigin)
    xOrigin = min(bounds.width - width - 10, xOrigin)
    let yOrigin = showBelow ? imageView.frame.maxY + 10 : imageView.frame.origin.y - 10 - height
    return CGRect(x: xOrigin, y: yOrigin, width: width, height: height)
  }

  // MARK: - Public Properties
  var isShowing: Bool = false

  // MARK: - Initializer
  init(backgroundImage: UIImage, image: UIImage, imageFrame: CGRect, imageCornerRadius: CGFloat,
       actions: [ForceTouchAction], isBlurDisabled: Bool, completion: @escaping (Int?) -> Void) {
    self.backgroundImage = backgroundImage
    self.image = image
    self.imageFrame = imageFrame
    self.imageCornerRadius = imageCornerRadius
    self.actions = actions
    self.isBlurDisabled = isBlurDisabled
    self.completion = completion

    super.init(frame: CGRect(origin: .zero, size: backgroundImage.size))

    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    addSubview(backgroundImageView)
    addSubview(tableView)
    addSubview(highlightView)
    addSubview(imageView)

    backgroundImageView.frame = bounds
    backgroundImageView.image = isBlurDisabled ? nil : backgroundImage
    imageView.frame = imageFrame
    imageView.image = image
    imageView.layer.cornerRadius = imageCornerRadius
    highlightView.frame = imageFrame
    highlightView.layer.cornerRadius = imageCornerRadius
    tableView.frame = imageFrame
    tableView.layer.cornerRadius = imageCornerRadius
    tableView.isHidden = true

    backgroundImageView
      .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
  }

  func show(percentage: CGFloat) {
    guard !isShowing else { return }
    if !isBlurDisabled {
      let blurRadius = percentage * ForceTouchView.maxBlurRadius
      backgroundImageView.image = backgroundImage.blur(blurRadius: blurRadius)
    }
    let scale = 1 + (percentage * 0.4)
    highlightView.transform = CGAffineTransform(scaleX: scale, y: scale)

    if percentage == 1 {
      showActions()
    }
  }

  func show() {
    UIView.animate(withDuration: 0.3) { 
      self.show(percentage: 1)
    }
  }

  func dismiss() {
    hideActions { self.completion(nil) }
  }

  private func hideActions(completion: @escaping () -> Void) {
    UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut,
                   animations: {
                    self.tableView.frame = self.imageFrame
    }) { _ in
      self.tableView.isHidden = true
      UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        self.highlightView.transform = CGAffineTransform.identity
        self.backgroundImageView.alpha = 0
        self.isShowing = false
      }) { _ in
        completion()
      }
    }
  }

  private func vibrate() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
  }

  private func showActions() {
    vibrate()
    highlightView.isHidden = true
    tableView.isHidden = false
    isShowing = true


    UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut,
                   animations: {
                    self.tableView.frame = self.tableViewFrame
    }, completion: nil)
  }



  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return actions.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView
      .dequeueReusableCell(withIdentifier: ForceTouchTableViewCell.reuseIdentifier)
      as? ForceTouchTableViewCell else {
        return UITableViewCell()
    }
    let action = actions[indexPath.row]
    cell.title = action.title
    cell.icon = action.icon
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      self.hideActions { self.completion(indexPath.row) }
    }

  }

  func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
  }
}
