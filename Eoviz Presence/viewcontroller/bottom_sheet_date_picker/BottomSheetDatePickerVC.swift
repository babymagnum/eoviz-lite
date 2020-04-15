//
//  BottomSheetDatePickerVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 15/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

protocol BottomSheetDatePickerProtocol {
    func pickDate(formatedDate: String)
    func pickTime(pickedTime: String)
}

enum PickerTypeEnum {
    case date
    case time
}

class BottomSheetDatePickerVC: BaseViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    @Inject private var filterDaftarPresensiVM: FilterDaftarPresensiVM
    
    var delegate: BottomSheetDatePickerProtocol?
    var picker: PickerTypeEnum!
    var isBackDate: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        self.view.roundCorners([.topRight, .topLeft], radius: 50)
        
        switch picker {
            case .date?: datePicker.datePickerMode = .date
            default: datePicker.datePickerMode = .time
        }
        
        if !isBackDate {
            datePicker.minimumDate = PublicFunction.stringToDate(date: PublicFunction.getStringDate(pattern: "yyyy-MM-dd"), pattern: "yyyy-MM-dd")
        }
    }
}

extension BottomSheetDatePickerVC {
    @IBAction func buttonPilihClick(_ sender: Any) {
        switch picker {
            case .date?: delegate?.pickDate(formatedDate: PublicFunction.dateToString(datePicker.date, "dd-MM-yyyy"))
        case .time?: delegate?.pickTime(pickedTime: PublicFunction.dateToString(datePicker.date, "HH:mm"))
            default: break
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChange(_ sender: Any) {
        switch picker {
        case .date?:
            print("")
        case .time?:
            print("")
        default: break
        }
    }
}
