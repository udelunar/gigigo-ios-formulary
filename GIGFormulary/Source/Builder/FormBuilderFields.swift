//
//  FormBuilder.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 28/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class FormBuilderFields: NSObject {
    
    //-- Controller --
    var formController: FormController
        
    //-- Types --
    var listTypeFields = [TypeField: FormField.Type]()
    var keyboardTypes = [TypeKeyBoard: UIKeyboardType]()
    var validatorsType = [TypeValidator: Validator.Type]()

    
    init(formController: FormController) {
        self.formController = formController
        
        super.init()
        
        self.initializeTypes()
    }
    
    // MARK: Private Method
    
    fileprivate func initializeTypes() {
        self.listTypeFields = [.TEXT_FORM_FIELD: TextFormField.self,
                               .PICKER_FORM_FIELD: PickerFormField.self,
                               .DATEPICKER_FORM_FIELD: PickerFormField.self,
                               .BOOLEAN_FORM_FIELD: BooleanFormField.self]
        
        self.keyboardTypes  = [.KEYBOARD_TEXT: .default,
                              .KEYBOARD_EMAIL: .emailAddress,
                              .KEYBOARD_NUMBER: .numbersAndPunctuation,
                              .KEYBOARD_NUMBERPAD: .numberPad]

        self.validatorsType = [.VALIDATOR_TEXT: StringValidator.self,
                               .VALIDATOR_EMAIL: MailValidator.self,
                               .VALIDATOR_LENGTH: LengthValidator.self,
                               .VALIDATOR_NUMERIC: NumericValidator.self,
                               .VALIDATOR_POSTALCODE: PostalCodeValidator.self,
                               .VALIDATOR_PHONE: PhoneValidator.self,
                               .VALIDATOR_BOOL: BoolValidator.self,
                               .VALIDATOR_DNINIE: DNINIEValidator.self,
                               .VALIDATOR_AGE: AgeValidator.self]
    }
    
    fileprivate func createField(_ fieldDic: [String:AnyObject]) -> FormField {
        do {
            let formFieldM = FormFieldModel()
            try formFieldM.parseDictionary(fieldDic)
            
            let typeField = self.listTypeFields[TypeField(rawValue: formFieldM.type!)!]
            let field = typeField!.init()
            field.formFieldM = formFieldM
            field.delegate = self.formController
            field.validator = self.validatorToField(formFieldM)
            field.keyBoard = self.keyboardToField(formFieldM)
            field.insertData()
            return field
        }
        catch {
            let field = FormField()
            return field
        }
    }
    
    fileprivate func validatorToField(_ formFieldM: FormFieldModel) -> Validator?{
        if (formFieldM.validator != nil) {
            let typeValidator = self.validatorsType[TypeValidator(rawValue: formFieldM.validator!)!]
            let validator = typeValidator!.init(mandatory: formFieldM.mandatory)
            validator.minLength = formFieldM.minLengthValue
            validator.maxLength = formFieldM.maxLengthValue
            validator.minAge = formFieldM.minAge
            return validator
        }
        else {
            return Validator(mandatory: formFieldM.mandatory)
        }
    }
    
    fileprivate func keyboardToField(_ formFieldM: FormFieldModel) -> UIKeyboardType?{
        if (formFieldM.keyBoard != nil) {
            return self.keyboardTypes[TypeKeyBoard(rawValue: formFieldM.keyBoard!)!]
        }
        else {
            return UIKeyboardType.default
        }
    }
    
    // MARK: Public Method
    
    func fieldsFromJSONFile(_ file: String) -> [FormField] {
        var listFormField = [FormField]()
        let jsonRecover = Bundle.main.loadJSONFile(file, rootNode: "fields")
        if (jsonRecover != nil) {
            let listFormDic = jsonRecover as! [[String: AnyObject]]
            for fieldDic in listFormDic {
                listFormField.append(self.createField(fieldDic))
            }
        }
        else {
            print("❌❌❌ json fields Not Found")
        }
        
        return listFormField
    }
}
