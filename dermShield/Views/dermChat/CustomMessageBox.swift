//
//  CustomMessageBox.swift
//  DermShield-DoctorApp
//
//  Created by Himal  on 30/01/24.
//


//  Created by Abhishek Jadaun on 28/01/24.
//

import SwiftUI

struct CustomMessageBox: View {
    let message: AllMessageFromDoctor
    
    @State private var timestamp : Date = Date()
    
    var body: some View {
            VStack{
                HStack(spacing: 15) {
                    Image("Doctor1")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding([.leading, .bottom])
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(message.fullName)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(formatDate(timestamp))
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .padding([.trailing])
                        }
                        
                        HStack{
                            Text("Gender :")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(message.gender)
                                .font(.callout)
                        }
                        
                        HStack {
                            Text("Physical Assistance :")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(message.physicalAssistance)
                                .font(.callout)
                            
                        }
                        Divider()
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                    }
                    
                }
                .previewLayout(.sizeThatFits)
                .background(Color.white)
                .cornerRadius(10)
                
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
//}

struct CustomMessageBox_Previews: PreviewProvider {
    static var previews: some View {
        CustomMessageBox(message: AllMessageFromDoctor(
            fullName: "Dr. Ritansh",
            gender: "Male",
            age: "37",
            physicalAssistance: "Not Required",
            givePrescription: "Have good health")
        
        )
        
        
        
    }
}
