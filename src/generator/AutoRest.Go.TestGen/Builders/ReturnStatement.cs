// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating return statements.
    /// </summary>
    public static class ReturnStatement
    {
        /// <summary>
        /// Generates a return statement with optional list of variables.
        /// </summary>
        /// <param name="varNames">Optional list of variables to be returned.  Pass null if there are no variables to return.</param>
        /// <returns>Root node in this return statement AST.</returns>
        public static Node Generate(IReadOnlyList<string> varNames)
        {
            if (varNames != null && varNames.Count == 0)
            {
                throw new ArgumentException("pass null for no arguments to return");
            }

            var ret = new Return();

            if (varNames != null)
            {
                Node[] returnVars = new Node[varNames.Count];
                for (int i = 0; i < returnVars.Length; ++i)
                {
                    returnVars[i] = new Identifier(varNames[i]);
                }

                ret.AddChild(DelimitedSequence.Generate(UnaryDelimiterType.Comma, returnVars));
            }

            return ret;
        }
    }
}
