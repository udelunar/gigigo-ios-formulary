//
//  TextFormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary
private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}



protocol PTextFormField {
    func scrollRectToVisible(_ field: FormField)
    func formFieldDidFinish(_ field: FormField)
}


class TextFormField: TextCellInterface, UITextFieldDelegate {
    
    
    // MARK: INIT
    
    override init(cell: FormFieldStyleModel?) {
        super.init(cell: cell)
        self.awakeFromNib(classField: type(of: self))
        self.initializeView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.awakeFromNib(frame, classField: type(of: self))
        self.initializeView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: VALIDATE
    
    override func validate(extraValues: Any?) -> Bool {
        let status = super.validate(extraValues: extraValues)
        if !status {
            self.showError()
        } else {
            self.hideError()
        }
        
        return status
    }
    
    // MARK: Public Method
    
    override func insertData() {
        self.loadData(self.formFieldM!)
        self.loadMandatory(self.formFieldM!.isMandatory())
        self.loadCustomStyleField(self.formFieldM!)
        self.loadKeyboard(self.formFieldM!)
        self.loadCustomField(self.formFieldM!)
        super.insertData()
    }
    
    override func loadError(error: Any) {
        guard let text = error as? String else { return }
        self.errorLabel.text = text
        self.showError()
    }
    
    // MARK: GIGFormField (Override)
    
    override public var fieldValue: Any? {
        get {            
            return self.textTextField.text?.count > 0 ? self.textTextField.text : nil
        }
        set {
            self.textTextField.text = "\(newValue!)"
        }
    }
    
    override func launchRule(behaivour: TypeBehavior) {        
        super.launchRule(behaivour: behaivour)
        switch behaivour {
        case .disable:
            self.textTextField.isEnabled = false
        case .enable:
            self.textTextField.isEnabled = true
        case .hide, .show, .none:
            break
        }
    }
    
    func showError() {
        self.errorLabel.text = self.recoverTextError(value: self.fieldValue)
        UIView.animate(withDuration: 0.5, animations: {
            self.errorLabel.sizeToFit()
            self.heightErrorLabelConstraint.constant =  self.errorLabel.frame.height
            self.viewPpal?.layoutIfNeeded()
        })
    }
    
    // MARK: Private Method
    
    fileprivate func hideError() {
        UIView.animate(withDuration: 0.5, animations: {
            self.heightErrorLabelConstraint.constant = 0
            self.viewPpal?.layoutIfNeeded()
        }) 
    }
    
    fileprivate func initializeView() {
        self.titleLabel.numberOfLines = 0
        self.errorLabel.numberOfLines = 0
        self.mandotoryImage.image = UIImage(named: "mandatoryIcon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        self.textTextField.delegate = self
    }
    
    // MARK: Load data field
    
    fileprivate func loadCustomField(_ formFieldM: FormFieldModel) {
        self.textTextField.isSecureTextEntry = formFieldM.isPassword
    }
    
    fileprivate func loadData(_ formFieldM: FormFieldModel) {
        self.titleLabel.text = formFieldM.label
        self.textTextField.placeholder = formFieldM.placeHolder
        self.errorLabel.text = self.recoverTextError(value: self.fieldValue)
        if self.formFieldM?.value != nil {
            self.textTextField.text = self.formFieldM?.value as? String
        }
        if self.formFieldM?.label == nil {
            self.heightLabelConstraint.constant = 0
        }
        self.textTextField.isEnabled = formFieldM.isEditing
    }
    
    fileprivate func loadMandatory(_ isMandatory: Bool) {
        if isMandatory {
            self.widthMandatoryImageConstraint.constant = 30
        } else {
            self.widthMandatoryImageConstraint.constant = 0
        }
    }
    
    fileprivate func loadKeyboard(_ formFieldM: FormFieldModel) {
        self.textTextField.keyboardType = self.keyBoard!
    }
    
    fileprivate func loadCustomStyleField(_ formFieldM: FormFieldModel) {
        let styleField = formFieldM.style
        if styleField != nil {
            if styleField!.mandatoryIcon != nil {
                self.mandotoryImage.image = styleField?.mandatoryIcon
            }
            if styleField!.backgroundColorField != nil {
                self.viewContainer.backgroundColor = styleField!.backgroundColorField!
            }
            if styleField!.titleColor != nil {
                self.titleLabel.textColor = styleField!.titleColor!
            }
            if styleField!.errorColor != nil {
                self.errorLabel.textColor = styleField!.errorColor!
            }
            if styleField!.fontTitle != nil {
                self.titleLabel.font = styleField?.fontTitle
                self.textTextField.font = styleField?.fontTitle
            }
            if styleField!.fontError != nil {
                self.errorLabel.font = styleField?.fontError
            }
            if styleField!.align != nil {
                self.titleLabel.textAlignment = styleField!.align!
            }
            if let styleCell = styleField?.styleCell {
                switch styleCell {
                case .defaultStyle, .custom:
                    // TODO nothing
                    break
                case .lineStyle:
                    self.customizeCell()                    
                }
            }
        }
    }
    
    fileprivate func customizeCell() {
        self.textTextField.borderStyle = UITextBorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.textTextField.frame.size.height - width, width: UIScreen.main.bounds.width, height: self.textTextField.frame.size.height)
        
        border.borderWidth = width
        self.textTextField.layer.addSublayer(border)
        self.textTextField.layer.masksToBounds = true
    }
    
    // MARK: UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.formFieldOutput!.scrollRectToVisible(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.formFieldOutput?.formFieldDidFinish(self)
        return false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = textField.text as NSString? ?? ""
        let finalString = textFieldText.replacingCharacters(in: range, with: string)    
        let lengthValidator = LengthValidator(
            minLength: self.formFieldM!.getValidator(validatorType: TypeValidator.validatorLength)?.minLengthValue,
            maxLength: self.formFieldM!.getValidator(validatorType: TypeValidator.validatorLength)?.maxLengthValue
        )
        
        if textFieldText.length == 1 && finalString.count == 0 {
            return true
        } else {
            return lengthValidator.controlCharacters(finalString)
        }  
    }
    
    // MARK: UIResponser (Overrride)
    public override var canBecomeFirstResponder: Bool {
        return self.textTextField.canBecomeFirstResponder
    }
    
    public override func becomeFirstResponder() -> Bool {
        return self.textTextField.becomeFirstResponder()
    }
    
    public override func resignFirstResponder() -> Bool {
        return self.textTextField.resignFirstResponder()
    }
}
