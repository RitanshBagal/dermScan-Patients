//
//  CustomMessageBoxView.swift
//  dermShield - Patients
//
//  Created by Abhishek Jadaun on 27/01/24.
//
import SwiftUI

struct CustomMessageBoxView: View {
    @EnvironmentObject var patientMessageViewModel: MessageViewModel
    @State private var newMessage: String = ""

    var body: some View {
        VStack {
            List(patientMessageViewModel.messages) { message in
                CustomMessageBoxRowView(message: message)
            }

            HStack {
                TextField("Type your message...", text: $newMessage)
                    .padding()
                Button(action: sendMessage) {
                    Text("Send")
                        .padding()
                }
            }
        }
        .onAppear {
            // Fetch messages when the view appears
            patientMessageViewModel.fetchMessages()
        }
    }

    private func sendMessage() {
        // Send the new message to your data source
        let message = Message(sender: "Patient", senderClinic: "", caseDetails: "", text: newMessage, timestamp: Date(), isRead: true, imageName: "patientImage")
        patientMessageViewModel.sendMessage(message: message)

        // Clear the text field
        newMessage = ""
    }
}

struct CustomMessageBoxView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMessageBoxView()
            .environmentObject(MessageViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


