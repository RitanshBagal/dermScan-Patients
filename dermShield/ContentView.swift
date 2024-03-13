//
// ContentView.swift
// dermShield
//
// Created by Abhishek Jadaun on 08/12/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
                Spacer()
                
                Image("AppLogo")
                    .padding()
                
                Image("AppLogoText")
                    .padding(.top, 5)
                    .padding([.leading, .trailing])
                    .padding(.bottom)
                    .padding(.bottom)
                    .padding(.bottom)
                
                
                Spacer()
                
                Text("One scan for healthy skin!")
                    .foregroundColor(Color("PrimaryColor"))
                    .padding(.top, 8)
                 
                NavigationLink(
                    destination: OnBoardingScreen(),
                    isActive: $isActive
                ) {
                    EmptyView()
                }
                .navigationBarTitle("Main Screen", displayMode: .inline)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
                .background(
                    Text("Your App Content")
                )
                .navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
