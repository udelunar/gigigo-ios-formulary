//
//  FormField.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary


protocol PFormField: PTextFormField, PBooleanFormField, PIndexFormField, PickerFormFieldOutPut {
}

open class FormField: UIView {
    
    open var fieldValue: Any?
    
    //-- LOCAL VAR --
    var viewContainer: UIView!
    var formFieldOutput: PFormField?
    var validator: [Validator]?
    var keyBoard: UIKeyboardType?
    var formFieldM: FormFieldModel?
    var viewPpal: UIView?
    var heightConstraint: NSLayoutConstraint?
    
    //-- Init Xib --
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Initialize XIBS 
    
    func xibSetup(_ classField: AnyClass) {
        self.viewContainer = loadViewFromNib(classField)
        
        addSubview(self.viewContainer)
        
        self.loadConstraints()
    }
    
    func loadViewFromNib(_ classField: AnyClass) -> UIView {
        let bundle = Bundle(for: classField)
        let classString = NSStringFromClass(classField)
        let nib = UINib(nibName: classString.components(separatedBy: ".").last!, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            LogWarn("Not found a type View")
            return UIView()
        }
        return view
    }
    
    func awakeFromNib(_ frame: CGRect, classField: AnyClass) {
        super.awakeFromNib()
        self.xibSetup(classField)
    }
    
    // MARK: Private Method
    
    private func loadConstraints() {
        gig_autoresize(self.viewContainer, false)
        gig_layout_fit_horizontal(self.viewContainer)
        gig_layout_top(self.viewContainer, 0)
        gig_layout_bottom(self.viewContainer, 0)
    }
        
    // MARK: Public Method
    
    func getValidator(validatorType: AnyObject.Type) -> Validator? {
        let validatorDate = self.validator?.filter({ (validator) -> Bool in
            return validator.isKind(of: validatorType)
        })
        guard let validator = validatorDate, validator.count > 0 else {
            return nil
        }
        return validator[0]
    }
    
    func insertData() {        
        guard let hidden = self.formFieldM?.isHidden else { return }

        if hidden {
            self.viewContainer.isHidden = hidden
            self.heightConstraint = gig_constrain_height(self.viewContainer, 0)
        }
    }
    
    func launchRule(behaivour: TypeBehavior) {
        switch behaivour {
        case .disable:
            break
        case .enable:
            break
        case .hide:
            self.viewContainer.isHidden = true
            if self.heightConstraint == nil {
                self.heightConstraint = gig_constrain_height(self.viewContainer, 0)
            }
        case .show:
            self.viewContainer.isHidden = false
            if let heightConstraint = self.heightConstraint {
                self.viewContainer.removeConstraint(heightConstraint)
                self.heightConstraint = nil
            }
            UIView.animate(withDuration: 0.5) {
                self.viewContainer.layoutIfNeeded()
            }
        case .none:
            break
        }        
    }
    
    func validate() -> Bool {
        guard let validator = self.validator else { return true }
        
        var validateResult = true
        for validateRule in validator {
            if validateResult {
                validateResult = validateRule.validate(self.fieldValue)
            }
        }
        return validateResult
    }
    
    func recoverTextError(value: Any?) -> String {
        guard let validator = self.validator else { return "" }
        
        let validatorFail = validator.filter { (validator) -> Bool in
            return validator.validate(value) == false // TODO EDU aqui pilla esto "04/06/2017"
        }
        
        let orderValidators = validatorFail.sorted { (validador1, _) -> Bool in
            return validador1.isKind(of: MandatoryValidator.self)
        }
        
        if orderValidators.count > 0 {
            return orderValidators[0].textError ?? ""
        } else {
            return ""
        }
    }
    
    func loadError(error: Any) {
        // TODO nothing
    }
    
    func showCompareError(show: Bool) {
        // TODO nothing
    }
}
