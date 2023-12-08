import SwiftUI
import FirebaseDatabaseInternal
import Firebase
import FirebaseStorage

struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var countryOfResidence: String = ""
    @State private var city: String = ""
    @State private var postCode: String = ""
    @State private var skinDiseases: String = ""
    @State private var otherDiseases: String = ""
    @State private var allergies: String = ""
    @State private var currentMedications: String = ""
    @State private var familyMedicalHistory: String = ""

    let countries = ["India", "Nepal", "USA", "Australia", "Japan"]
    let genders = ["Male", "Female", "Other"]

    @State private var isImagePickerPresented: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profileImageURL: URL?
    
    var isSaveButtonDisabled: Bool {
            return name.isEmpty ||
                   gender.isEmpty ||
                   age.isEmpty ||
                   countryOfResidence.isEmpty ||
                   city.isEmpty ||
                   postCode.isEmpty 
        }
    
    

    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                    Image(uiImage: selectedImage ?? UIImage(systemName: "person.crop.circle")!)
                        .resizable()
                        .foregroundColor(Color("PrimaryColor"))
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .padding(.bottom, 1)
                        .padding(.top)
                        .onTapGesture {
                            isImagePickerPresented.toggle()
                        }
                    Spacer()
                }
                
                Form {
                    Section(header: Text("Personal Details")) {
                        TextField("Name", text: $name)
                        
                        Picker("Gender", selection: $gender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        
                        TextField("Age", text: $age)
                        
                        Picker("Country Of Residence", selection: $countryOfResidence) {
                            ForEach(countries, id: \.self) { country in
                                Text(country)
                            }
                        }
                        HStack {
                            TextField("City", text: $city)
                            TextField("PostCode", text: $postCode)
                        }
                    }
                    
                    Section(header: Text("Medical History")) {
                        TextField("Skin Diseases", text: $skinDiseases)
                        TextField("Other Diseases", text: $otherDiseases)
                        TextField("Allergies", text: $allergies)
                        TextField("Current Medications", text: $currentMedications)
                        TextField("Family Medical History", text: $familyMedicalHistory)
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Save") {
                    saveProfileData()
                }.disabled(isSaveButtonDisabled))
            }
            .background(Color.gray.opacity(0.11))
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: self.$selectedImage)
            }
        }
    }

    func saveProfileData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let userProfile = UserProfile(
            name: name,
            gender: gender,
            age: age,
            countryOfResidence: countryOfResidence,
            city: city,
            postCode: postCode,
            skinDiseases: skinDiseases,
            otherDiseases: otherDiseases,
            allergies: allergies,
            currentMedications: currentMedications,
            familyMedicalHistory: familyMedicalHistory
        )

        let databaseRef = Database.database().reference()
        let userPath = "patients/profile/\(userID)"

        databaseRef.child(userPath).setValue(userProfile.dictionaryRepresentation()) { (error, _) in
            if let error = error {
                print("Error saving profile data: \(error)")
            } else {
                print("Profile data saved successfully")
                saveProfileImage()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    
    func saveProfileImage() {
        guard let userID = Auth.auth().currentUser?.uid, let image = selectedImage else {
            return
        }

        let storageRef = Storage.storage().reference().child("patients/profile/\(userID)/profileImage.jpg")

        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Error uploading image: \(error)")
                } else {
                    print("Image uploaded successfully")
                    storageRef.downloadURL { (url, error) in
                        if let url = url {
                            profileImageURL = url
                            // Save the image URL to the database if needed
                        }
                    }
                }
            }
        }
    }
}

struct UserProfile {
    var name: String
    var gender: String
    var age: String
    var countryOfResidence: String
    var city: String
    var postCode: String
    var skinDiseases: String
    var otherDiseases: String 
    var allergies: String
    var currentMedications: String
    var familyMedicalHistory: String
    
    // Add this method to convert the user profile to a dictionary
        func dictionaryRepresentation() -> [String: Any] {
            return [
                "name": name,
                "gender": gender,
                "age": age,
                "countryOfResidence": countryOfResidence,
                "city": city,
                "postCode": postCode,
                "skinDiseases": skinDiseases,
                "otherDiseases": otherDiseases,
                "allergies": allergies,
                "currentMedications": currentMedications,
                "familyMedicalHistory": familyMedicalHistory
            ]
        }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
