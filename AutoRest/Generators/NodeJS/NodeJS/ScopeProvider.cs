// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class ScopeProvider : IScopeProvider
    {
        // HashSet to track variable names that have been used in a scope.
        private readonly HashSet<string> _variables = new HashSet<string>();

        /// <summary>
        /// Get a variable name that is unique in this scope.
        /// </summary>
        /// <param name="prefix">Prefix to use in creating variable.</param>
        /// <param name="suffix">An integer counter to use as a variable suffix.</param>
        /// <returns>A variable name unique in this scope.</returns>
        public string GetVariableName(string prefix, int suffix = 0)
        {
            string name = (suffix > 0) ? prefix + suffix : prefix;
            if (_variables.Add(name))
            {
                return name;
            }

            return GetVariableName(prefix, ++suffix);
        }
    }
}