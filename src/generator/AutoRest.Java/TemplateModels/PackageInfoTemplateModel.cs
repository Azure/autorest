// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TemplateModels
{
    public class PackageInfoTemplateModel : ServiceClient
    {
        public string Title { get; private set; }
        public string Description { get; private set; }
        public string SubPackage { get; private set; }

        public PackageInfoTemplateModel(ServiceClient serviceClient, string clientName, string subPackage = null)
        {
            this.LoadFrom(serviceClient);
            this.Title = clientName;
            if (serviceClient != null)
            {
                this.Description = serviceClient.Documentation;
            }
            this.SubPackage = subPackage;
        }
    }
}