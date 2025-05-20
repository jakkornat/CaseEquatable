//
//  CaseEquatable.swift
//  CaseEquatable
//
//  Created by Jakub Kornatowski on 2025-05-20.
//  Copyright © 2025 Jakub Kornatowski. All rights reserved.
//
//  Licensed under The MIT Open Source License.
//

import Foundation

/// Automatically generates a raw Case-only enum and
/// makes the original enum conform to `CaseEquatable`,
/// so you can compare only the case name—ignoring any
/// associated values.
///
/// When you annotate an enum with `@CaseEquatable`, the macro:
/// 1. Synthesizes a nested `RawCase` enum with one case for each
///    original case, but without associated values.
/// 2. Adds a `CaseEquatable` conformance:
///    - Defines `typealias RawCase = <EnumName>.RawCase`
///    - Implements `static func ==(lhs: Self, rhs: RawCase) -> Bool`
///      by matching on `lhs`’s case and comparing it to `rhs`.
///
///
/// # Manual Expansion Example
///
/// Given an enum:
///
/// ```swift
/// enum MyEnum2: Equatable {
///     case one(Int)
///     case two(String)
///     case three
/// }
/// ```
///
/// The macro would generate the equivalent of:
///
/// ```swift
/// extension MyEnum2: CaseEquatable {
///     enum RawCase {
///         case one
///         case two
///         case three
///     }
///
///     static func == (lhs: MyEnum2, rhs: RawCase) -> Bool {
///         switch lhs {
///         case .one:  return rhs == .one
///         case .two:  return rhs == .two
///         case .three: return rhs == .three
///         }
///     }
/// }
/// ```
///
/// Now you can compare only the case names:
///
/// ```swift
/// let foo = MyEnum2.three
/// print(foo == .one)         // false
/// print(foo == .one(1))      // false (falls back to comparing .one raw case)
/// print(foo == .one(3))      // false
/// print(foo == .two)         // false
/// print(foo == .two("aaa"))  // false
/// print(foo == .three)        // true
/// ```
///
/// # Macro Usage
///
/// Simply put `@CaseEquatable` before your enum declaration:
///
/// ```swift
/// @CaseEquatable
/// enum MyEnum: Equatable {
///     case one(Int)
///     case two(String)
///     case three
/// }
///
/// let foo2 = MyEnum.three
/// print(foo2 == .one)        // false
/// print(foo2 == .one(1))     // false
/// print(foo2 == .one(3))     // false
/// print(foo2 == .two)        // false
/// print(foo2 == .two("aaa")) // false
/// print(foo2 == .three)      // true
/// ```
///
/// # Requirements
/// - Swift 5.9+
/// - Annotated type must be an enum.
///
/// # Limitations
/// - Only top-level enum cases are supported; nested enums are not processed.
/// - `RawCase` is generated in the same scope as the original enum.


public protocol CaseEquatable {
    /// An enum listing only the case names (no payloads)
    associatedtype RawCase
    
    /// Compare the full enum value to one of its raw cases
    static func == (_ lhs: Self, _ rhs: Self.RawCase) -> Bool
}

@attached(extension, conformances: CaseEquatable, names: arbitrary)
public macro CaseEquatable() = #externalMacro(
    module: "CaseEquatableMacros",
    type: "CaseEquatableMacro"
)
