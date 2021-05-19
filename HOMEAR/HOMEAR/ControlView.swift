//
//  ControlView.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI

struct ControlView: View {
    @Binding var inControlsVisible: Bool
    @Binding var showBrowser: Bool

    var body: some View {
        VStack {
            
            ControlVisibilityToggleButton(inControlsVisible: $inControlsVisible)
            
            Spacer()
            
            if inControlsVisible {
                ControlButtonBar(showBrowser: $showBrowser)
            }
        }
    }
}

struct ControlVisibilityToggleButton: View {
    @Binding var inControlsVisible: Bool

    
    var body: some View{
        HStack {
            
            Spacer()
            
            ZStack{
                
                Color.black.opacity(0.25)
                
                Button(action: {print("Control visibility Toggle Button pressed")
                    self.inControlsVisible.toggle()
                }) {
                Image(systemName: self.inControlsVisible ? "rectangle" : "slider.horizontal.below.rectangle")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .frame(width: 50, height: 50)
            .cornerRadius(8.0)
        }
        .padding(.top,45)
        .padding(.trailing, 20)
    }
}

struct ControlButtonBar: View{
    @EnvironmentObject var placementSettings: PlacementSettings
    @Binding var showBrowser: Bool
    
    var body :  some View {
        HStack{
            
            //MostRecentlyPlaced Button
            MostRecentlyPlaceButton().hidden(self.placementSettings.recentlyPlaced.isEmpty)
           
            Spacer()
            
           //Browse Button
            ControlButton(systemIconName: "square.grid.2x2") {
                print("Browse button pressed.")
                self.showBrowser.toggle()
            }.sheet(isPresented: $showBrowser, content: {
                //BrowseView
                BrowseView(showBrowse: $showBrowser)
            })
            
            Spacer()
            
            //Setting Button
            ControlButton(systemIconName: "slider.horizontal.3") {
                print("Settings button prressed.")
            }
            
        }
        .frame(maxWidth: 500)
        .padding(30)
        .background(Color.black.opacity(0.25))
    }
}

struct ControlButton: View {
    let systemIconName: String
    let action: () ->Void
        
    var body: some View {
        
        Button(action: {self.action()
        }) {
        Image(systemName: systemIconName)
                .font(.system(size: 35))
                .foregroundColor(.white)
                .buttonStyle(PlainButtonStyle())
        }
            .frame(width: 50, height: 50)
    }
}

struct MostRecentlyPlaceButton : View{
    
    @EnvironmentObject var placementSettings:PlacementSettings
    
    var body: some View{
        Button(action:{
            print("Most Recently Placed button pressed.")
            self.placementSettings.selectedModel = self.placementSettings.recentlyPlaced.last
        }){
            if let mostRecentlyPlacedModel = self.placementSettings.recentlyPlaced.last{
                Image(uiImage: mostRecentlyPlacedModel.thumbnails)
                    .resizable()
                    .frame(width:46)
                    .aspectRatio(1/1,contentMode: .fit)
            }else{
                Image(systemName: "clock.fill")
                    .font(.system(size: 35))
                    .foregroundColor(.white)
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(width: 50, height:50)
        .background(Color.white)
        .cornerRadius(8.0)
    }
}
