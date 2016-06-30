// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace AutoRest.Java
{
    public class ScopeProvider : IScopeProvider
    {
        // HashSet to track variable names that have been used in a scope.
        private readonly HashSet<string> _variables = new HashSet<string>();

        /// <summary>
        /// Get a variable name that is unique in this scope.
        /// </summary>
        /// <param name="prefix">Prefix to use in creating variable.</param>
        /// <returns>A variable name unique in this scope.</returns>
        public string GetVariableName(string prefix)
        {
            if (_variables.Add(prefix))
            {
                return prefix;
            }

            return GetAlternateVariableName(prefix, 1);
        }

        private string GetAlternateVariableName(string prefix, int suffix)
        {
            string name = prefix + suffix;
            if (_variables.Add(name))
            {
                return name;
            }

            return GetAlternateVariableName(prefix, ++suffix);
        }
    }
}