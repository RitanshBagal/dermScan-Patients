import SwiftUI
import FirebaseDatabaseInternal
import FirebaseAuth

struct SummaryView: View {
    
    let scanID: String
    var doctor: AllDoctorUser // Receive the selected doctor as a parameter
    
    @State private var isSymptomViewPresent = false
    @State private var showConfirmation = false
    @State private var navigateToNextScreen = false
    
    let genders = ["Select", "Male", "Female", "Other"]
    
    @State private var fullName: String = ""
    @State private var gender: String = ""
    @State private var age: String = ""
    
    @State private var bodyPart: String? = nil
    @State private var time: String? = nil
    @State private var symptom: String? = nil
    @State private var extraSymptom: String? = nil
    
    @State private var currentCaseDetail: CurrentCaseDetails?
    
    @ObservedObject private var viewModelCases = AllCasesViewModel()
    
    var circleColor: String {
        switch currentCaseDetail?.riskLevel {
        case "Low risk":
            return "greenCircle"
        case "Medium risk":
            return "orangeCircle"
        case "High risk":
            return "redCircle"
        default:
            return ""
        }
    }
    
    var riskColor: Color {
        switch currentCaseDetail?.riskLevel {
        case "Low risk":
            return Color.green
        case "Medium risk":
            return Color.orange
        case "High risk":
            return Color.red
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                Color("BgColor").edgesIgnoringSafeArea(.all)
                VStack {
                    
                    HStack {
                        Text("CASE DETAILS")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.leading, .trailing, .top])
                        Spacer()
                    }
                    
                    VStack {
                        HStack {
                            Image("LowRisk")
                                .cornerRadius(10)
                                .padding(12)
                            
                            VStack(alignment: .leading) {
                                
                                HStack {
                                    Text(currentCaseDetail?.classType ?? "")
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Text(currentCaseDetail?.status ?? "")
                                        .font(.caption2)
                                        .fontWeight(.semibold)
                                        .padding(8)
                                        .background((currentCaseDetail?.status == "COMPLETE" ? Color.green.opacity(0.4) : Color.gray.opacity(0.4)) ?? Color.clear)
                                        .cornerRadius(10)
                                }
                                
                                HStack {
                                    Image(circleColor)
                                    if let confidence = currentCaseDetail?.confidence {
                                        let precision = String(format: "%.1f%%", confidence * 100)
                                        Text("\(currentCaseDetail?.riskLevel ?? "") (\(precision))")
                                            .font(.caption)
                                    }
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text(currentCaseDetail?.formattedDate ?? "")
                                        .font(.caption)
                                }
                            }
                            
                            Spacer()
                        }
                    }
                    .background(riskColor.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(riskColor, lineWidth: 1)
                    )
                    .padding([.leading, .trailing])
                    
                    HStack {
                        Text("DOCTOR DETAILS")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding([.leading, .trailing, .top])
                        Spacer()
                    }
                    
                    // Add Doctor's card here
                    DoctorCard(doctorDetails: doctor)
                    
                    HStack {
                        Text("PATIENT'S DETAILS")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .navigationBarTitle("summary", displayMode: .inline)
                            .padding([.leading, .trailing, .top])
                        Spacer()
                    }
                    
                    VStack() {
                        TextField("Full Name", text: $fullName)
                            .padding([.leading, .trailing, .top])
                        
                        Divider()
                            .padding([.leading, .trailing])
                        
                        HStack {
                            Text("Gender")
                            Spacer()
                            Picker("Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }
                            .accentColor(.gray)
                        }
                        .padding([.leading, .trailing])
                        
                        Divider()
                            .padding([.leading, .trailing])
                        
                        TextField("Age", text: $age)
                            .padding([.leading, .trailing, .bottom])
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                    .padding([.leading, .trailing, .bottom])
                    
                    Button(action: {
                        isSymptomViewPresent.toggle()
                    }, label: {
                        VStack {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Symptoms")
                            }
                            .padding(10)
                            .foregroundColor(Color("PrimaryColor"))
                        }
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
                        .padding([.leading, .trailing, .bottom])
                        .sheet(isPresented: $isSymptomViewPresent) {
                            SymptomsView(onSave: { bodyPart, time, symptom, extraSymptom in
                                // Update the state variables with selected symptoms
                                self.bodyPart = bodyPart
                                self.time = time
                                self.symptom = symptom
                                self.extraSymptom = extraSymptom
                            })
                            .foregroundColor(.black)
                        }
                    })
                    
                    Button(action: {
                        // Action to perform when the button is tapped
                        showConfirmation = true
                        saveResultForSummary()
                        viewModelCases.updateCaseStatusToConsulting(scanID: currentCaseDetail!.scanID)
                    }) {
                        Text("Submit")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("PrimaryColor"))
                            .cornerRadius(50)
                    }
                    .padding([.leading, .trailing, .top])
                    .alert(isPresented: $showConfirmation) {
                        Alert(
                            title: Text("Results Sent!"),
                            message: Text("The doctor will send you a message within 48 hours with his recommendations and next steps."),
                            dismissButton: .default(Text("Ok")) {
                                navigateToNextScreen = true
                            }
                        )
                    }
                    
                    NavigationLink(
                        destination: UserFirstView(),
                        isActive: $navigateToNextScreen,
                        label: { EmptyView() }
                    )
                }
                
