//
//  ResultView.swift
//  dermShieldModelTesting
//
//  Created by Abhishek Jadaun on 09/01/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct ResultView: View {
    
    let detectedObjects: [(String, Float)]
    var selectedImage: UIImage
    let scanID: String
    
    init(selectedImage: UIImage, detectedObjects: [(String, Float)]) {
            self.selectedImage = selectedImage
            self.detectedObjects = detectedObjects
            let timestamp = Int(Date().timeIntervalSince1970)
            self.scanID = "\(timestamp)"
            
            print("Filtered Predictions in ResultView: \(self.detectedObjects)")
            saveResultsToDatabase()
        }
    
    func saveResultsToDatabase() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }

        let ref = Database.database().reference()
        let storageRef = Storage.storage().reference()

        if let highestPrecisionResult = detectedObjects.max(by: { $0.1 < $1.1 }) {
            let object = highestPrecisionResult.0
            let precision = highestPrecisionResult.1

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            let formattedDate = dateFormatter.string(from: Date())
            let status = "PENDING"

            var riskLevel = ""

            if object == "nodules" {
                riskLevel = "High risk"
            } else if object == "pustules" || object == "papules" {
                riskLevel = "Medium risk"
            } else if object == "comedones" {
                riskLevel = "Low risk"
            }

            let resultData: [String: Any] = [
                "userID": userID,
                "scanID": scanID,
                "classType": object,
                "confidence": precision,
                "riskLevel": riskLevel,
                "formattedDate": formattedDate,
                "status": status
            ]

            let newChildRef = ref.child("patients/allCases/\(userID)/\(scanID)")
            newChildRef.setValue(resultData)

            let imageRef = storageRef.child("patients/allCases/\(userID)/\(object)/\(scanID)/image.jpg")

            if let imageData = selectedImage.jpegData(compressionQuality: 0.5) {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error)")
                    } else {
                        print("Image uploaded successfully")
                    }
                }
            }
        }
    }

    
    //body
    var body: some View {
        ScrollView{
            VStack{
                HStack {
                    Image(systemName: "checkmark.gobackward")
                        .font(.title)
                        .foregroundColor(.green)
                        .padding(.leading)
                        .navigationBarTitle("Result", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                        
                    HStack{
                        VStack{
                            HStack{
                                Text("Case saved")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            
                            HStack{
                                Text("Stored in your Case files")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                NavigationLink(destination: EmptyView(), label: {
                                    HStack{
                                        Text("View")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.orange)
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                        .foregroundColor(.orange)                            }
                                })
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.green.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // Adjust corner radius as needed
                        .stroke(Color.green, lineWidth: 1) // Adjust border color and width
                )
                .padding(.top)
                
                
                HStack {
                    HStack{
                        VStack{
                            HStack{
                                Text("Recommendation")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .padding(.bottom, 3)
                                Spacer()
                            }
                            HStack{
                                Text("The analysis indicate that you may have a serious condition.  You should send your results to a doctor for further evaluation.")
                                    .font(.caption)
                                Spacer()
                            }
                        }
                        .padding()
                        Image(systemName: "exclamationmark.square.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                            .padding([.leading, .trailing])
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow directly
                .padding([.top, .bottom])
                
                
                VStack {
                    HStack{
                        Text("Possible results")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                    }
                    .padding([.trailing, .leading, .top])
                    
                    Divider()
                        .padding([.leading, .trailing])
                    
                    List(detectedObjects, id: \.0) { object, precision in
                        Text("\(object) - Precision: \(precision)")
                    }
                    
                    
                    ForEach(detectedObjects, id: \.0) { object, precision in
                        if(object == "nodules"){
                            var risk = "High risk"
                            NavigationLink(destination: DiseaseDescription(predictionClass: object, Confidence: precision)){
                                HStack{
                                    var progressValue: Float = precision
                                    ProgressView(value: progressValue, total: 1.0)
                                        .accentColor(.red)
                                        .frame(width: 70)
                                        .padding(.leading)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(object)")
                                            .font(.callout)
                                        HStack{
                                            Text(risk)
                                                .font(.caption)
                                            Text(String(format: "%.1f%%", progressValue * 100))
                                                .font(.caption)
                                        }
                                    }
                                    .padding([.leading, .trailing])
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding([.trailing, .leading])
                                }}
                            .foregroundColor(.black)
                            .padding()
                            Divider()
                                .padding([.leading, .trailing])
                            
                        } else if(object == "pustules"){
                            var risk = "Medium risk"
                            NavigationLink(destination: DiseaseDescription(predictionClass: object, Confidence: precision)){
                                HStack{
                                    var progressValue: Float = precision
                                    ProgressView(value: progressValue, total: 1.0)
                                        .accentColor(.orange)
                                        .frame(width: 70)
                                        .padding(.leading)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(object)")
                                            .font(.callout)
                                        HStack{
                                            Text(risk)
                                                .font(.caption)
                                            Text(String(format: "%.1f%%", progressValue * 100))
                                                .font(.caption)
                                        }
                                    }
                                    .padding([.leading, .trailing])
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding([.trailing, .leading])
                                }}
                            .foregroundColor(.black)
                            .padding()
                            Divider()
                                .padding([.leading, .trailing])
                            
                        } else if(object == "papules"){
                            var risk = "Medium risk"
                            NavigationLink(destination: DiseaseDescription(predictionClass: object, Confidence: precision)){
                                HStack{
                                    var progressValue: Float = precision
                                    ProgressView(value: progressValue, total: 1.0)
                                        .accentColor(.orange)
                                        .frame(width: 70)
                                        .padding(.leading)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(object)")
                                            .font(.callout)
                                        HStack{
                                            Text(risk)
                                                .font(.caption)
                                            Text(String(format: "%.1f%%", progressValue * 100))
                                                .font(.caption)
                                        }
                                    }
                                    .padding([.leading, .trailing])
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding([.trailing, .leading])
                                }}
                            .foregroundColor(.black)
                            .padding()
                            Divider()
                                .padding([.leading, .trailing])
                            
                        } else if (object == "comedones") {
                            var risk = "Low risk"
                            NavigationLink(destination: DiseaseDescription(predictionClass: object, Confidence: precision)){
                                HStack{
                                    var progressValue: Float = precision
                                    ProgressView(value: progressValue, total: 1.0)
                                        .accentColor(.green)
                                        .frame(width: 70)
                                        .padding(.leading)
                                    
                                    VStack(alignment: .leading){
                                        Text("\(object)")
                                            .font(.callout)
                                        HStack{
                                            Text(risk)
                                                .font(.caption)
                                            Text(String(format: "%.1f%%", progressValue * 100))
                                                .font(.caption)
                                        }
                                    }
                                    .padding([.leading, .trailing])
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding([.trailing, .leading])
                                }}
                            .foregroundColor(.black)
                            .padding()
                            Divider()
                                .padding([.leading, .trailing])
                        }
                        
                    }
                    
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow directly
            }
            .padding([.trailing, .leading])
            
            Button(action: {
                // Action to perform when the button is tapped
            }) {
                NavigationLink(destination: AddDoctorView(scanID: scanID)) {
                    Text("Choose your Doctor")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("PrimaryColor"))
                        .cornerRadius(50)
                }
                .padding([.leading, .trailing, .top])
                .padding(.bottom, 8)
            }
            
            NavigationLink(destination: UserFirstView()) {
                Text("Not now")
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
            .padding([.leading, .trailing, .bottom])
            
        }
        .onAppear{
            print("Scan id : \(scanID)")
        }
    }
}


struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        let detectedObjects: [(String, Float)] = [("nodules", 0.95), ("papules", 0.85), ("comedones", 0.75)] // Sample data
        let selectedImage: UIImage? = UIImage(named: "placeholder") // Placeholder image
        return ResultView(selectedImage: selectedImage ?? UIImage(), detectedObjects: detectedObjects)
    }
}

