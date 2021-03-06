//
//  FormFieldModel.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 29/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit
import GIGLibrary

class FormFieldModel: NSObject {
    
    var bundle: Bundle
    
    //-- Mandatory --
    var key: String?
    var type: String?
    var label: String?
    
    //-- Optional --    
    var placeHolder: String?
    var keyboard: String?
    var options: [FormFieldOptionsModel]?
    var style: FormFieldStyleModel?
    var validator: [FormFieldsValidator]?
    var keyBoard: String?
    var textAcceptButton: String?
    var value: Any?
    var isPassword = false
    var isEditing = true
    var isHidden = false
    var expandableInfo: ExpandableInfo?
    var rules: FormFieldRules?
        
    //-- Links --
    var isLink = false
    var subtype: String?
    var fieldDescription: String?
    
    init(bundle: Bundle) {
        self.bundle = bundle
        super.init()
    }
    
    // MARK: Public Method
    
    func isMandatory() -> Bool {
        let validatorMandatory = self.validator?.filter({ (validator) -> Bool in
            return validator.type == TypeValidator.validatorMandatory.rawValue
        })
        
        if let validator = validatorMandatory, validator.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func getValidator(validatorType: TypeValidator) -> FormFieldsValidator? {
        let validatorDate = self.validator?.filter({ (validator) -> Bool in
            return validator.type == validatorType.rawValue
        })
        guard let validator = validatorDate, validator.count > 0 else {
            return nil
        }
        return validator[0]
    }
    
    func parseDictionary(_ json: [AnyHashable: Any]) throws {
        //== PREPARE DATA ==
        
        //-- Mandatory --
        guard let type = json["type"] as? String, type.count > 0 else {
            LogWarn("type Not Found")
            throw ThrowError.mandatoryElementNotFound
        }

        guard let key = json["key"] as? String, key.count > 0 else {
            LogWarn("key Not Found")
            throw ThrowError.mandatoryElementNotFound
        }
    
        
        //== INSERT DATA ==
        //-- Mandatory--
        self.type = type
        self.key = key
        
        //-- Optional--
        
        if let label = json["label"] as? String {
            self.label = NSLocalizedString(label, comment: "")
        }
        if let placeHolder = json["placeHolder"] as? String {
            self.placeHolder = NSLocalizedString(placeHolder, comment: "")
        }
        
        self.subtype = json["subtype"] as? String
        
        if let expandable = json["expandableInfo"] as? [AnyHashable: String],
            let expandText = expandable["textButtonReadMore"],
            let collapseText = expandable["textButtonReadLess"],
            let description = expandable["description"] {
                self.expandableInfo = ExpandableInfo(
                                          collapseText: collapseText,
                                            expandText: expandText)
                
                self.fieldDescription = description
        }
 
        if json["listOptions"] != nil {
            guard let listOptions = json["listOptions"] as? [[AnyHashable: Any]] else {
                LogWarn(" listOptions incorrect type")
                throw ThrowError.mandatoryElementIncorrectType
            }
            if listOptions.count == 0 {
                LogWarn("listOptions empty")
                throw ThrowError.mandatoryElementEmpty
            }
            do {
                self.options = try FormFieldOptionsModel.parseListOptionsJson(listOptions)
            } catch {
                LogWarn("options Not Found")
                throw ThrowError.mandatoryElementNotFound
            }
        }
        if let styleM = json["style"] as? [AnyHashable: Any] {
            self.style = FormFieldStyleModel(bundle: self.bundle)
            self.style?.parseDictionary(styleM)
        }
        
        // Validator
        
        if let validator = json["validator"] as? [[AnyHashable: Any]] {
            do {
                self.validator = try FormFieldsValidator.parseListValidatorJson(validator)
            } catch {
                LogWarn("validator Not Found")
                throw ThrowError.mandatoryElementNotFound
            }
        }
        
        // Other component
        
        if let keyBoard = json["keyboard"] as? String {
            self.keyBoard = keyBoard
        }
        if let textAccept  = json["textAcceptButton"] as? String {
            self.textAcceptButton = NSLocalizedString(textAccept, tableName: nil, bundle: self.bundle, value: "", comment: "")
        } else {
            self.textAcceptButton = NSLocalizedString("gig_form_accept_button_picker", tableName: nil, bundle: Bundle(for: Swift.type(of: self)), value: "", comment: "gig_form_accept_button_picker")
        }
        if let value = json["value"] {
            self.value = value
        }
        if let isPassword = json["isPassword"] as? Bool {
            self.isPassword = isPassword
        }
        if let isLink = json["isLink"] as? Bool {
            self.isLink = isLink
        }
        if let isEditing = json["isEditing"] as? Bool {
            self.isEditing = isEditing
        }
        if let isHidden = json["isHidden"] as? Bool {
            self.isHidden = isHidden
        }
        if json["rules"] != nil {
            guard let rules = json["rules"] as? [AnyHashable: Any] else {
                LogWarn(" rules incorrect type")
                throw ThrowError.mandatoryElementIncorrectType
            }
            if rules.count == 0 {
                LogWarn("rules empty")
                throw ThrowError.mandatoryElementEmpty
            }

            self.rules = FormFieldRules.parseDictionary(rules)
        }
    }
}
