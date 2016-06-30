// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.TemplateModels;

namespace AutoRest.Ruby.Azure.TemplateModels
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
        /// <param name="allTypes">The list of all model types; Used to implement polymorphism.</param>
        public AzureModelTemplateModel(CompositeType source, ISet<CompositeType> allTypes)
            : base(source, allTypes)
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

                if (this.BaseModelType.Extensions.ContainsKey(AzureExtensions.ExternalExtension) ||
                    this.BaseModelType.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension))
                {
                    typeName = "MsRestAzure::" + typeName;
                }

                return " < " + typeName;
            }

            return string.Empty;
        }

        /// <summary>
        /// Gets the list of modules/classes which need to be included.
        /// </summary>
        public override List<string> Includes
        {
            get
            {
                return new List<string>
                {
                    "MsRestAzure"
                };
            }
        }

        public override List<string> ClassNamespaces
        {
            get
            {
                return new List<string>
                {
                    "MsRestAzure"
                };
            }
        }
    }
}