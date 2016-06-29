// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.Azure;

namespace Microsoft.Rest.Generator.Java.Azure.Fluent
{
    public class AzureFluentModelTemplateModel : AzureModelTemplateModel
    {
        private AzureJavaFluentCodeNamer _namer;

        public AzureFluentModelTemplateModel(CompositeType source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            _namer = new AzureJavaFluentCodeNamer(serviceClient.Namespace);
            PropertyModels = new List<PropertyModel>();
            Properties.ForEach(p => PropertyModels.Add(new FluentPropertyModel(p, serviceClient.Namespace, IsInnerModel)));
        }

        protected override JavaCodeNamer Namer
        {
            get
            {
                return _namer;
            }
        }

        public override string ModelsPackage
        {
            get
            {
                if (this.IsInnerModel)
                {
                    return ".implementation";
                }
                else
                {
                    return "";
                }
            }
        }

        public bool IsInnerModel
        {
            get
            {
                return this.Name.EndsWith("Inner", StringComparison.Ordinal);
            }
        }
    }
}