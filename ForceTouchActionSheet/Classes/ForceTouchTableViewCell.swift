//
//  ForceTouchTableViewCell.swift
//  3DTouchActionSheet
//
//  Created by Ivan Bruel on 27/02/2017.
//  Copyright © 2017 Unbabel. All rights reserved.
//

import UIKit

class ForceTouchTableViewCell: UITableViewCell {

  // MARK: - Constants
  static let reuseIdentifier: String = "ForceTouchTableViewCell"

  // MARK: - Inner Views
  private lazy var highlightBlurView: UIVisualEffectView = {
    return UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
  }()

  private lazy var iconImageView: UIImageView = {
    let iconImageView = UIImageView()
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.tintColor = .black
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    return iconImageView
  }()

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightMedium)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.setContentHuggingPriority(UILayoutPriorityDefaultLow, for: .horizontal)
    return label
  }()

  var title: String? {
    get {
      return label.text
    }
    set {
      label.text = newValue
    }
  }

  var icon: UIImage? {
    get {
      return iconImageView.image
    }
    set {
      iconImageView.image = newValue?.withRenderingMode(.alwaysTemplate)
    }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }

  private func commonInit() {
    separatorInset = .zero
    preservesSuperviewLayoutMargins = false
    layoutMargins = .zero
    backgroundColor = UIColor.white.withAlphaComponent(0.35)

    addSubview(iconImageView)
    addSubview(label)

    let views: [String : Any] = ["iconImageView": iconImageView, "label": label]
    let visualFormat = "H:|-20-[iconImageView(30)]-20-[label]"
    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                               options: [],
                                                               metrics: nil, views: views))

    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[iconImageView]-16-|",
                                                               options: [],
                                                               metrics: nil, views: views))

    NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label]-10-|",
                                                               options: [],
                                                               metrics: nil, views: views))

  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    backgroundView = highlighted ? highlightBlurView : nil
  }
}
