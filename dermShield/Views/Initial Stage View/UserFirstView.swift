//
//  UserFirstView.swift
//  dermShield
//
//  Created by Abhishek Jadaun on 10/12/23.
//

import SwiftUI

struct UserFirstView: View {
    
    var body: some View {
        TabView() {
            DiscoverView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Explore")
                }
            
            CaseView()
                .tabItem {
                    Image(systemName: "mail.stack.fill")
                    Text("Cases")
                }
            
            ScanView()
                .tabItem {
                    Image(systemName: "mail.and.text.magnifyingglass")
                        .font(.title)
                    Text("Diagnose")
                }
            
            MessageView()
                .tabItem {
                    Image(systemName: "envelope.badge.shield.half.filled")
                    Text("dermChat")
                }
        }
        .accentColor(Color("PrimaryColor"))
        .navigationBarHidden(true)
    }
}

#Preview {
    UserFirstView()
}
