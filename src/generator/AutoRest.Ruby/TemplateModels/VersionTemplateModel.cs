// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace AutoRest.Ruby.TemplateModels
{
    /// <summary>
    /// The model for the service client template.
    /// </summary>
    public class VersionTemplateModel
    {
        /// <summary>
        /// The package version of the Ruby Package
        /// </summary>
        protected string version;
        
        /// <summary>
        /// Initializes a new instance of VersionClientTemplateModel class.
        /// </summary>
        /// <param name="version"></param>
        public VersionTemplateModel(string version)
        {
            this.version = version;
        }

        /// <summary>
        /// Gets the package version of the Ruby Package
        /// </summary>
        public string Version { get { return this.version; } }
    }
}