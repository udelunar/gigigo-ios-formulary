//
//  Validator.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 1/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class Validator: NSObject {
    
    var mandatory: Bool
    var minLength: Int?
    var maxLength: Int?
    var minAge: Int?
    var custom: String?
    var type: String?
    var textError: String?
    
    override init() {
        self.mandatory = false
        super.init()
    }
    
    required init(mandatory: Bool) {
        self.mandatory = mandatory
        super.init()
    }
    
    required init (mandatory: Bool, custom: String) {
        self.custom = custom
        self.mandatory = mandatory
        super.init()
    }
    
    // MARK: Public Method    
    
    func validate(_ value: Any?) -> Bool {
        if value == nil && self.mandatory {
            return false
        }
        return true
    }
}
