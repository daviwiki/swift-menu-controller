# SwipeMenu

![](https://img.shields.io/badge/version-1.0.0-blue.svg)

## What you will see ...
<img src="./readme/menu.gif" width="300"/>

## Requirements

iOs 10

## Installation and Usage

SwipeMenu is available through [Github](https://github.com/daviwiki/swift-menu-controller). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwipeMenu", :git => "https://github.com/daviwiki/swift-menu-controller", :branch => "feature/pod"
```

Once SwipeMenu are installed into your app you can start and use it. In the following example we suppose that you have a storyboard (called *Main*) with three controllers:

    - a SwipeZoomMenuViewController (imported by the pod)
    - a ContentViewController (for your own)
    - a MenuViewController (for your own too)

with these ones include the following code in your AppDelegate

```swift

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let swipe = storyboard.instantiateViewController(withIdentifier: "swipe") as! SwipeZoomMenuViewController
    let menu = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
    let content = storyboard.instantiateViewController(withIdentifier: "content") as! ContentViewController
    swipe.setContentController(vc: content)
    swipe.setMenuController(vc: menu)

    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = UIColor.blue
    window?.makeKeyAndVisible()
    window?.rootViewController = swipe

    return true
}

```

## Example

To run the example project, clone [the repo](https://github.com/daviwiki/swift-menu-controller/tree/feature/pod), and run `pod install` from the Example directory first. Follow the next steps:

1. Open a console
2. git clone https://github.com/daviwiki/swift-menu-controller/tree/feature/pod
3. cd swift-menu-controller/SwipeMenu/Example
4. pod install

## Thanks
Special thanks to [Jackie Tran](https://dribbble.com/shots/1310536-Menu-screen) for it mobile inspiration design.

## Author

David Martinez
[GitHub](https://github.com/daviwiki)
[Linked-In](https://www.linkedin.com/in/david-martinez-garc%C3%ADa-b4187148/)

## License

SwipeMenu is available under the MIT license. See the LICENSE file for more info.

## Notes

Please include all the comments, issues, tips, that you want :)
