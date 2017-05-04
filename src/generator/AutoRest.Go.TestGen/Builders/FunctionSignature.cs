// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Generates a function signature.
    /// </summary>
    public static class FunctionSignature
    {
        /// <summary>
        /// Generates a function signature from the specified parameters.
        /// </summary>
        /// <param name="receiver">Optional signature for a receiver.</param>
        /// <param name="name">The name of the function.</param>
        /// <param name="parameters">Optional list of parameters.  Pass null if there are no parameters.</param>
        /// <param name="returns">Optional list of return values.  Pass null if there are no return values.</param>
        /// <returns>The root node in the function signature AST.</returns>
        public static Node Generate(FuncParamSig receiver, string name, IReadOnlyList<FuncParamSig> parameters, IReadOnlyList<FuncReturnSig> returns)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            var func = new Func();

            if (receiver != null)
            {
                var recvOpenParen = new OpenDelimiter(BinaryDelimiterType.Paren);
                recvOpenParen.AddChild(receiver);
                recvOpenParen.AddClosingDelimiter();
                func.AddChild(recvOpenParen);
            }

            func.AddChild(new Identifier(name));

            // build parameters
            var paramsStart = new OpenDelimiter(BinaryDelimiterType.Paren);

            if (parameters != null)
            {
                paramsStart.AddChild(DelimitedSequence.Generate(UnaryDelimiterType.Comma, parameters));
            }

            paramsStart.AddClosingDelimiter();
            func.AddChild(paramsStart);

            if (returns != null)
            {
                // multiple return values or a single return value
                // that has a name must be enclosed in parentheses
                if (returns.Count == 1)
                {
                    var ret = returns[0];
                    if (ret.IsNamed)
                    {
                        var returnOpenParen = new OpenDelimiter(BinaryDelimiterType.Paren);
                        returnOpenParen.AddChild(ret);
                        returnOpenParen.AddClosingDelimiter();
                        func.AddChild(returnOpenParen);
                    }
                    else
                    {
                        func.AddChild(ret);
                    }
                }
                else
                {
                    var returnOpenParen = new OpenDelimiter(BinaryDelimiterType.Paren);
                    returnOpenParen.AddChild(DelimitedSequence.Generate(UnaryDelimiterType.Comma, returns));
                    returnOpenParen.AddClosingDelimiter();
                    func.AddChild(returnOpenParen);
                }
            }

            return func;
        }
    }
}
