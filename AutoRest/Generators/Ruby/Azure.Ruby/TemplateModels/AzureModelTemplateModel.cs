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

        /// <summary>
        /// Serializes given property.
        /// </summary>
        /// <param name="variableName">Variable name that keeps the property.</param>
        /// <param name="type">Type of property.</param>
        /// <param name="isRequired">Is required or not (affects whether null check is performed).</param>
        /// <param name="defaultNamespace">The namespace.</param>
        /// <returns>Code for serialization.</returns>
        public override string SerializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            AzureClientModelExtensions.UpdateNamespaceIfRequired(type, ref defaultNamespace);
            return base.SerializeProperty(variableName, type, isRequired, defaultNamespace);
        }

        /// <summary>
        /// Deserializes given property.
        /// </summary>
        /// <param name="variableName">Variable name that keeps the property.</param>
        /// <param name="type">Type of property.</param>
        /// <param name="isRequired">Is required or not (affects whether null check is performed).</param>
        /// <param name="defaultNamespace">The namespace.</param>
        /// <returns>Code for deserialization.</returns>
        public override string DeserializeProperty(string variableName, IType type, bool isRequired, string defaultNamespace)
        {
            AzureClientModelExtensions.UpdateNamespaceIfRequired(type, ref defaultNamespace);
            return base.DeserializeProperty(variableName, type, isRequired, defaultNamespace);
        }
    }
}