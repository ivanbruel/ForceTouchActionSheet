ForceTouchActionSheet
===============
[![CI Status](http://img.shields.io/travis/ivanbruel/ForceTouchActionSheet.svg?style=flat)](https://travis-ci.org/ivanbruel/ForceTouchActionSheet)
[![Version](https://img.shields.io/cocoapods/v/ForceTouchActionSheet.svg?style=flat)](http://cocoapods.org/pods/ForceTouchActionSheet)
[![License](https://img.shields.io/cocoapods/l/ForceTouchActionSheet.svg?style=flat)](http://cocoapods.org/pods/ForceTouchActionSheet)
[![Platform](https://img.shields.io/cocoapods/p/ForceTouchActionSheet.svg?style=flat)](http://cocoapods.org/pods/ForceTouchActionSheet)

ForceTouchActionSheet is a UI component to replicate iOS's Springboard force touch on icons for shortcuts.

![Example](https://raw.githubusercontent.com/ivanbruel/ForceTouchActionSheet/master/Resources/forcetouch_demo.gif)

## Usage

```swift
class ViewController: UIViewController {

  @IBOutlet fileprivate weak var button: UIButton!
  fileprivate var forceTouchActionSheet: ForceTouchActionSheet?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let actions = [ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 1"),
                ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 2"),
                ForceTouchAction(icon: UIImage(named: "CameraIcon")!, title: "Action 3")]
 
    forceTouchActionSheet = ForceTouchActionSheet(view: button, actions: actions, completion: { index in
       print("clicked button \(button) \(index)")
    })
  } 
}
```

Reminder: ForceTouchActionSheet's instance needs to be saved in order to manage the views.

## Installation

ForceTouchActionSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ForceTouchActionSheet'
```

## License

ForceTouchActionSheet is available under the MIT license. See the LICENSE file for more info.
