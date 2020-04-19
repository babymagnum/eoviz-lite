//
//  BottomSheetSinglePickerVC.swift
//  Eoviz Presence
//
//  Created by Arief Zainuri on 17/04/20.
//  Copyright © 2020 Gama Techno. All rights reserved.
//

import UIKit
import DIKit

protocol BottomSheetPickerProtocol {
    func getItem(data: String, id: String)
}

class BottomSheetPickerVC: BaseViewController, UIPickerViewDelegate {

    @IBOutlet weak var firstPickerView: UIPickerView!
    
    var hasId: Bool! // determine if has id or no
    var useSingleArray: Bool! // determine type of picker
    var singleArray: [String]! // single dimension array
    var singleArrayId: [String]! // for the id
    var multiArray: [[String]]! // multi dimension array
    var multiArrayId: [[String]]! // for the id
    var delegate: BottomSheetPickerProtocol!
    
    private var selectedItem = ""
    private var selectedItemId = "0"
    @Inject private var filterRiwayatTukarShiftVM: FilterRiwayatTukarShiftVM
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.view.roundCorners([.topLeft, .topRight], radius: 50)
    }
    
    private func setupView() {
        if let _singleArray = singleArray {
            selectedItem = _singleArray[0]
        }
        
        if let _multiArray = multiArray {
            selectedItem = _multiArray[0][0]
        }
        
        if let _singleArrayId = singleArrayId {
            selectedItemId = _singleArrayId[0]
        }
        
        if let _multiArrayId = multiArrayId {
            selectedItemId = _multiArrayId[0][0]
        }
        
        firstPickerView.delegate = self
        firstPickerView.dataSource = self
    }

    @IBAction func buttonPilihClick(_ sender: Any) {
        delegate.getItem(data: selectedItem, id: selectedItemId)
        dismiss(animated: true, completion: nil)
    }
}

extension BottomSheetPickerVC: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return singleArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // change this to match with multi array
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return singleArray[row]
        // return pickerData[component][row] // uncomment this code for multi array
    }
    
    func pickerView(_ picker: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if (picker == firstPickerView) {
            // for multi array -> multiArray[component][row]
            // for single array -> singleArray[row]
            print(singleArray[row])
            selectedItem = singleArray[row]
            
            if hasId {
                selectedItemId = singleArrayId[row]
            }
        }
    }
}
