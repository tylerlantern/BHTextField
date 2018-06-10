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
- `enableDropdownList` if enable. user can not type anything to the field. It can be mannaully set text by code.
- `inputTypeAdapter` There are 6 type of them which are
     - normal
     - email
     - passport
     - birthDate
     - numberic
     - passwordNumberic

#### Right icon setup
`BHTextField` provides two options to set right icon. They can be set once at a time. Do not set them togather.
- `rightAwesomeIcon` awesome icon's name
- `rightIcon` it set an image to the UIImageView.
- `rightAwesomeIconColor`


### Colors
Implementing


## License

BHTextfield is released under the MIT license. [See LICENSE](https://github.com/tylerlantern/BHTextField/blob/master/LICENSE) for details.
