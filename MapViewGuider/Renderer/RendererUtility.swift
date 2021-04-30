//
//  RendererUtility.swift
//  MapViewGuider
//
//  Created by norains on 2021/4/30.
//  Copyright © 2021 norains. All rights reserved.
//

import Foundation

protocol RendererUtility {
    @discardableResult func switchRendererMode(rendererMode: RendererMode) -> Bool

    @discardableResult func open() -> Bool

    func close()
}

extension RendererUtility {
    func open() -> Bool {
        return true
    }

    func close() {
    }
    
    func switchRendererMode(rendererMode: RendererMode) -> Bool{
        return false
    }
}
