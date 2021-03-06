# BHTextField

`BHTextField` is a textfield that i have been using for several project. I would like to contribute and share.It is easy to use and friendly to storyboard. There are many features like Error Message, DropdownList, Field Validation(email, passport identification(Thailand) and birthdate).

## Versioning

swift 4.0+

## Usage

To start using the component add it to your project using CocoaPods.
The UI component can be used via the `BHTextField` class. This control can be used very similar to `UITextField` - both from Interface Builder, or from code.
</br>
</br>
![](https://github.com/tylerlantern/BHTextField/blob/master/Images/usageExample.gif)

### Properties Setup
`BHTextField` is implemented base on UIControl. Drag a view to storyboard and change class to `BHTextField`.
- `Placeholder`
- `enableTouchableOnRightIcon` enable event on tapping right icon if exist
- `enableDropdownList` if enable. user can not type anything to the field. It can be manually set text by code.
- `inputTypeAdapter` There are 6 type of them which are
     - normal
     - email
     - passport
     - birthDate
     - numeric
     - passwordNumeric

#### Right icon setup

`BHTextField` provides two options to set right icon. `rightAwesomeIcon` and `rightIcon`  can be set once at a time. Do not set them simutinously.
- `rightAwesomeIcon` set an awesomeIcon name.
- `rightIcon` it set an image.
- `rightAwesomeIconColor` set an awesomeIcon tint's color

### Colors
`BHTextfield` can set its appearance at appDelegate `didFinishLaunchingWithOptions` function
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BHTextField.appearance().textInputColor = UIColor.red
        BHTextField.appearance().placeholderColor = UIColor.brown
        return true
}
```

## License

BHTextfield is released under the MIT license. [See LICENSE](https://github.com/tylerlantern/BHTextField/blob/master/LICENSE) for details.
