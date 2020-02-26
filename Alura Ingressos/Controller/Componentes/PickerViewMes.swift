//
//  PickerViewMes.swift
//  Alura Ingressos
//
//  Created by Matheus Rodrigues Araujo on 29/01/20.
//  Copyright © 2020 Curso IOS. All rights reserved.
//

import UIKit

protocol PickerViewMesSelecionado {
    func mesSelecionado(mes:String)
}

class PickerViewMes: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var delegate: PickerViewMesSelecionado?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(row+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if delegate != nil {
            delegate?.mesSelecionado(mes: "\(row+1)" )
        }
    }
    
}
