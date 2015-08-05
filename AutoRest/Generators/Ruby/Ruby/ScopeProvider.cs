// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The scope provider.
    /// </summary>
    public class ScopeProvider : IScopeProvider
    {
        /// <summary>
        /// Placeholder for variable scope - this ensures that variables names are unique within the method
        /// </summary>
        private readonly HashSet<string> _variables = new HashSet<string>();

        /// <summary>
        /// Get a variable name that is unique in this method's scope
        /// </summary>
        /// <param name="prefix">The variable prefix</param>
        /// <param name="suffix">The suffux added to the variable - a simple counter is used to generate new variable names</param>
        /// <returns>A variable name unique in this method</returns>
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