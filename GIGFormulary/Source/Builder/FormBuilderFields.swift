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

    
    init(formController: FormController) {
        self.formController = formController
        
        super.init()
        
        self.initializeTypes()
    }
    
    // MARK: Private Method
    
    private func initializeTypes() {
        self.listTypeFields = [.TEXT_FORM_FIELD: TextFormField.self,
                               .PICKER_FORM_FIELD: PickerFormField.self]
    }
    
    private func createField(fieldDic: [String:AnyObject], tag: Int) -> FormField {
        do {
            let formFieldM = FormFieldModel()
            try formFieldM.parseDictionary(fieldDic)
            
            let typeField = self.listTypeFields[TypeField(rawValue: formFieldM.type!)!]
            let field = typeField!.init()
            field.delegate = self.formController
            field.insertData(formFieldM)
            field.tag = tag
            return field
        }
        catch {
            let field = FormField()
            return field
        }
    }
    
    // MARK: Public Method
    
    func fieldsFromJSONFile(file: String) -> [FormField] {
        let listFormDic = NSBundle.mainBundle().loadJSONFile(file, rootNode: "fields") as! [[String: AnyObject]]
        var listFormField = [FormField]()
        var tag = 0
        for fieldDic in listFormDic {
            listFormField.append(self.createField(fieldDic, tag: tag))
            tag += 1
        }
        
        return listFormField
    }
}
