// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using AutoRest.Extensions.Azure;
using AutoRest.Ruby.Model;
using AutoRest.Core.Model;
using System.Text.RegularExpressions;

namespace AutoRest.Ruby.Azure.Model
{
    /// <summary>
    /// The model for Azure model template.
    /// </summary>
    public class CompositeTypeRba : CompositeTypeRb
    {
        public static readonly Regex nameRegEx         = new Regex(@"^(RESOURCE|SUBRESOURCE)$", RegexOptions.IgnoreCase);
        private static readonly Regex subResourceRegEx = new Regex(@"^(ID)$", RegexOptions.IgnoreCase);
        private static readonly Regex resourceRegEx    = new Regex(@"^(ID|NAME|TYPE|LOCATION|TAGS)$", RegexOptions.IgnoreCase);

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
                    if(!nameRegEx.IsMatch(typeName) || !IsResourceModelsMatchStandardDefinition(this))
                    {
                        typeName = "MsRestAzure::" + typeName;
                    }
                }

                return " < " + typeName;
            }
            else if (nameRegEx.IsMatch(this.Name.ToString()))
            {
                return " < " + "MsRestAzure::" + this.Name.ToString();
            }

            return string.Empty;
        }

        public static bool IsResourceModelsMatchStandardDefinition(CompositeType model)
        {
            string modelName = model.Name.ToString();
            if (
                (modelName.Equals("SubResource", StringComparison.InvariantCultureIgnoreCase) &&
                    model.Properties.All(property => subResourceRegEx.IsMatch(property.Name.ToString()))) ||
                (modelName.Equals("Resource", StringComparison.InvariantCultureIgnoreCase) &&
                    model.Properties.All(property => resourceRegEx.IsMatch(property.Name.ToString())))
               )
            {
                return true;
            }
            return false;
        }

        public static bool ShouldAccessorGenerated(CompositeType model, string propertyName)
        {
            string modelName = model.Name.ToString();
            if((modelName.Equals("SubResource", StringComparison.InvariantCultureIgnoreCase) && subResourceRegEx.IsMatch(propertyName)) ||
               (modelName.Equals("Resource", StringComparison.InvariantCultureIgnoreCase) && resourceRegEx.IsMatch(propertyName)))
            {
                return false;
            }
            return true;
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