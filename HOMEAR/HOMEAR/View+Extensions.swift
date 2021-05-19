//
//  View+Extensions.swift
//  HOMEAR
//
//  Created by Karan Bhatia on 16/05/21.
//

import SwiftUI

extension View{
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View{
        switch shouldHide {
        case true:self.hidden()
        case false: self
        }
    }
    
}
