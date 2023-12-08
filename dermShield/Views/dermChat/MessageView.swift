//
//  MessageView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 18/12/23.
//

import SwiftUI
import Firebase
import FirebaseDatabaseInternal

struct AllMessageFromDoctor {
    var fullName: String
    var gender: String
    var age: String
    var physicalAssistance: String
    var givePrescription: String
    
}

class AllMessagesViewModel: ObservableObject {
    @Published var users = [AllMessageFromDoctor]()

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user ID available")
            return
        }

        let databaseRef = Database.database().reference().child("message/prescriptionByDoctor/\(userID)")

        databaseRef.observe(.value) { snapshot in
            var messages = [AllMessageFromDoctor]()

            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let userData = childSnapshot.value as? [String: Any] {
                    if
                       let fullName = userData["fullName"] as? String,
                       let gender = userData["gender"] as? String,
                       let age = userData["age"] as? String,
                       let physicalAssistance = userData["physicalAssistance"] as? String,
                       let givePrescription = userData["givePrescription"] as? String {

                        let mes = AllMessageFromDoctor(
                            fullName: fullName,
                            gender: gender,
                            age: age,
                            physicalAssistance: physicalAssistance,
                            givePrescription: givePrescription
                        )

                        messages.append(mes)
                    }
                }
            }

            self.users = messages
            print("Fetched users successfully. Count: \(messages.count)")
            print(userID)
        }
    }

}


struct MessageView: View {
    
    @ObservedObject private var viewModel = AllMessagesViewModel()
    
    @State private var searchText = ""
    @State private var showFilters = false
    @State private var readFilter = false
    @State private var unreadFilter = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchText)
                            .frame(height: 40)
                        Spacer()
                        Button(action: {
                            withAnimation {
                            }
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .padding(8)
                                .accentColor(Color("PrimaryColor"))
                            
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: 343, height: 40)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .navigationBarTitle("dermChat")
                    .navigationBarItems(trailing: NavigationLink(destination: ProfileCompletedView(), label: {
                        Image(systemName: "person.crop.circle")
                            .font(.title3)
                            .foregroundColor(Color("PrimaryColor"))
                    }))
                    
                    VStack {
                        ForEach(viewModel.users.indices, id: \.self) { i in
                            NavigationLink {
                                MessageSuggestionView(doctorDetails: viewModel.users[i])
                            } label: {
                                CustomMessageBox(message: viewModel.users[i])
                            }
                        }
                    }
                    .padding(.top)
                    
                    
                    if showFilters {
                        HStack() {
                            Toggle("Read", isOn: $readFilter)
                            Toggle("Unread", isOn: $unreadFilter)
                        }
                        .padding()
                        .frame(width: 343)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    Spacer()
                }
            }
        }
    }
}


#Preview {
    MessageView()
}
