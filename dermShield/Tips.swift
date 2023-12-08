//
//  Tips.swift
//  dermScan - Patients
//
//  Created by Abhishek Jadaun on 03/03/24.
//

import Foundation
import TipKit

struct identifyTip: Tip {
    var title: Text {
        Text("Identify")
    }
    var message: Text? {
        Text("Scan your skin to detect acne and other issues quickly and accurately.")
    }
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}

struct diagnoseTip: Tip {
    var title: Text {
        Text("Diagnose")
    }
    var message: Text? {
        Text("Consult with dermatologists to get professional advice.")
    }
    var image: Image? {
        Image(systemName: "person.fill.questionmark")
    }
}

struct prescribeTip: Tip {
    var title: Text {
        Text("Prescribe")
    }
    var message: Text? {
        Text("Receive prescriptions tailored to your skin's needs.")
    }
    var image: Image? {
        Image(systemName: "pills.fill")
    }
}
