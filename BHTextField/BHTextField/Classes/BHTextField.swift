//
//  BHTextField.swift
//  TLT
//
//  Created by Nattapong Unaregul on 7/2/18.
//  Copyright © 2018 Toyata. All rights reserved.

import UIKit

@objc protocol BHTextFieldDelegate : class {
    func textFieldShouldReturn( sender : BHTextField  , textField : UITextField) -> Bool
    @objc optional func didTapRightIcon( sender : BHTextField )
    @objc optional func didTapForDropdownlistMode( sender : BHTextField )
    @objc optional func textDidChange(sender : BHTextField)
}
@IBDesignable
open class BHTextField: UIControl {
    @objc public dynamic var textInputColor: UIColor? = UIColor(red: 99/255, green: 99/255, blue: 99/255, alpha: 1.0) {
        didSet {
            self.txt_input.textColor = textInputColor
        }
    }
    @objc public dynamic var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            setUpPlaceHolder()
        }
    }
    var valueForDropdownList : String?
    weak var delegate : BHTextFieldDelegate?
    @IBInspectable
    var placeHolder : String? {
        didSet{
            #if TARGET_INTERFACE_BUILDER
            setUpPlaceHolder()
            #endif
        }
    }
    @IBInspectable
    var text : String?{
        get{
            return self.txt_input.text
        }set{
            if inputType == .birthDate , let newText = newValue{
                inputDate =  dateFormatter.date(from: newText)
            }
            self.txt_input.text = newValue
        }
    }
    @IBInspectable
    var enableTouchableOnRightIcon : Bool = false {
        didSet{
            if enableTouchableOnRightIcon {
                lb_rightAwesomeIcon.isUserInteractionEnabled = true
                lb_rightAwesomeIcon.addGestureRecognizer(tapGestureRecognizerOnRightIcon)
            }else {
                lb_rightAwesomeIcon.isUserInteractionEnabled = false
                lb_rightAwesomeIcon.removeGestureRecognizer(tapGestureRecognizerOnRightIcon)
            }
        }
    }
    @IBInspectable
    var enableDropdownList : Bool = false {
        didSet{
            shallCreateDropdownlistFeature(isEnable : enableDropdownList)
        }
    }
    func shallCreateDropdownlistFeature(isEnable : Bool)  {
        self.txt_input.isUserInteractionEnabled = !isEnable
        if isEnable {
            tapGestureForDropdownlist = UITapGestureRecognizer(target: self, action: #selector(self.didTapGestureForDropdownList(sender:)))
            self.addGestureRecognizer(tapGestureForDropdownlist!)
        }else{
            guard let tapGestureForDropdownlist = tapGestureForDropdownlist else {return }
            self.removeGestureRecognizer(tapGestureForDropdownlist)
        }
    }
    var tapGestureForDropdownlist : UITapGestureRecognizer?
    @objc func didTapGestureForDropdownList(sender: UITapGestureRecognizer){
        delegate?.didTapForDropdownlistMode?(sender: self)
    }
    @objc public dynamic var textInputFont : UIFont? = nil {
        didSet{
            txt_input.font = textInputFont
        }
    }
    @IBInspectable
    @objc public dynamic var fontName : String?  {
        didSet{
            setFont(fontName: fontName, fontSize: fontSize)
        }
    }
    @IBInspectable
    @objc public dynamic var fontSize : CGFloat = 20 {
        didSet{
            setFont(fontName: fontName, fontSize: fontSize)
        }
    }
    @objc public dynamic var fontAwesomeName : String?  {
        didSet{
            guard let fontAwesomeName = fontAwesomeName else {
                lb_rightAwesomeIcon.font = UIFont.systemFont(ofSize: 18)
                return
            }
            lb_rightAwesomeIcon.font = UIFont(name: fontAwesomeName, size: 18)
        }
    }
    override open func becomeFirstResponder() -> Bool {
        return self.txt_input.becomeFirstResponder()
    }
    func setFont(fontName name : String? ,fontSize size : CGFloat)  {
        guard let name = name , let font =  UIFont(name: name, size: size) else {
            txt_input.font = UIFont.systemFont(ofSize: size)
            return
        }
        txt_input.font = font
    }
    enum InputType:Int {
        case normal = 0
        case email = 1
        case passport = 2
        case birthDate = 3
        case numberic = 4
        case passwordNumberic = 5
        //        case pinPassword = 6
    }
    var isEmpty : Bool {
        return (txt_input.text == "" || txt_input.text == nil) ? true : false
    }
    @IBInspectable
    var inputTypeAdapter:Int {
        get {
            return self.inputType.rawValue
        }
        set{
            self.inputType = InputType(rawValue: newValue) ?? .normal
        }
    }
    var inputType : InputType = .normal {
        didSet{
            self.txt_input.isSecureTextEntry = (inputType == .passwordNumberic ) ? true : false
            if inputType == .birthDate {
                self.txt_input.inputView = datePicker
            }else if inputType == .passport {
                setUpToolBar()
                self.txt_input.keyboardType = .decimalPad
            }else if inputType == .passwordNumberic  || inputType == .numberic {
                setUpToolBar()
                self.txt_input.keyboardType = .decimalPad
            }else if inputType == .normal {
                self.txt_input.keyboardType  = .default
            }else if inputType == .email {
                self.txt_input.keyboardType  = .emailAddress
            }
        }
    }
    var isSecureTextEntry : Bool{
        get{
            return self.txt_input.isSecureTextEntry
        }
        set{
            self.txt_input.isSecureTextEntry = newValue
        }
    }
    func togglePasswordDisplay(shallBeShown : Bool){
        self.txt_input.isSecureTextEntry = shallBeShown
        let temp = self.txt_input.text
        txt_input.text = ""
        txt_input.text = temp
    }
    var inputDate : Date?
    func setUpToolBar(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(BHTextField.cancel(sender:)))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(BHTextField.done(sender:)))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: .normal)
        
        // ToolBar
        toolBar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txt_input.inputAccessoryView = toolBar
    }
    @objc func cancel(sender : UIBarButtonItem){
        txt_input.resignFirstResponder()
    }
    @objc func done(sender : UIBarButtonItem) {
        if inputType == .birthDate {
            let formatedDateInStr = dateFormatter.string(from: datePicker.date)
            inputDate = datePicker.date
            self.txt_input.text = formatedDateInStr
            if !isValidDate {
                self.showError()
            }else {
                self.hideError()
            }
            txt_input.resignFirstResponder()
        }else if inputType == .passport{
            if !isValidPassport {
                self.showError()
            }else {
                self.hideError()
            }
            txt_input.resignFirstResponder()
        }
    }
    func resign() {
        self.txt_input.resignFirstResponder()
    }
    lazy var datePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        
        var minComponents = DateComponents()
        minComponents.year = 1950
        minComponents.day = 1
        minComponents.month = 1
        let minDate = Calendar.current.date(from: minComponents)
        
        let currentDate = Date()
        var maxComponents = DateComponents()
        maxComponents.year = Calendar.current.component(.year, from: currentDate) - 10
        maxComponents.day = 31
        maxComponents.month = 12
        let maxDate = Calendar.current.date(from: maxComponents)
        dp.minimumDate = minDate
        dp.maximumDate = maxDate
        
        dp.addTarget(self, action: #selector(BHTextField.datePickerChanged(sender:)) , for: UIControlEvents.valueChanged)
        setUpToolBar()
        return dp
    }()
    fileprivate var dateFormatter : DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        df.locale = Locale(identifier: "en")
        return df
    }()
    @objc func datePickerChanged( sender : UIDatePicker) {
        let formatedDateInStr = dateFormatter.string(from: datePicker.date)
        inputDate = datePicker.date
        self.txt_input.text = formatedDateInStr
    }
    @IBInspectable
    var errorMessage : String = "error" {
        didSet{
            self.lb_error.text = errorMessage
        }
    }
    @IBInspectable
    var leftIcon : UIImage? {
        didSet{
            if let leftIcon = leftIcon {
                imv_leftIcon.image = leftIcon
                stackViewHorizontal.insertArrangedSubview(imv_leftIcon, at: 0 )
                setUpIconConstraint(imv: imv_leftIcon)
            }else {
                stackViewHorizontal.removeArrangedSubview(imv_leftIcon)
                imv_leftIcon.image = nil
            }
        }
    }
    @IBInspectable
    var rightAwesomeIcon : String? {
        didSet{
            if let rightAwesomeIcon = rightAwesomeIcon , rightAwesomeIcon != ""{
                lb_rightAwesomeIcon.text = rightAwesomeIcon
                if lb_rightAwesomeIcon.superview == nil {
                    stackViewHorizontal.addArrangedSubview(lb_rightAwesomeIcon)
                    
                }
            }else {
                if lb_rightAwesomeIcon.superview != nil {
                    stackViewHorizontal.removeArrangedSubview(lb_rightAwesomeIcon)
                    
                }
            }
        }
    }
    @IBInspectable
    var rightIcon : UIImage? {
        didSet{
            if let rightIcon = rightIcon {
                imv_rightIcon.image = rightIcon
                stackViewHorizontal.addArrangedSubview(imv_rightIcon)
                setUpIconConstraint(imv: imv_rightIcon, ratioMultiplier: 0.4)
            }else {
                stackViewHorizontal.removeArrangedSubview(imv_rightIcon)
                imv_rightIcon.image = nil
            }
        }
    }
    @IBInspectable
    var rightAwesomeIconColor : UIColor = UIColor.black {
        didSet{
            lb_rightAwesomeIcon.textColor = rightAwesomeIconColor
        }
    }
    let defaultBottomLineColor : UIColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let highlightBottomLineColor : UIColor = UIColor.red
    
    func setUpIconConstraint(imv : UIImageView , ratioMultiplier : CGFloat = 0.65) {
        imv.heightAnchor.constraint(equalTo: stackViewHorizontal.heightAnchor, multiplier: ratioMultiplier).isActive = true
        imv.widthAnchor.constraint(equalTo: imv.heightAnchor, multiplier: 1.0).isActive = true
    }
    lazy var stackViewHorizontal : UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .center
        s.distribution = .fill
        s.axis = .horizontal
        s.spacing = 10
        return s
    }()
    lazy var lb_error : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = UIColor.red
        return lb
    }()
    lazy var lb_rightAwesomeIcon : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var stackViewVertical : UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alignment = .fill
        s.distribution = .fill
        s.axis = .vertical
        s.spacing = 4
        return s
    }()
    lazy var imv_leftIcon : UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    lazy var imv_rightIcon : UIImageView = {
        let imv = UIImageView()
        imv.translatesAutoresizingMaskIntoConstraints = false
        imv.contentMode = .scaleAspectFit
        //        imv.backgroundColor = UIColor.cyan
        return imv
    }()
    lazy var containerHorizontalStackView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var txt_input : UITextField = {
        let txt = UITextField()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.borderStyle = .none
        txt.textAlignment = .left
        txt.clearButtonMode = .whileEditing
        txt.delegate = self
        return txt
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitilization()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitilization()
    }
    func sharedInitilization(){
        self.lb_error.isHidden = true
        self.addSubview(stackViewVertical)
        stackViewVertical.addArrangedSubview(containerHorizontalStackView)
        stackViewVertical.addArrangedSubview(lb_error)
        containerHorizontalStackView.addSubview(stackViewHorizontal)
        stackViewHorizontal.addArrangedSubview(txt_input)
        setUpConstraint()
        setUpGesture()
        
        setFont(fontName: self.fontName, fontSize: self.fontSize)
    }
    fileprivate let defaultFont = UIFont.systemFont(ofSize:  20)
    func setUpPlaceHolder(){
        var font : UIFont = defaultFont
        if let fontName = self.fontName , fontName != "" {
            font = UIFont(name: fontName, size: self.fontSize) ?? defaultFont
        }
        txt_input.attributedPlaceholder = NSAttributedString(string: self.placeHolder ?? ""
            , attributes: [NSAttributedStringKey.foregroundColor :  self.placeholderColor
                ,NSAttributedStringKey.font :font
            ])
    }
    func setUpGesture(){
        txt_input.addTarget(self, action: #selector(self.textDidChange(sender:)) , for: .editingChanged)
    }
    @objc func textDidChange(sender : UITextField){
        delegate?.textDidChange?(sender: self)
        if sender.text == "" || sender.text == nil{
            shallAnimateBottomPath(shouldShow: false)
        }
    }
    fileprivate var haslayoutSubviews : Bool = false
    fileprivate let heightConstant : CGFloat = 35.0
    lazy var bottomLineLayer = CAShapeLayer()
    lazy var staticBottomLineLayer = CAShapeLayer()
    lazy var bottomLinePath  = UIBezierPath()
    override open func layoutSubviews() {
        super.layoutSubviews()
        if !haslayoutSubviews {
            haslayoutSubviews = true
            
            bottomLinePath.move(to: CGPoint(x: 0, y: self.bounds.height))
            bottomLinePath.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
            
            staticBottomLineLayer.path = bottomLinePath.cgPath
            staticBottomLineLayer.strokeColor = defaultBottomLineColor.cgColor
            staticBottomLineLayer.borderWidth = 1.0
            
            bottomLineLayer.path = bottomLinePath.cgPath
            bottomLineLayer.strokeColor = highlightBottomLineColor.cgColor
            bottomLineLayer.strokeEnd = 0.0
            bottomLineLayer.borderWidth = 1.0
            self.layer.addSublayer(staticBottomLineLayer)
            self.layer.addSublayer(bottomLineLayer)
        }
    }
    func setUpConstraint(){
        containerHorizontalStackView.heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        stackViewVertical.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackViewVertical.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackViewVertical.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackViewVertical.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        
        stackViewHorizontal.topAnchor.constraint(equalTo: self.containerHorizontalStackView.topAnchor ).isActive = true
        stackViewHorizontal.rightAnchor.constraint(equalTo: self.containerHorizontalStackView.rightAnchor).isActive = true
        stackViewHorizontal.bottomAnchor.constraint(equalTo: self.containerHorizontalStackView.bottomAnchor).isActive = true
        stackViewHorizontal.leftAnchor.constraint(equalTo: self.containerHorizontalStackView.leftAnchor).isActive = true
        txt_input.heightAnchor.constraint(equalTo: stackViewHorizontal.heightAnchor, multiplier: 1.0).isActive = true
    }
    func showError(){
        shallAnimateBottomPath(shouldShow: true)
    }
    func hideError(){
        shallAnimateBottomPath(shouldShow: false)
    }
    fileprivate func shallAnimateBottomPath(shouldShow : Bool) {
        if !hasAlreadyHighlightBottomColor && !shouldShow {
            return
        }
        else if hasAlreadyHighlightBottomColor && shouldShow {
            return
        }
        self.lb_error.alpha = shouldShow ? 0 : 1
        UIView.animate(withDuration: 0.33, animations: {
            self.lb_error.isHidden = !shouldShow
        }) { (isDone) in
            self.lb_error.alpha = !shouldShow ? 0 : 1
        }
        self.hasAlreadyHighlightBottomColor = shouldShow
        animateBottomPath(shouldShow: shouldShow)
    }
    fileprivate  func animateBottomPath(shouldShow : Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        strokeAnimation.duration = 0.33
        strokeAnimation.fromValue = shouldShow == true ? 0 : 1.0
        strokeAnimation.toValue = shouldShow == true ? 1.0 : 0.0
        bottomLineLayer.add(strokeAnimation, forKey: "strokeEnd")
        //        let fillColorAnimation = CABasicAnimation(keyPath: "strokeColor")
        //        fillColorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //        fillColorAnimation.duration = 0.33
        //        fillColorAnimation.fromValue = shouldShow == true ? defaultBottomLineColor.cgColor : highlightBottomLineColor.cgColor
        //        fillColorAnimation.toValue = shouldShow == true ? highlightBottomLineColor.cgColor : defaultBottomLineColor.cgColor
        //        bottomLineLayer.add(fillColorAnimation, forKey: "strokeColor")
        CATransaction.setCompletionBlock {
            self.bottomLineLayer.strokeEnd = shouldShow == true ? 1.0 : 0.0
            self.bottomLineLayer.strokeColor = shouldShow == true ? self.highlightBottomLineColor.cgColor : self.defaultBottomLineColor.cgColor
        }
        CATransaction.commit()
    }
    
    fileprivate var hasAlreadyHighlightBottomColor : Bool = false
    lazy var tapGestureRecognizerOnRightIcon = UITapGestureRecognizer(target: self, action: #selector(self.didTapRightIcon(sender:)))
    @objc func didTapRightIcon(sender : UITapGestureRecognizer){
        delegate?.didTapRightIcon?(sender: self)
    }
}
extension BHTextField {
    func validEmail(text : String?) -> Bool {
        guard text != nil && text != "" else {
            return false
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: text)
    }
    var isValidEmail : Bool {
        get{
            return validEmail(text: self.text)
        }
    }
    var isValidPassport : Bool {
        guard text != nil && text != "" else {
            return true
        }
        let passportRegEx = "[0-9]{1} - [0-9]{4} - [0-9]{5} - [0-9]{2} - [0-9]{1}"
        let passportPredicate = NSPredicate(format:"SELF MATCHES %@", passportRegEx)
        return passportPredicate.evaluate(with: text)
    }
    var passportText : String? {
        guard  let text = self.text , inputType == .passport else {return nil}
        
        return text.replacingOccurrences(of: " - ", with: "")
    }
    func validDate(text : String?, dateFormat : String) -> Bool {
        guard let textNotNil = text , textNotNil != "" else {
            return true
        }
        return dateFormatter.date(from: textNotNil) != nil
    }
    var isValidDate : Bool {
        get{
            return validDate(text: self.text, dateFormat: dateFormatter.dateFormat)
        }
    }
    var isValidNumber: Bool {
        guard text != nil && text != "" else {
            return true
        }
        
        return text!.range(of: "[^0-9]", options: .regularExpression) == nil && !isEmpty
    }
    
}
extension BHTextField : UITextFieldDelegate{
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if inputType == .normal {
            shallAnimateBottomPath(shouldShow: false)
        } else if inputType == .email {
            let isValid = validEmail(text: textField.text)
            shallAnimateBottomPath(shouldShow: !isValid)
        } else if inputType == .birthDate {
            let isValid = validDate(text: textField.text, dateFormat: dateFormatter.dateFormat)
            shallAnimateBottomPath(shouldShow: !isValid)
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if inputType == .normal {
            shallAnimateBottomPath(shouldShow: false)
        } else if inputType == .email {
            let isValid = validEmail(text: textField.text)
            shallAnimateBottomPath(shouldShow: !isValid)
        } else if inputType == .birthDate {
            let isValid = validDate(text: textField.text, dateFormat: dateFormatter.dateFormat)
            shallAnimateBottomPath(shouldShow: !isValid)
        }
        return delegate?.textFieldShouldReturn(sender: self, textField: textField) ?? true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if inputType == .passport {
            if range.location >= 25{
                return false;
            }
            if((range.location == 1 || range.location == 8 || range.location == 16 || range.location == 21) && range.length == 0){
                textField.text = String(format: "%@ - ", arguments: [textField.text ?? ""])
            }else if((range.location == 4 || range.location == 11 || range.location == 19 || range.location == 24)  && range.length == 1){
                let text = textField.text  ?? ""
                let targetIndex = text.index(text.endIndex, offsetBy: -3)
                textField.text =  String(text[..<targetIndex])
            }
        }
        return true
    }
}
