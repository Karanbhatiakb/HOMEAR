//
//  Model.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
    case table
    case chair
    case sofa
    case decore
    case light
    
    var label: String {
        get {
            switch self {
            case.table:
                return "Tables"
            case.chair:
                return "Chairs"
            case.sofa:
                return "Sofa"
            case.decore:
                return "Decore"
            case.light:
                return "Lights"
            }
        }
    }
}


class Model {
    var name: String
    var category: ModelCategory
    var thumbnails: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnails = UIImage(named: name) ?? UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
    }
    
    func asyncLoadModelEntity() {
        let filename = self.name + ".usdz"
        
        self.cancellable = ModelEntity.loadModelAsync(named: filename)
            .sink(receiveCompletion: { loadCompletion in
                
                switch loadCompletion {
                case .failure(let error):print("Unable to load modelEntity for \(filename).Error: \(error.localizedDescription)")
                case .finished:
                    break
                }
                
            }, receiveValue: { modelEntity in
                
                self.modelEntity = modelEntity
                self.modelEntity?.scale *= self.scaleCompensation
                
                print("modelEntity for \(self.name) has been loaded.")
                
            })
    }
}

struct Models {
    var all: [Model] = []
    
    init () {
        // Table
        let diningTable = Model(name: "dining_table", category: .table, scaleCompensation: 30.5/100)
        let Roundglasstable = Model(name: "Round_glass_table", category: .table, scaleCompensation: 12.5/100)
        
        self.all += [diningTable, Roundglasstable]
        
        //Chairs
        let diningChair = Model(name: "dining_chair", category: .chair, scaleCompensation: 50/100)
        let eamesChairWhite = Model(name: "eames_chair_white", category: .chair, scaleCompensation: 50/100)
        let eamesChairWoodgrain = Model(name: "eames_chair_woodgrain", category: .chair, scaleCompensation: 50/100)
        let BasketSwingChair = Model(name: "Basket_Swing_Chair", category: .chair, scaleCompensation: 50/100)
        let DublinChair = Model(name: "Dublin_Chair", category: .chair, scaleCompensation: 37/100)
        
        self.all += [diningChair, eamesChairWhite, eamesChairWoodgrain, BasketSwingChair, DublinChair]
        
        //Sofa
        let simplesofa = Model(name: "simple_sofa", category: .sofa, scaleCompensation: 78/100)
        let BlackLeatherSofa = Model(name: "black_leather_sofa", category: .sofa, scaleCompensation: 78/100)
        let PaintedStyleModern_Sofa = Model(name: "Painted_Style_Modern_Sofa", category: .sofa, scaleCompensation: 0.22/100)
        let LongSofa = Model(name: "long_sofa", category: .sofa, scaleCompensation: 18/100)
        
        self.all += [simplesofa, BlackLeatherSofa, PaintedStyleModern_Sofa, LongSofa]
        
        //Decor
        let cupSaucerSet = Model(name: "cup_saucer_set", category: .decore, scaleCompensation: 2.9/100)
        let plateSetDark = Model(name: "plate_set_dark", category: .decore, scaleCompensation: 2.4/100)
        let plateSetLight = Model(name: "plate_set_light", category: .decore, scaleCompensation: 2.4/100)
        let flowerTulip = Model(name: "flower_tulip", category: .decore, scaleCompensation: 13.0/100)
        let pottedFloorPlant = Model(name: "potted_floor_plant", category: .decore, scaleCompensation: 10/100)
        let teaPot = Model(name: "teaPot", category: .decore, scaleCompensation: 5.0/100)// Model is to scale but scaleCompensation for aesthetic reason (wanted the plant a little smaller)
        
        self.all += [cupSaucerSet, plateSetDark, plateSetLight, flowerTulip,pottedFloorPlant, teaPot]
        
        // Lights
        let floorLampClassic = Model(name: "floor_lamp_classic", category: .light, scaleCompensation: 0.70)
        let floorLampModern = Model(name: "floor_lamp_modern", category: .light, scaleCompensation: 0.30)
        
        self.all += [floorLampClassic, floorLampModern]
    }
    
    func get(category: ModelCategory) -> [Model] {
        return all.filter( {$0.category == category} )
    }
}
