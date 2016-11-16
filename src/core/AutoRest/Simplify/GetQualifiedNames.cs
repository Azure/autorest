// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
#pragma warning disable CS3009 // Base type is not CLS-compliant
#pragma warning disable CS3001
#pragma warning disable CS3002

namespace AutoRest.Simplify
{
    public class GetQualifiedNames : CSharpSyntaxRewriter
    {
        private HashSet<string> _leftSideOfNames = new HashSet<string>();
        private HashSet<string> _fullNames = new HashSet<string>();

        public IEnumerable<string> GetNames(SyntaxNode node)
        {
            _leftSideOfNames = new HashSet<string>();
            _fullNames = new HashSet<string>();
            Visit(node);
            return _leftSideOfNames.Where(each => _fullNames.Contains(each)).ToArray();
        }

        public override SyntaxNode VisitQualifiedName(QualifiedNameSyntax node)
        {
            _leftSideOfNames.Add(node.Left.ToString());
            _fullNames.Add(node.ToString());
            return base.VisitQualifiedName(node);
        }
    }
}