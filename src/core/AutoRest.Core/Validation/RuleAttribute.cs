// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Core.Validation
{
    /// <summary>
    /// An attribute that describes a rule to apply to the property or class that it decorates
    /// </summary>
    [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Performance", "CA1813:AvoidUnsealedAttributes")]
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, AllowMultiple = true, Inherited = true)]
    public class RuleAttribute : Attribute
    {
        internal readonly Rule Rule;

        public RuleAttribute(Type ruleType)
        {
            if (typeof(Rule).IsAssignableFrom(ruleType))
            {
                Rule = (Rule)Activator.CreateInstance(ruleType);
            }
        }
    }
}
