//
//  +View.swift
//  dermScan - Patients
//
//  Created by Abhishek Jadaun on 29/02/24.
//

import SwiftUI

extension View{
    func getRootViewController()-> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
        }
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
}
