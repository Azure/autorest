// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Java.Azure.Fluent.TypeModels;
using AutoRest.Java.Azure.TemplateModels;
using AutoRest.Java.TypeModels;

namespace AutoRest.Java.Azure.Fluent.TemplateModels
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