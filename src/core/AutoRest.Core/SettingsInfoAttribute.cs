// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Core
{
    /// <summary>
    /// Helper attribute used for documentation generation in AutoRest command line interface.
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public sealed class SettingsInfoAttribute : Attribute
    {
        /// <summary>
        /// Initializes a new instance of SettingsInfoAttribute with documentation and required flag.
        /// </summary>
        /// <param name="documentation">Documentation body.</param>
        /// <param name="isRequired">If set indicates that the property is a required command
        /// line argument.</param>
        public SettingsInfoAttribute(string documentation, bool isRequired = false)
        {
            Documentation = documentation;
            IsRequired = isRequired;
        }

        /// <summary>
        /// Documentation text of the settings property.
        /// </summary>
        public string Documentation { get; }

        /// <summary>
        /// True if property is required, false otherwise.
        /// </summary>
        public bool IsRequired { get; }
    }
}