![MSActionSheet: Logo](http://i.imgur.com/UkbNlEj.png)

![CocoaPods MSActionSheet](http://i.imgur.com/ys0rzRs.png)
![MSActionSheet Version](http://i.imgur.com/1LmYVqf.png)
![MSActionSheet Platform](http://i.imgur.com/S79aHIK.png)

Customized ActionSheet for taking photo from library / front / rear camera

![MSActionSheet: screenshot](https://raw.githubusercontent.com/MaorS/MSActionSheet/master/Example/media/screenshots.png)



## Installation

### Manually

Drag and drop MSActionSheet.swift and Assets into your project

![MSActionSheet: installation](https://raw.githubusercontent.com/MaorS/MSActionSheet/master/Example/media/install.gif)


## Usage - long way

### Creating new ActionSheet

```swift
let sheet = MSActionSheet.instance
sheet.create().addLibrary().addRearCamera().addFrontCamera().addCancelButton().show(on: self)
```

### Handler when user finish picking, get selected Image:

```swift
.show(on: self) { (image) in
// Your code here
}
```



## Usage - Short way
### Creating new ActionSheet, when user finish picking get image

```swift
MSActionSheet.instance.showFullActionSheet(on: self){ (image) in
// Your code here
}
```

## Customizing
#### Adding custom titles and images
You can set custom title or message or both

```swift
sheet.create(title: "Select Image", message: "Another text..")
```
You can mix between action options
```swift
.addFrontCamera(title: "Take a selfie", destructive: true, image: #imageLiteral(resourceName: "selfie"))
```

#### Adding custom tint color to ActionSheet
```swift
.tintColor(color: .red)
```


### Privacy permissions
Please make sure to enable in Info.plist

```Privacy - Photo Library Usage Description```
```Privacy - Camera Usage Description```
![MSActionSheet: Customized ActionSheet for taking photo from library / front / rear camera](http://i.imgur.com/oAeYJwy.png)

### Short tutorial

![MSActionSheet: Customized ActionSheet for taking photo from library / front / rear camera](https://github.com/MaorS/MSActionSheet/blob/master/Example/media/fullActionSheet.gif?raw=true)
