// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.Model;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// The model for Azure model template.
    /// </summary>
    public class CompositeTypeRba : CompositeTypeRb
    {
        /// <summary>
        /// Initializes a new instance of the AzureModelTemplateModel class.
        /// </summary>
        /// <param name="source">The object to create model from.</param>
        /// <param name="allTypes">The list of all model types; Used to implement polymorphism.</param>
        /// <summary>
        /// Initializes a new instance of the ModelTemplateModel class.
        /// </summary>
        protected CompositeTypeRba()
        {
        }

        protected CompositeTypeRba(string name): base(name)
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
        public override IEnumerable<string> Includes
        {
            get { yield return "MsRestAzure"; }
        }

        public override IEnumerable<string> ClassNamespaces
        {
            get { yield return "MsRestAzure"; }
        }
    }
}