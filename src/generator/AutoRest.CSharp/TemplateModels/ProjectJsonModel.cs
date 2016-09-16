// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class ProjectJsonModel
    {
        public string Version { get; set; }

        public string Description { get; set; }

        public string ClientRuntimeVersion { get; set; }

        public ProjectJsonModel(string packageVersion, string packageDescription, string runtimeVersion)
        {
            this.Version = packageVersion;
            this.Description = packageDescription;
            this.ClientRuntimeVersion = runtimeVersion;
        }
    }
}