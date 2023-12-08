//
//  CaseView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 10/12/23.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct AllCasesUser: Hashable {
    var userID: String
    var scanID: String
    var classType: String
    var confidence: Double
    var riskLevel: String
    var formattedDate: String
    var status: String
}

class AllCasesViewModel: ObservableObject {
    @Published var users = [AllCasesUser]()
    
    @Published var refreshData = false
    
    func updateCaseStatus(scanID: String) {
           if let userID = Auth.auth().currentUser?.uid {
               let databaseRef = Database.database().reference().child("patients/allCases/\(userID)/\(scanID)")

               // Update the 'status' field to 'COMPLETE'
               databaseRef.updateChildValues(["status": "COMPLETE"])
               
               self.refreshData.toggle()
           }
       }
    
    
    func updateCaseStatusToConsulting(scanID: String) {
           if let userID = Auth.auth().currentUser?.uid {
               let databaseRef = Database.database().reference().child("patients/allCases/\(userID)/\(scanID)")

               // Update the 'status' field to 'COMPLETE'
               databaseRef.updateChildValues(["status": "CONSULTING"])
               
               self.refreshData.toggle()
           }
       }
        
    init() {
        fetchAllUsers()
    }
    
    func fetchAllUsers() {
        if let userID = Auth.auth().currentUser?.uid {
            let databaseRef = Database.database().reference().child("patients/allCases/\(userID)")
            
            databaseRef.observe(.value) { snapshot  in
                var cases = [AllCasesUser]()
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let userData = childSnapshot.value as? [String: Any] {
                        if let userID = userData["userID"] as? String,
                           let scanID = userData["scanID"] as? String,
                           let classType = userData["classType"] as? String,
                           let confidence = userData["confidence"] as? Double,
                           let riskLevel = userData["riskLevel"] as? String,
                           let formattedDate = userData["formattedDate"] as? String,
                           let status = userData["status"] as? String {
                            
                            let caseOfUser = AllCasesUser(
                                userID: userID,
                                scanID: scanID,
                                classType: classType,
                                confidence: confidence,
                                riskLevel: riskLevel,
                                formattedDate: formattedDate,
                                status: status
                            )
                            
                            cases.append(caseOfUser)
                        }
                    }
                }
                
                self.users = cases
            }
        }
    }
}

struct CaseView: View {
    @State private var selectedSegment = 0
    @ObservedObject private var viewModelCases = AllCasesViewModel()
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            NavigationView {
                VStack {
                    Picker(selection: $selectedSegment, label: Text("")) {
                        Text("All").tag(0)
                        Text("Low Risk").tag(1)
                        Text("Medium").tag(2)
                        Text("High").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    ScrollView {
                        switch selectedSegment {
                        case 0:
                            ForEach(viewModelCases.users, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 1:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "Low risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 2:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "Medium risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        case 3:
                            ForEach(viewModelCases.users.filter { $0.riskLevel == "High risk" }, id: \.self) { caseDetail in
                                NavigationLink(destination: CaseDetailsView(caseInfo: caseDetail)){
                                    customRiskBox(caseDetails: caseDetail)
                                        .padding(.top, 10)
                                        .foregroundColor(.black)
                                }
                            }
                        default:
                            Text("Error")
                        }
                    }
                    
                    Spacer()
                }
                // use onReceive to refresh the view when the data changes
                    .onReceive(viewModelCases.$refreshData) { _ in
                        viewModelCases.fetchAllUsers()
                    }

                .navigationBarTitle("Case")
                .navigationBarItems(trailing: NavigationLink(destination: ProfileCompletedView(), label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title3)
                        .foregroundColor(Color("PrimaryColor"))
                }))
            }
        }
    }
}

#Preview {
    CaseView()
}
