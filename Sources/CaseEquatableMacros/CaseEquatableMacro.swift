//
//  CaseEquatableMacro.swift
//  CaseEquatable
//
//  Created by Jakub Kornatowski on 2025-05-20.
//  Copyright © 2025 Jakub Kornatowski. All rights reserved.
//
//  Licensed under The MIT Open Source License.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CaseEquatableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext)
    throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            throw MacroExpansionErrorMessage(
                "The GenerateCaseNames macro can only be applied to enums."
            )
        }
        let caseNames: [String] = enumDeclaration
            .memberBlock
            .members
            .compactMap { member in
                if let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) {
                    return caseDecl.elements.map { $0.name.text }
                }
                return nil
            }
            .flatMap(\.self)
        
        let caseNamesComparison = caseNames
            .map { "case .\($0): rhs == .\($0)" }
            .joined(separator: "\n")
        
        let caseNamesArray = caseNames
            .map { "case \($0)" }
            .joined(separator: "\n")
        
        let functionSyntax = """
        extension \(enumDeclaration.name): CaseEquatable {
            enum RawCase {
                \(caseNamesArray)
            }

            static func == (lhs: \(enumDeclaration.name), rhs: RawCase) -> Bool {
                switch lhs {
                \(caseNamesComparison)
                }
            }
        
            static func != (lhs: \(enumDeclaration.name), rhs: RawCase) -> Bool {
                !(lhs == rhs)
            }
        }
        """
        return [
            try ExtensionDeclSyntax(SyntaxNodeString(stringLiteral: functionSyntax))
        ]
    }
}

@main
struct CaseEquatablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CaseEquatableMacro.self
    ]
}
