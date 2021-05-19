//
//  ContentView.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @EnvironmentObject var placementSettings: PlacementSettings
    @State private var isControlsVisible: Bool = true
    @State private var showBrowse: Bool = false 
    
    var body: some View {
        ZStack(alignment: .bottom) {
          
            ARViewContainer()
            
            if self.placementSettings.selectedModel == nil {
            ControlView(inControlsVisible: $isControlsVisible, showBrowser: $showBrowse)
            } else {
                PlacementView()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var placementSettings: PlacementSettings
    
    func makeUIView(context: Context) -> CustomARView{
        
        let arView = CustomARView(frame: .zero)
        
        //Subcribe  to SceneEvents.Update
        self.placementSettings.sceneObserver = arView.scene.subscribe(to: SceneEvents.Update.self, { (event) in
            
            self.updateScene(for: arView)
            
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    private func updateScene(for arView: CustomARView) {
        
        //Only display focusEntity when the user has selected a model for placement
        arView.focusEntity?.isEnabled = self.placementSettings.selectedModel != nil
        
        //Add model to scene if confirmed for placement
        if let confirmedModel = self.placementSettings.confirmedModel, let modelEntity = confirmedModel.modelEntity {
            
            self.place(modelEntity, in: arView)
            
            self.placementSettings.confirmedModel = nil
            
        }
        
    }
    
    private func place(_ modelEntity: ModelEntity, in arView: ARView) {
        
        // 1. Clone modelEntity. This creates an idential copy of modelEntity and reference the same model. This also allows us to have multiple models of the same asset in our scene.
        let cloneEntity = modelEntity.clone(recursive: true)
        
        // 2. Enable translation and rotation gestures.
        cloneEntity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation,.rotation], for: cloneEntity)
        
        // 3. Create an anchorEntity and add cloneEntity  to the anchorEntity.
        let anchorEntity = AnchorEntity(plane: .any)
        anchorEntity.addChild(cloneEntity)
        
        // 4. Add the anchorEntity to the arView.scene
        arView.scene.addAnchor(anchorEntity)
        
        print("Added modelEntity to scene")
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PlacementSettings())
    }
}
