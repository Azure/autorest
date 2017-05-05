// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Indicates how a non-nil error object should be handled.
    /// </summary>
    public enum OnError
    {
        /// <summary>
        /// Call panic(err).
        /// </summary>
        Panic,

        /// <summary>
        /// Return err.
        /// </summary>
        ReturnError
    }

    /// <summary>
    /// Used for generating typical error checking constructs.
    /// </summary>
    public static class ErrorCheck
    {
        /// <summary>
        /// Generates a standard error checking sequence.
        /// E.g. if err != nil return err
        /// </summary>
        /// <param name="errorVar">The name of the error variable.</param>
        /// <param name="onError">How the error should be handled.</param>
        /// <returns>The root node of this error checking AST.</returns>
        public static Node Generate(string errorVar, OnError onError)
        {
            if (string.IsNullOrWhiteSpace(errorVar))
            {
                throw new ArgumentException(nameof(errorVar));
            }

            Node handler = null;
            switch (onError)
            {
                case OnError.Panic:
                    handler = FunctionCall.Generate("panic", new[]
                    {
                        new FuncCallParam(new Identifier(errorVar), TypeModifier.ByValue)
                    });
                    break;

                case OnError.ReturnError:
                    var ret = new Return();
                    ret.AddChild(new Identifier(errorVar));
                    handler = ret;
                    break;

                default:
                    throw new NotImplementedException($"OnError state {onError} NYI");
            }

            var node = IfBlock.Generate(BinaryOpSequence.Generate(BinaryOperatorType.NotEqualTo, new Identifier(errorVar), new Nil()), new[]
            {
                handler
            });

            return node;
        }

        /// <summary>
        /// Generates a standard error checking sequence.
        /// E.g. if err != nil return var1, var2, varN
        /// </summary>
        /// <param name="errorVar">The name of the error variable.</param>
        /// <param name="toReturn">
        /// List of variables to return.  All variables in
        /// this list will be returned in the specified order.
        /// </param>
        /// <returns>The root node of this error checking AST.</returns>
        public static Node Generate(string errorVar, IReadOnlyList<Node> toReturn)
        {
            var ret = new Return();
            ret.AddChild(DelimitedSequence.Generate(UnaryDelimiterType.Comma, toReturn));

            var node = IfBlock.Generate(BinaryOpSequence.Generate(BinaryOperatorType.NotEqualTo, new Identifier(errorVar), new Nil()), new[]
            {
                ret
            });

            return node;
        }
    }
}
