// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Go
{
    public class MethodScopeProvider
    {
        /// <summary>
        /// The collection of all unique method names.
        /// </summary>
        private readonly HashSet<string> _allMethods = new HashSet<string>();

        /// <summary>
        /// Placeholder for method scope - this ensures that methods names are unique within the client
        /// </summary>
        private readonly HashSet<string> _scopedMethods = new HashSet<string>();

        /// <summary>
        /// The collection of method groups which had at least one method name collide with another grouped or ungrouped method.
        /// </summary>
        private readonly HashSet<string> _collisionGroups = new HashSet<string>();

        public void AddMethods(IEnumerable<string> methodNames)
        {
            _allMethods.UnionWith(methodNames);
        }

        public void AddGroupedMethods(IEnumerable<string> methodNames, string methodGroupName)
        {
            if (methodNames.Any(m => _allMethods.Contains(m)))
            {
                _collisionGroups.Add(methodGroupName);
            }
            _allMethods.UnionWith(methodNames);
        }

        /// <summary>
        /// Get a method name that is unique in this method's scope. If the method is part of a method group containing at least one method
        /// that conflicts with another method, attach the group name to the method. Then, as needed, append a numeric suffix to ensure uniqueness.
        /// </summary>
        /// <param name="prefix">The method prefix</param>
        /// <param name="group">The method group</param>
        /// <param name="suffix">The suffux added to the variable - a simple counter is used to generate new method names</param>
        /// <returns>A method name unique in this scope</returns>
        public string GetMethodName(string prefix, string group, int suffix = 0)
        {
            string name = prefix;

            if (_collisionGroups.Contains(group))
            {
                name += group;
            }
            
            if (suffix > 0)
            {
                name += suffix;
            }
            
            if (_scopedMethods.Add(name))
            {
                return name;
            }

            return GetMethodName(prefix, group, ++suffix);
        }
    }
}
