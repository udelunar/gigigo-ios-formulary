//
//  TextFormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary


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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: VALIDATE
    
    override func validate(extraValues: Any?) -> Bool {
        let status = super.validate(extraValues: extraValues)
        if !status {
            self.errorLabel.text = self.recoverTextError(value: self.fieldValue)
            self.showError()
        } else {
            self.hideError()
        }
        
        return status
    }
    
    // MARK: Public Method
    
    override func insertData() {
        self.loadData(self.formFieldM)
        self.loadMandatory(self.formFieldM?.isMandatory())
        self.loadCustomStyleField(self.formFieldM)
        self.loadKeyboard()
        self.loadCustomField(self.formFieldM)
        super.insertData()
    }
    
    override func loadError(error: Any) {
        guard let text = error as? String else { return }
        self.errorLabel.text = text
        self.showError()
    }
    
    // MARK: GIGFormField (Override)
    
    override var fieldValue: Any? {
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
        if self.heightErrorLabelConstraint.constant == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.errorLabel.sizeToFit()
                self.heightErrorLabelConstraint.constant =  self.errorLabel.frame.height
                self.viewPpal?.layoutIfNeeded()
            })
        }
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
    
    fileprivate func loadCustomField(_ formFieldM: FormFieldModel?) {
        guard let isPassword = formFieldM?.isPassword else { return }
        self.textTextField.isSecureTextEntry = isPassword
    }
    
    fileprivate func loadData(_ formFieldM: FormFieldModel?) {
        self.titleLabel.text = formFieldM?.label
        self.textTextField.placeholder = formFieldM?.placeHolder
        self.errorLabel.text = self.recoverTextError(value: self.fieldValue)
        if self.formFieldM?.value != nil {
            self.textTextField.text = self.formFieldM?.value as? String
        }
        if self.formFieldM?.label == nil {
            self.heightLabelConstraint.constant = 0
        }
        
        guard let isEditing = formFieldM?.isEditing else { return }
        self.textTextField.isEnabled = isEditing
    }
    
    fileprivate func loadMandatory(_ isMandatory: Bool?) {
        guard let isMandatory = isMandatory else { return LogInfo("Mandatory is nil") }
        if isMandatory {
            self.widthMandatoryImageConstraint.constant = 30
        } else {
            self.widthMandatoryImageConstraint.constant = 0
        }
    }
    
    fileprivate func loadKeyboard() {
        guard let keyBoard = keyBoard else { return }
        self.textTextField.keyboardType = keyBoard
    }
    
    fileprivate func loadCustomStyleField(_ formFieldM: FormFieldModel?) {
        guard let styleField = formFieldM?.style else { return LogInfo("Field Model is nil") }
   
        if let mandatoryIcon = styleField.mandatoryIcon {
            self.mandotoryImage.image = mandatoryIcon
        }
        if let backgroundColorField = styleField.backgroundColorField {
            self.viewContainer.backgroundColor = backgroundColorField
        }
        if let titleColor = styleField.titleColor {
            self.titleLabel.textColor = titleColor
        }
        if let errorColor = styleField.errorColor {
            self.errorLabel.textColor = errorColor
        }
        if let fontTitle = styleField.fontTitle {
            self.titleLabel.font = fontTitle
            self.textTextField.font = fontTitle
        }
        if let fontError = styleField.fontError {
            self.errorLabel.font = fontError
        }
        if let align = styleField.align {
            self.titleLabel.textAlignment = align
        }
        if let styleCell = styleField.styleCell {
            switch styleCell {
            case .defaultStyle, .custom:
                // TODO nothing
                break
            case .lineStyle:
                self.customizeCell()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let formFieldOutput = self.formFieldOutput else { return }
        formFieldOutput.scrollRectToVisible(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.formFieldOutput?.formFieldDidFinish(self)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
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
    override var canBecomeFirstResponder: Bool {
        return self.textTextField.canBecomeFirstResponder
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textTextField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return self.textTextField.resignFirstResponder()
    }
}

// Comparations

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
