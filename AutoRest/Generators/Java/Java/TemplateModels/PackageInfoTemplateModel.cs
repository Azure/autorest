// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class PackageInfoTemplateModel : ServiceClient
    {
        public string Title { get; private set; }
        public string Description { get; private set; }
        public bool IsModel { get; private set; }

        public PackageInfoTemplateModel(ServiceClient serviceClient, string clientName, bool isModel = false)
        {
            this.LoadFrom(serviceClient);
            this.Title = clientName;
            if (serviceClient != null)
            {
                this.Description = serviceClient.Documentation;
            }
            this.IsModel = isModel;
        }
    }
}