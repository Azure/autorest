// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.Ruby
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