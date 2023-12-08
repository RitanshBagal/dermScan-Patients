//
//  HomeView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 11/12/23.
//

import SwiftUI

struct DiscoverView: View {
    @State private var searchElement: String = ""
    @State private var isEditProfileVisible = false
    @State private var isPopoverPresented = false
    
    var tipDiagnose = diagnoseTip()
    var tipIdentify = identifyTip()
    var tipPrescribe = prescribeTip()
    
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            NavigationView{
                ScrollView {
                    VStack{
                        
                        VStack{
                            
                            
                            Text("Procedure")
                                .font(.callout)
                                .fontWeight(.light)
                                .frame(maxWidth: 340, alignment: .leading)
                                .padding([.leading, .leading])
                                .navigationBarItems(trailing:
                                                        NavigationLink(destination: ProfileCompletedView(), label: {
                                    Image(systemName: "person.crop.circle")
                                        .font(.title3)
                                        .foregroundColor(Color("PrimaryColor"))
                                }))
                            
                            
                            HStack {
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.green)
                                        .opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    
                                    FeatureView(symbolName: "magnifyingglass", featureTitle: "Identify", backgroundColor: Color.green, descriptionText: "Scan your skin to detect acne and other issues quickly and accurately.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                .popoverTip(tipIdentify)
                                
                                
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.blue).opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(maxHeight: 125)
                                    FeatureView(symbolName: "person.fill.questionmark", featureTitle: "Diagnose", backgroundColor: Color.blue, descriptionText: "Consult with dermatologists to get professional advice.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                .popoverTip(tipDiagnose)
                                
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.purple).opacity(0.1)
                                        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                        .frame(maxHeight: 125)
                                    FeatureView(symbolName: "pills.fill", featureTitle: "Prescribe", backgroundColor: Color.purple, descriptionText: "Receive prescriptions tailored to your skin's needs.")
                                        .padding(10)
                                }
                                .padding(.leading, 5)
                                .padding(.trailing, 5)
                                .padding(.bottom, 5)
                                .popoverTip(tipPrescribe)
                                
                            }
                            .padding([.leading, .trailing])
                            
                            
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
                                            Text("Case id: 1043565697854")
                                                .font(.callout)
                                                .fontWeight(.semibold)
                                            Spacer()
                                        }
                                        
                                        HStack{
                                            Text("Comedone")
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
                                            Text("27/02/2024")
                                                .font(.caption)
                                            Spacer()
                                        }
                                        
                                    }
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
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                                    .frame(maxHeight: 125)
                                HStack {
                                    Image("Doctor2") // Replace "doctorImage" with the actual image name
                                        .font(.largeTitle)
                                        .cornerRadius(8)
                                        .padding([.leading, .trailing])
                                        .padding([.leading, .trailing])
                                    
                                    VStack(alignment: .leading) {
                                        Text("Dr. John Doe")
                                            .font(.title3)
                                            .fontWeight(.medium)
                                            .padding(.top)
                                        Text("Dermatologist")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                        Text("VSG Potheri")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                            .padding(.bottom)
                                    }
                                    Spacer()
                                }
                            }
                            .padding([.trailing, .leading, .bottom])
                            
                            
                            Text("Know more about Acne")
                                .font(.callout)
                                .fontWeight(.light)
                                .frame(maxWidth: 340, alignment: .leading)
                                .padding([.leading, .leading])
                            
                            TabView() {
                                NavigationLink(destination: DiseaseDescription(predictionClass: "nodules", Confidence: 0.9)){
                                    customDiseaseDataBox(imageName: "description1", title: "Nodules", progressValue: 0.9, indicatorColor: Color.brown, risk: "High Risk")
                                        .foregroundColor(.white)
                                        .shadow(color: Color.gray, radius: 0.1)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "pustules", Confidence: 0.7)){
                                    customDiseaseDataBox(imageName: "description2", title: "Pustules", progressValue: 0.7, indicatorColor: Color.orange, risk: "Medium Risk")
                                        .foregroundColor(.white)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "papules", Confidence: 0.7)){
                                    customDiseaseDataBox(imageName: "description3", title: "Papules", progressValue: 0.7, indicatorColor: Color.yellow, risk: "Medium Risk")
                                        .foregroundColor(.white)
                                }
                                
                                NavigationLink(destination: DiseaseDescription(predictionClass: "comedone", Confidence: 0.4)){
                                    customDiseaseDataBox(imageName: "description4", title: "Comedone", progressValue: 0.4, indicatorColor: Color.green, risk: "Low Risk")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom)
                            .frame(height: 140)
                            .tabViewStyle(PageTabViewStyle())
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                        }
                        .sheet(isPresented: $isEditProfileVisible) {
                            ProfileView()
                        }
                        
                        Spacer()
                    }
                    .navigationTitle("Discover")            }
            }
        }
    }
}


//struct JourneyFeaturesView: View {
//    var body: some View {
//        ZStack{
//            RoundedRectangle(cornerRadius: 10)
//                .foregroundColor(.white)
//                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
//            HStack {
//
//            }
//        }
//    }
//}

struct FeatureView: View {
    var symbolName: String
    var featureTitle: String
    var backgroundColor: Color
    var descriptionText: String
    
    var body: some View {
        VStack {
            Image(systemName: symbolName)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding()
                .background(backgroundColor)
                .clipShape(Circle())
                .padding(.bottom, 5)
            Text(featureTitle)
                .font(.caption)
                .bold()
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}


struct customDiseaseDataBox: View {
    var imageName: String
    var title: String
    var progressValue: Double
    var indicatorColor: Color
    var risk: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .font(.title)
            
            VStack (alignment: .leading){
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                
                HStack {
                    
                    ProgressView(value: progressValue, total: 1.0)
                        .accentColor(Color.white)
                        .frame(width: 100)
                    
                    Text(String(format: "%.1f%%", progressValue * 100))
                        .font(.caption)
                    
                }
                
                HStack{
                    Text(risk)
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                }
            }
            .padding([.leading, .trailing])
            
            VStack {
                HStack {
                    Text("Read")
                        .font(.caption2)
                        .fontWeight(.semibold)
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(Color.white)
                
                Spacer()
            }
        }
        .padding(.leading)
        .padding()
        .background(indicatorColor)
        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 2)
        .cornerRadius(10) // Adjust the height as needed
    }
}

struct customProfileCardView : View {
    
    @State private var progressValue: Double = 20
    
    var body: some View {
        HStack{
            Image(systemName: "person.crop.circle")
                .font(.system(size: 50))
                .foregroundColor(Color.gray)
                .overlay(
                    RoundedRectangle(cornerRadius: 50) // Adjust corner radius as needed
                        .stroke(Color.white, lineWidth: 3) // Adjust border color and width
                )
                .padding(.leading)
            VStack{
                HStack{
                    Text("My Profile")
                        .fontWeight(.bold)
                        .padding([.leading, .trailing])
                    Spacer()
                }
                
                HStack{
                    ProgressView(value: progressValue, total: 100)
                        .accentColor(Color("PrimaryColor"))
                    
                    Text(String(format: "%.0f%", progressValue) + "%")
                        .font(.caption)
                }
                .padding([.leading, .trailing])
                
                HStack{
                    Text("Not Completed")
                        .font(.caption)
                        .padding([.leading, .trailing])
                    Spacer()
                }
            }
            .padding([.trailing, .top, .bottom])
        }
        
    }
}

#Preview {
    DiscoverView()
}
