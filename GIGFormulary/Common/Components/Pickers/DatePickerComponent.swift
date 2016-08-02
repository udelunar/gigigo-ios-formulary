//
//  DatePickerComponent.swift
//  GIGFormulary
//
//  Created by  Eduardo Parada on 18/7/16.
//  Copyright © 2016 gigigo. All rights reserved.
//

import UIKit

class DatePickerComponent: UIDatePicker {
    
    // Public properties
    
    var textField: UITextField?
    var styles: FormFieldStyleModel?
    var textAcceptButton: String?
    
    var dateSelected: NSDate? {
        get {
            return !(self.textField!.text?.isEmpty ?? true) ? self.datePicker.date : nil
        }
        
        set {
            if let value = newValue {
                self.datePicker.date = value
                self.onDoneTap()
            }
        }
    }
    
    // Private properties
    private let datePicker = UIDatePicker()
    private var dateFormatter: NSDateFormatter {
        let formatter = NSDateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        return formatter
    }
    
    func initTextField(textField: UITextField) {
        self.textField = textField
        self.setupDatePicker()
        self.setupDoneToolbar()
    }
    
    // MARK - Private Helpers
    
    private func setupDatePicker() {
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        self.datePicker.maximumDate = NSDate()
        self.datePicker.addTarget(
            self,
            action: #selector(onDatePickerValueChanged),
            forControlEvents: UIControlEvents.ValueChanged
        )
        self.textField!.inputView = self.datePicker
    }
    
    private func setupDoneToolbar() {
        // datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: self.textAcceptButton, style: UIBarButtonItemStyle.Done, target: self, action: #selector(onDoneTap))
        doneButton.tintColor = self.styles?.acceptColorPicker
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        toolBar.backgroundColor = self.styles?.containerAcceptColorPicker
        self.datePicker.backgroundColor = self.styles?.backgroundPickerColorPicker
        
        self.textField!.inputAccessoryView = toolBar
    }
    
    @objc private func onDatePickerValueChanged(value: UIDatePicker) {
        self.textField?.text = self.dateFormatter.stringFromDate(value.date)
    }
    
    @objc private func onDoneTap() {
        self.onDatePickerValueChanged(self.datePicker)
        self.textField?.endEditing(true)
    }
    
    // MARK: - FormDelegate
    
    func formUserDidTapGo() {}
    
    func formUserBeginEditingTap(sender: FormField) {
        self.textField!.text = "10/29/29999"
    }

}
