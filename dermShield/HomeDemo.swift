//
//  HomeDemo.swift
//  dermShield - Patients
//
//  Created by Himal  on 27/02/24.
//

import SwiftUI

struct HomeDemo: View {
    var doctor : AllDoctorUser
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    Text("Acne Analysis")
                        .font(.callout)
                        .fontWeight(.light)
                        .frame(maxWidth: 340, alignment: .leading)
                        .padding(.trailing)
                        .padding(.top)
                    VStack {
                        Image("analysisOne")
                            .resizable()
                            .frame(width: 350, height: 160)
                            .cornerRadius(20)
                            .padding([.top, .leading, .trailing])
                        
                        Text("Capture a clear image of the impacted area, receive instant diagnosis.Share symptoms   with your doctor if needed.")
                            .font(.callout)
                            .fontWeight(.ultraLight)
                            .frame(maxWidth: 330, alignment: .leading)
                            .padding(.leading)
                        
                        HStack{
                            Spacer()
                            Button(action: {
                            
                            }
                            ){
                            Text("Start")
                                .padding(.horizontal, 25)
                                .padding(.vertical, 10)
                                .background(Color("PrimaryColor"))
                                .foregroundColor(.white)
                                .cornerRadius(20)
                            }
                            .padding(.trailing, 30)
                    }
                    }
                    .padding(.bottom)
                    .background(Color.white)
                    .cornerRadius(20.0)
                    .padding([.leading, .trailing])
                    .shadow(color: Color.black.opacity(0.10), radius: 60, x: 0.0, y: 16)
                    
                    HStack{
                        Text("Recent Cases")
                            .font(.callout)
                            .fontWeight(.light)
                            .frame(maxWidth: 340, alignment: .leading)
                        
                        
                        
                        HStack{
                            Text("See more")
                                .font(.callout)
                                .fontWeight(.light)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.trailing,22)
                    .padding(.leading, 35)
                    .padding(.top)
                    
                    VStack{
                        HStack {
                            Image("LowRisk")
                                .cornerRadius(10)
                                .padding()
                            Spacer()
                            VStack {
                                HStack{
                                    Text("Case 1")
                                        .font(.title3)
                                        .fontWeight(.bold)
                                    Spacer()
                                }
                                
                                HStack{
                                    Text("Disease Name")
                                        .font(.callout)
                                    Spacer()
                                }
                                
                                HStack{
                                    Image("greenCircle")
                                    Text("Low risk")
                                        .font(.caption)
                                    Spacer()
                                }
                                
                                HStack{
                                    Image(systemName: "calendar")
                                    Text("Date")
                                        .font(.caption)
                                    Spacer()
                                }
                                
                            }
                            .padding()
                        }
                        .background(.green.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10) // Adjust corner radius as needed
                                .stroke(Color.green, lineWidth: 1) // Adjust border color and width
                        )
                        .padding([.leading, .trailing])
                    }
                    HStack{
                        Text("My Doctors")
                            .font(.callout)
                            .fontWeight(.light)
                            .frame(maxWidth: 340, alignment: .leading)
                        
                        
                        
                        HStack{
                            Text("See more")
                                .font(.callout)
                                .fontWeight(.light)
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.trailing,22)
                    .padding(.leading, 35)
                    .padding(.top)
                    
                    DoctorCard(doctorDetails: doctor)
                        .padding([.bottom])
    
                    
                    Text("Journey")
                        .font(.callout)
                        .fontWeight(.light)
                        .frame(maxWidth: 340, alignment: .leading)
                        .padding(.trailing)
                        
                    JourneyFeaturesView()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(color: Color.gray, radius: 0.1)
                        .padding([.bottom, .trailing, .leading])
                    
                    
                    
                   
                    Text("Dermatosis")
                        .font(.callout)
                        .fontWeight(.light)
                        .frame(maxWidth: 340, alignment: .leading)
                        .padding(.trailing,22)
                        
                    TabView() {
                        NavigationLink(destination: DiseaseDescription(predictionClass: "nodules", Confidence: 0.9)){
                            customDiseaseDataBox(imageName: "description1", title: "Nodules", progressValue: 0.9, indicatorColor: Color.brown, risk: "High Risk")
                                .foregroundColor(.white)
                                .shadow(color: Color.white, radius: 0.1)
                        }
                        
                        NavigationLink(destination: DiseaseDescription(predictionClass: "pustules", Confidence: 0.7)){
                            customDiseaseDataBox(imageName: "description2", title: "Pustules", progressValue: 0.7, indicatorColor: Color.orange, risk: "Medium Risk")
                                .foregroundColor(.white)
                        }
                        
                        NavigationLink(destination: DiseaseDescription(predictionClass: "papules", Confidence: 0.7)){
                            customDiseaseDataBox(imageName: "description3", title: "Papules", progressValue: 0.7, indicatorColor: Color.yellow.opacity(0.9), risk: "Medium Risk")
                                .foregroundColor(.white)
                        }
                        
                        NavigationLink(destination: DiseaseDescription(predictionClass: "comedone", Confidence: 0.4)){
                            customDiseaseDataBox(imageName: "description4", title: "Comedone", progressValue: 0.4, indicatorColor: Color.green.opacity(0.7), risk: "Low Risk")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom)
                    .frame(height: 140)
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                    
                }
            }
        }
    }
}

struct HomeDemo_Previews: PreviewProvider {
    static var previews: some View {
        HomeDemo(doctor: AllDoctorUser(
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
            // Add more properties as needed
        ))
    }
}
