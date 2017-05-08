// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Represents a function call parameter.
    /// </summary>
    public struct FuncCallParam
    {
        /// <summary>
        /// The parameter.
        /// </summary>
        public Node Param;

        /// <summary>
        /// How the parameter is to be passed.
        /// </summary>
        public TypeModifier Pass;

        /// <summary>
        /// Initializes FuncCallParam with the specified values.
        /// </summary>
        /// <param name="param">The paramater to pass.</param>
        /// <param name="pass">How the parameter should be passed.</param>
        public FuncCallParam(Node param, TypeModifier pass)
        {
            Param = param;
            Pass = pass;
        }
    }

    /// <summary>
    /// Generates a function call.
    /// </summary>
    public static class FunctionCall
    {
        /// <summary>
        /// Generates a function call for the specified values.
        /// Example: package.Func(one, &two, three)
        /// </summary>
        /// <param name="name">The fully qualified name of the function to call.</param>
        /// <param name="parameters">The optional list of parameters.  Pass null if there are no parameters.</param>
        /// <returns>The root node for this function call AST.</returns>
        public static Node Generate(string name, IReadOnlyList<FuncCallParam> parameters)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            if (parameters != null && parameters.Count == 0)
            {
                throw new ArgumentException("pass null if there are no arguments");
            }

            var funcCall = new Identifier(name);

            var paramsStart = new OpenDelimiter(BinaryDelimiterType.Paren);
            funcCall.AddChild(paramsStart);

            if (parameters != null)
            {
                var seq = new Node[parameters.Count];

                // build a comma separated list of params
                for (int i = 0; i < parameters.Count; ++i)
                {
                    var param = parameters[i];

                    Node p = null;
                    if (param.Pass == TypeModifier.ByReference)
                    {
                        p = UnaryOpSequence.Generate(UnaryOperatorType.Ampersand, param.Param);
                    }
                    else if (param.Pass == TypeModifier.ByValue)
                    {
                        p = param.Param;
                    }

                    seq[i] = p;
                }

                paramsStart.AddChild(DelimitedSequence.Generate(UnaryDelimiterType.Comma, seq));
            }

            paramsStart.AddClosingDelimiter();

            return funcCall;
        }
    }
}
