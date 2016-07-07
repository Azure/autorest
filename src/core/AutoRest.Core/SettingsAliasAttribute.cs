// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core
{
    /// <summary>
    /// Attribute used for extending parameters with aliases.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property, AllowMultiple = true)]
    public sealed class SettingsAliasAttribute : Attribute
    {
        /// <summary>
        /// Initializes a new instance of SettingsAliasAttribute.
        /// </summary>
        public SettingsAliasAttribute()
        {}

        /// <summary>
        /// Initializes a new instance of SettingsAliasAttribute with an alias.
        /// </summary>
        /// <param name="alias">The alias for the setting.</param>
        public SettingsAliasAttribute(string alias)
        {
            Alias = alias;
        }

        public string Alias { get; private set; }
    }
}