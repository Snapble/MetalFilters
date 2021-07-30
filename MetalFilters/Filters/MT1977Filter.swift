//
//  MT1977Filter.swift
//  MetalFilters
//
//  Created by alexiscn on 2018/6/8.
//

import Foundation
import MetalPetal

public class MT1977Filter: MTFilter {

    public override class var name: String {
        return "1977"
    }

    public override var borderName: String {
        return "filterBorderPlainWhite.png"
    }

    public override var fragmentName: String {
        return "MT1977Fragment"
    }

    public override var samplers: [String : String] {
        return [
            "map": "1977map.png",
            "screen": "screen30.png",
        ]
    }

}