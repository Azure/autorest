// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;

namespace AutoRest.Go.TestGen
{
    /// <summary>
    /// Contains extension methods for formating Literal of T objects.
    /// </summary>
    public static class LiteralExtensions
    {
        /// <summary>
        /// Returns a formatted string for the specified literal based on its generic type.
        /// </summary>
        /// <typeparam name="T">Generic type parameter.</typeparam>
        /// <param name="literal">The literal value to be converted.</param>
        /// <returns>A string containing the value of the literal.</returns>
        public static string Format<T>(this Literal<T> literal)
        {
            if (literal is Literal<bool>)
            {
                // default bool.ToString() returns True/False which we don't want
                bool val = bool.Parse(literal.Value.ToString());
                return val ? "true" : "false";
            }
            else if (literal is Literal<string>)
            {
                return $"\"{literal}\"";
            }
            else if (literal is Literal<DateTime>)
            {
                var dt = DateTime.Parse(literal.ToString());
                // return in RFC3339 format
                return $"\"{dt.ToString("yyyy-MM-dd'T'HH:mm:ssZzzz")}\"";
            }

            return literal.ToString();
        }
    }
}
