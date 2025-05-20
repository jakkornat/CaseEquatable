//
//  main.swift
//  CaseEquatable
//
//  Created by Jakub Kornatowski on 2025-05-20.
//  Copyright © 2025 Jakub Kornatowski. All rights reserved.
//
//  Licensed under The MIT Open Source License.
//

import CaseEquatable
import Foundation

// MARK: - Raw `CaseEquatable` protocol conformance

enum MyEnum2: Equatable {
    case one(Int)
    case two(String)
    case tree
}

extension MyEnum2: CaseEquatable {
    enum RawCase {
        case one
        case two
        case tree
    }

    static func == (lhs: MyEnum2, rhs: RawCase) -> Bool {
        switch lhs {
        case .one: rhs == .one
        case .two: rhs == .two
        case .tree: rhs == .tree
        }
    }
    
    static func != (lhs: MyEnum2, rhs: RawCase) -> Bool {
        !(lhs == rhs)
    }
}

let foo = MyEnum2.tree
assert(foo != .one)
assert(foo != .one(1))
assert(foo != .one(3))
assert(foo != .two)
assert(foo != .two("foo"))
assert(foo == .tree)

// MARK: - `@CaseEquatable` macro usage

@CaseEquatable
enum MyEnum: Equatable {
    case one(Int)
    case two(String)
    case tree
}

let foo2 = MyEnum2.tree
assert(foo2 != .one)
assert(foo2 != .one(1))
assert(foo2 != .one(3))
assert(foo2 != .two)
assert(foo2 != .two("foo"))
assert(foo2 == .tree)
