// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Ruby;

namespace Microsoft.Rest.Generator.Azure.Ruby
{
    /// <summary>
    /// The model for Azure model template.
    /// </summary>
    public class AzureModelTemplateModel : ModelTemplateModel
    {
        /// <summary>
        /// Initializes a new instance of the AzureModelTemplateModel class.
        /// </summary>
        /// <param name="source">The object to create model from.</param>
        /// <param name="serviceClient">The service client.</param>
        public AzureModelTemplateModel(CompositeType source, ServiceClient serviceClient) : base(source, serviceClient)
        {
        }

        /// <summary>
        /// Returns code for declaring inheritance.
        /// </summary>
        /// <returns>Code for declaring inheritance.</returns>
        public override string GetBaseTypeName()
        {
            if (this.BaseModelType != null)
            {
                string typeName = this.BaseModelType.Name;

                if (this.BaseModelType.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension))
                {
                    typeName = "MsRestAzure::" + typeName;
                }

                return " < " + typeName;
            }

            return string.Empty;
        }

        public override string SerializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            var composite = type as CompositeType;

            if (composite != null && composite.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension))
            {
                defaultNamespace = "MsRestAzure";
            }

            return base.SerializeProperty(variableName, type, isRequired, defaultNamespace);
        }

        public override string DeserializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            var composite = type as CompositeType;

            if (composite != null && composite.Extensions.ContainsKey(AzureCodeGenerator.ExternalExtension))
            {
                defaultNamespace = "MsRestAzure";
            }

            return base.DeserializeProperty(variableName, type, isRequired, defaultNamespace);
        }
    }
}