                NavigationLink(destination: UserFirstView()) {
                    Text("Cancel")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color("PrimaryColor"), lineWidth: 5)
                        )
                        .cornerRadius(50)
                }
                .padding()
            }
        }
        .onAppear {
            fetchCurrentCaseDetails()
        }
    }

    func saveResultForSummary() {
        guard let userIDPatient = Auth.auth().currentUser?.uid else {
            return
        }
        let userAppointmentData = UserAppointmentDetails(
            userIDPatient: userIDPatient,
            fullName: fullName,
            gender: gender,
            age: age,
            bodyPart: bodyPart ?? "",
            time: time ?? "",
            symptom: symptom ?? "",
            extraSymptom: extraSymptom ?? ""
        )

        let ref = Database.database().reference()
        let userPath = ref.child("message/requestByPatient/\(doctor.userId)").childByAutoId()

        userPath.setValue(userAppointmentData.dictionaryRepresentation()) { (error, _) in
            if let error = error {
                print("Error saving profile data: \(error)")
            } else {
                print("Profile data saved successfully")
            }
        }
    }

    func fetchCurrentCaseDetails() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let databaseRef = Database.database().reference()
        let userPath = "patients/allCases/\(userID)/\(scanID)"

        databaseRef.child(userPath).observeSingleEvent(of: .value) { snapshot in
            guard let data = snapshot.value as? [String: Any] else {
                // Handle invalid snapshot data
                print("Invalid snapshot data")
                return
            }

            // Assign the data to the currentCaseDetail property
            self.currentCaseDetail = CurrentCaseDetails(
                userID: data["userID"] as? String ?? "",
                scanID: data["scanID"] as? String ?? "",
                classType: data["classType"] as? String ?? "",
                confidence: data["confidence"] as? Double ?? 0.0,
                riskLevel: data["riskLevel"] as? String ?? "",
                formattedDate: data["formattedDate"] as? String ?? "",
                status: data["status"] as? String ?? ""
            )
        }
    }
}

struct UserAppointmentDetails {
    var userIDPatient: String
    var fullName: String
    var gender: String
    var age: String
    var bodyPart: String
    var time: String
    var symptom: String
    var extraSymptom: String
    
    // Add this method to convert the user profile to a dictionary
    func dictionaryRepresentation() -> [String: Any] {
        return [
            "userIDPatient": userIDPatient,
            "fullName": fullName,
            "gender": gender,
            "age": age,
            "bodyPart": bodyPart,
            "time": time,
            "symptom": symptom,
            "extraSymptom": extraSymptom
        ]
    }
}

struct CurrentCaseDetails {
    var userID: String
    var scanID: String
    var classType: String
    var confidence: Double
    var riskLevel: String
    var formattedDate: String
    var status: String
    
    // Add this method to convert the user profile to a dictionary
        func dictionaryRepresentation() -> [String: Any] {
            return [
                "userID": userID,
                "scanID": scanID,
                "classType": classType,
                "confidence": confidence,
                "riskLevel": riskLevel,
                "formattedDate": formattedDate,
                "status": status
            ]
        }
}

#if DEBUG
struct SummaaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(scanID: "3434", doctor: AllDoctorUser(
            userId: "12345678",
            name: "Dr. John Doe",
            gender: "Male",
            age: "35",
            countryOfResidence: "USA",
            city: "New York",
            postCode: "10001",
            about: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            specialization: "Cardiologist",
            clinic: "HeartCare Clinic",
            clinicAddress: "123 Main St",
            workWeekFrom: "Monday",
            workWeekTo: "Friday",
            nationalID: "123456789",
            nmcNumber: "NMC12345"
        ))
    }
}
#endif
