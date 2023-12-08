//
//  AddDoctorView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 29/12/23.
//

import SwiftUI
import FirebaseDatabase
import MapKit
import CoreLocation

// Existing Doctor and related structs

struct AllDoctorUser {
    var userId: String
    var name: String
    var gender: String
    var age: String
    var countryOfResidence: String
    var city: String
    var postCode: String
    var about: String
    var specialization: String
    var clinic: String
    var clinicAddress: String
    var workWeekFrom: String
    var workWeekTo: String
    var nationalID: String
    var nmcNumber: String
}

class AllDoctorsViewModel: ObservableObject {
    @Published var users = [AllDoctorUser]()

    init() {
        fetchAllUsers()
    }

    private func fetchAllUsers() {
        let databaseRef = Database.database().reference().child("doctors/profile")

        databaseRef.observe(.value) { snapshot in
            var doctors = [AllDoctorUser]()

            for case let childSnapshot as DataSnapshot in snapshot.children {
                if let userData = childSnapshot.value as? [String: Any] {
                    if let userId = userData["userId"] as? String,
                       let name = userData["name"] as? String,
                       let gender = userData["gender"] as? String,
                       let age = userData["age"] as? String,
                       let countryOfResidence = userData["countryOfResidence"] as? String,
                       let city = userData["city"] as? String,
                       let postCode = userData["postCode"] as? String,
                       let about = userData["about"] as? String,
                       let specialization = userData["specialization"] as? String,
                       let clinic = userData["clinic"] as? String,
                       let clinicAddress = userData["clinicAddress"] as? String,
                       let workWeekFrom = userData["workWeekFrom"] as? String,
                       let workWeekTo = userData["workWeekTo"] as? String,
                       let nationalID = userData["nationalID"] as? String,
                       let nmcNumber = userData["nmcNumber"] as? String {

                        let doctor = AllDoctorUser(
                            userId: userId,
                            name: name,
                            gender: gender,
                            age: age,
                            countryOfResidence: countryOfResidence,
                            city: city,
                            postCode: postCode,
                            about: about,
                            specialization: specialization,
                            clinic: clinic,
                            clinicAddress: clinicAddress,
                            workWeekFrom: workWeekFrom,
                            workWeekTo: workWeekTo,
                            nationalID: nationalID,
                            nmcNumber: nmcNumber
                        )

                        doctors.append(doctor)
                    }
                }
            }

            self.users = doctors
        }
    }
}

struct AddDoctorView: View {
    
    let scanID: String
        
        init(scanID: String) {
            self.scanID = scanID
        }

    @ObservedObject private var viewModel = AllDoctorsViewModel()

    @State private var searchElement: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @ObservedObject private var locationManagerDelegate = LocationManagerDelegate()
    @State private var locationManager = CLLocationManager()
    @State private var capsuleOffset: CGSize = .zero
    @State private var isDragging = false
    @State private var userLocationText: String = "Your Location"

    var body: some View {
        VStack {
            TextField("Search doctors", text: $searchElement)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(50.0)
                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                .padding([.leading, .trailing])

            HStack {
                Text("\(viewModel.users.count) results")
                    .font(.caption)
                Spacer()
                Text(userLocationText)
                    .font(.caption)
                    .foregroundColor(Color("PrimaryColor"))
            }
            .padding([.bottom, .trailing, .leading])

            Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                userTrackingMode: $userTrackingMode
            )
            .frame(height: 200)
            .onAppear {
                requestLocationAccess()
            }
            .onChange(of: locationManagerDelegate.lastLocation) { newLocation in
                if let newLocation = newLocation {
                    updateLocationText(location: newLocation)
                }
            }

            VStack {
                ScrollView {
                    ForEach(viewModel.users.indices, id: \.self) { i in
                        NavigationLink(
                            destination: DoctorProfileView(scanID: scanID, doctor: viewModel.users[i]),
                            label: {
                                // Your Doctor UI view here
                                // Customize as needed with doctor data
                                DoctorCard(doctorDetails: viewModel.users[i])
                                    .padding(.top)
                            }
                        )
                        .buttonStyle(PlainButtonStyle()) // To remove NavigationLink default styling
                    }
                }
            }
        }
        .navigationBarTitle("Add a Doctor", displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
    }

    private func requestLocationAccess() {
        locationManager.delegate = locationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
    }

    private func updateLocationText(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }

            if let city = placemark.locality, let country = placemark.country {
                userLocationText = "\(city), \(country)"
            }
        }
    }
}

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastLocation: CLLocation?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        manager.stopUpdatingLocation() // Stop updating location once received
    }
}

struct DoctorCard: View {
    var doctorDetails: AllDoctorUser
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 2)
                .frame(maxHeight: 125)
            HStack {
                Image(systemName: "person.fill") // Replace "doctorImage" with the actual image name
                    .font(.largeTitle)
                    .cornerRadius(8)
                    .padding([.leading, .trailing])
                    .padding([.leading, .trailing])
                
                VStack(alignment: .leading) {
                    Text(doctorDetails.name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.top)
                    Text(doctorDetails.specialization)
                        .font(.callout)
                        .foregroundColor(.gray)
                    Text(doctorDetails.clinic)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
                Spacer()
            }
        }
        .padding([.trailing, .leading])
    }
}

#Preview {
    AddDoctorView(scanID: "3434")
}
