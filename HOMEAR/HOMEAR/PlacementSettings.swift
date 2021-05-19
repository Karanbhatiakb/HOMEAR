//
//  PlacementSettings.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {
    
    //When the user selects a model in BrowseView, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selectedModel to \(String(describing: newValue?.name))")
        }
    }
    
    //When the user taps confirm in PlacementView, the value of selectedModel is assigned to confirmedModel
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing confirmedModel")
                return
            }
            
            print("Setting confirmedModel to \(model.name)")
            
            self.recentlyPlaced.append(model)
        }
    }
    
    //This property retains record of placed model in the scene. The last element in the array is the most recently place model.
    @Published var recentlyPlaced: [Model] = []
    
    // This property retains the cancellable object for our SceneEvents.update subscriber
    var sceneObserver: Cancellable?
}
