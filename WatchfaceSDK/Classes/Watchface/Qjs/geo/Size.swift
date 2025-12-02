//
//  Size.swift
//  HuaWo_iOS_SDKDemo
//
//  Created by HuaWo on 2024/8/6.
//

import Foundation
public struct Size {
    public var width: Int
    public var height: Int
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    public static let zero = Size(width: 0, height: 0)
}
