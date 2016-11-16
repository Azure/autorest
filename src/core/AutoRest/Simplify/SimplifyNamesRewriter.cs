// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
#pragma warning disable CS3009 // Base type is not CLS-compliant
#pragma warning disable CS3001
#pragma warning disable CS3002
 
namespace AutoRest.Simplify
{
    // From Roslyn FAQ: https://github.com/dotnet/roslyn/blob/56f605c41915317ccdb925f66974ee52282609e7/src/Samples/CSharp/APISampleUnitTests/FAQ.cs
    public class SimplifyNamesRewriter : CSharpSyntaxRewriter
    {
        private T AnnotateNodeWithSimplifyAnnotation<T>(T node) where T:SyntaxNode
        {
            return node.WithAdditionalAnnotations(Microsoft.CodeAnalysis.Simplification.Simplifier.Annotation);
        }
        
        public override SyntaxNode VisitNamespaceDeclaration(NamespaceDeclarationSyntax node)
        {
            return base.VisitNamespaceDeclaration( AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitLocalDeclarationStatement(LocalDeclarationStatementSyntax node)
        {
            return base.VisitLocalDeclarationStatement(AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitAliasQualifiedName(AliasQualifiedNameSyntax node)
        {
            // not descending into node to simplify the whole expression
            return base.VisitAliasQualifiedName( AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitQualifiedName(QualifiedNameSyntax node)
        {
            // not descending into node to simplify the whole expression
            return base.VisitQualifiedName( AnnotateNodeWithSimplifyAnnotation(node));
        }

        /// <summary>Called when the visitor visits a ConstructorDeclarationSyntax node.</summary>
        public override SyntaxNode VisitConstructorDeclaration(ConstructorDeclarationSyntax node)
        {
            return base.VisitConstructorDeclaration(AnnotateNodeWithSimplifyAnnotation(node));
        }

        /// <summary>Called when the visitor visits a AttributeSyntax node.</summary>
        public override SyntaxNode VisitAttribute(AttributeSyntax node)
        {
            return base.VisitAttribute(AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitMemberAccessExpression(MemberAccessExpressionSyntax node)
        {
            // not descending into node to simplify the whole expression
            return base.VisitMemberAccessExpression( AnnotateNodeWithSimplifyAnnotation(node));
        }

        /// <summary>Called when the visitor visits a CatchDeclarationSyntax node.</summary>
        public override SyntaxNode VisitCatchDeclaration(CatchDeclarationSyntax node)
        {
            return base.VisitCatchDeclaration(AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitIdentifierName(IdentifierNameSyntax node)
        {
            // not descending into node to simplify the whole expression
            return base.VisitIdentifierName( AnnotateNodeWithSimplifyAnnotation(node));
        }

        public override SyntaxNode VisitGenericName(GenericNameSyntax node)
        {
            // not descending into node to simplify the whole expression
            return base.VisitGenericName( AnnotateNodeWithSimplifyAnnotation(node));
        }
    }
}