//
//  FormFieldModel.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 29/6/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class FormFieldModel: NSObject {
    
    //-- Mandatory --
    var tag: String?
    var label: String?
    var textError: String?
    
    //-- Optional --    
    var placeHolder: String?
    var maxLength: String?
    var mandatory = false
    var keyboard: String?
    var options: [FormFieldOptionsModel]?
    var style: [FormFieldStyleModel]?
       
    // MARK: Public Method
    
    func parseDictionary(json: [String:AnyObject]) throws {
        //== PREPARE DATA ==
        //-- Mandatory --
        guard let tag = json["tag"] as? String else {
            print("❌❌❌ tag Not Found")
            throw ThrowError.MandatoryElementNotFound
        }
        guard let label = json["label"] as? String else {
            print("❌❌❌ label Not Found")
            throw ThrowError.MandatoryElementNotFound
        }
        guard let textError = json["textError"] as? String else {
            print("❌❌❌ textError Not Found")
            throw ThrowError.MandatoryElementNotFound
        }
        
        //-- Optional --
        let placeHolder = json["placeHolder"] as? String
        let maxLength = json["maxLength"] as? String
        let mandatory = json["mandatory"] as? Bool
        let keyboard = json["keyboard"] as? String
        let options = json["options"] as? [String: AnyObject]
        let style = json["style"] as? [String: AnyObject]
        
        
        //== INSERT DATA ==
        //-- Mandatory--
        self.tag = tag
        self.label = label
        self.textError = textError
        
        //-- Optional--
        if (placeHolder != nil) {
            /*  self.bodyBottom = BodyBottomDetailModel()
             try self.bodyBottom?.parseJson(bodyBottom!)
             self.listViewsCreate.append("BodyBottom")*/
        }
        if (maxLength != nil) {
            
        }
        if (mandatory != nil) {
            
        }
        if (keyboard != nil) {
            
        }
        if (options != nil) {
            
        }
        if (style != nil) {
            
        }
    }
}
