// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class PackageInfoTemplateModel
    {
        public string Title { get; private set; }
        public string Description { get; private set; }
        public string SubPackage { get; private set; }

        public PackageInfoTemplateModel(CodeModel cm, string subPackage = null)
        {
            Title = cm.Name;
            Description = cm.Documentation;
            SubPackage = subPackage;
        }
    }
}