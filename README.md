# swift-menu-controller
Simple menu with smooth animation

## Usage

(work in progress), please let me time to improve the integration's steps :)

```swift
let storyboard = UIStoryboard(name: "Main", bundle: nil)
let swipe = storyboard.instantiateViewController(withIdentifier: "swipe") as! SwipeZoomMenuViewController
let menu = storyboard.instantiateViewController(withIdentifier: "menu") as! MenuViewController
let content = storyboard.instantiateViewController(withIdentifier: "content") as! ContentViewController

swipe.setContentController(vc: content)
swipe.setMenuController(vc: menu)
```

## Result
![alt text](./readme/menu.gif)

## Thanks
Special thanks to [Jackie Tran](https://dribbble.com/shots/1310536-Menu-screen) for it mobile inspiration design.
