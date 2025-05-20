import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(CaseEquatableMacros)
import CaseEquatableMacros

fileprivate let testMacros: [String: Macro.Type] = [
    "CaseEquatable": CaseEquatableMacro.self,
]
#endif

final class CaseEquatableTests: XCTestCase {
    func testMacro() throws {
        #if canImport(CaseEquatableMacros)
        let source = """
        @CaseEquatable
        enum MyEnum: Equatable {
            case one(Int)
            case two(String)
            case three
        }
        """
        
        let expected = """
        enum MyEnum: Equatable {
            case one(Int)
            case two(String)
            case three
        }
        
        extension MyEnum: CaseEquatable {
            enum RawCase {
                case one
                case two
                case three
            }
        
            static func == (lhs: MyEnum, rhs: RawCase) -> Bool {
                switch lhs {
                case .one:
                    rhs == .one
                case .two:
                    rhs == .two
                case .three:
                    rhs == .three
                }
            }
        
            static func != (lhs: MyEnum, rhs: RawCase) -> Bool {
                !(lhs == rhs)
            }
        }
        """
        assertMacroExpansion(
            source,
            expandedSource: expected,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testEnumWithoutAssociatedValues() throws {
        #if canImport(CaseEquatableMacros)
        let source = """
        @CaseEquatable
        enum Simple: Equatable {
            case a
            case b
            case c
        }
        """

        let expected = """
        enum Simple: Equatable {
            case a
            case b
            case c
        }

        extension Simple: CaseEquatable {
            enum RawCase {
                case a
                case b
                case c
            }

            static func == (lhs: Simple, rhs: RawCase) -> Bool {
                switch lhs {
                case .a:
                    rhs == .a
                case .b:
                    rhs == .b
                case .c:
                    rhs == .c
                }
            }
        
            static func != (lhs: Simple, rhs: RawCase) -> Bool {
                !(lhs == rhs)
            }
        }
        """

        assertMacroExpansion(
            source,
            expandedSource: expected,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMixedAssociatedAndPlainCases() throws {
        #if canImport(CaseEquatableMacros)
        let source = """
        @CaseEquatable
        enum Mixed: Equatable {
            case x, y(Double)
            case z(Int, String)
            case plain
        }
        """

        let expected = """
        enum Mixed: Equatable {
            case x, y(Double)
            case z(Int, String)
            case plain
        }

        extension Mixed: CaseEquatable {
            enum RawCase {
                case x
                case y
                case z
                case plain
            }

            static func == (lhs: Mixed, rhs: RawCase) -> Bool {
                switch lhs {
                case .x:
                    rhs == .x
                case .y:
                    rhs == .y
                case .z:
                    rhs == .z
                case .plain:
                    rhs == .plain
                }
            }
        
            static func != (lhs: Mixed, rhs: RawCase) -> Bool {
                !(lhs == rhs)
            }
        }
        """

        assertMacroExpansion(
            source,
            expandedSource: expected,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
