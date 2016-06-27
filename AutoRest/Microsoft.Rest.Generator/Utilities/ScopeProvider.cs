// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.Utilities
{
    /// <summary>
    /// Provides scope for variable names.
    /// </summary>
    public class ScopeProvider : IScopeProvider
    {
        /// <summary>
        /// Placeholder for variable scope - this ensures that variables names are unique within the method
        /// </summary>
        private readonly HashSet<string> _variables = new HashSet<string>();

        /// <summary>
        /// Get a unique variable name in the current scope
        /// </summary>
        /// <param name="variableName">The variable name</param>
        /// <returns>A variable name unique in this method</returns>
        public string GetUniqueName(string variableName)
        {
            if (_variables.Add(variableName))
            {
                return variableName;
            }

            return GetAlternateVariableName(variableName, 1);
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