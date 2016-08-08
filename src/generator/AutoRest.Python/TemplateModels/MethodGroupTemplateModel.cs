// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.TemplateModels
{
    public class MethodGroupTemplateModel : ServiceClient
    {
        public MethodGroupTemplateModel(ServiceClient serviceClient, string methodGroupName)
        {
            this.LoadFrom(serviceClient);
            ConstantProperties = new List<Property>();
            MethodTemplateModels = new List<MethodTemplateModel>();
            // MethodGroup name and type are always the same but can be 
            // changed in derived classes
            MethodGroupName = methodGroupName;
            MethodGroupType = methodGroupName + "Operations";
            Methods.Where(m => m.Group == MethodGroupName)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));

            var allParameters = MethodTemplateModels.SelectMany(x => x.Parameters).Where(p => p.IsConstant && p.ClientProperty == null).ToList();
            foreach (var parameter in allParameters)
            {
                var conflicts = allParameters.Where(p => p.Name == parameter.Name && p.DefaultValue != parameter.DefaultValue);
                if (conflicts.Any())
                {
                    continue;
                }
                else 
                {
                    if (!ConstantProperties.Any(p => p.Name == parameter.Name))
                    {
                        var constantProperty = new Property
                        {
                            Name = parameter.Name,
                            DefaultValue = parameter.DefaultValue,
                            IsConstant = parameter.IsConstant,
                            IsRequired = parameter.IsRequired,
                            Documentation = parameter.Documentation,
                            SerializedName = parameter.SerializedName,
                            Type = parameter.Type
                        };
                        ConstantProperties.Add(constantProperty);
                    }
                    if (!parameter.Name.StartsWith("self."))
                        parameter.Name = "self." + parameter.Name;
                }
            }
        }

        public virtual bool HasAnyModel
        {
            get
            {
                if (this.ModelTypes.Any())
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }

        public bool HasAnyDefaultExceptions
        {
            get { return this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null); }
        }

        public List<Property> ConstantProperties { get; private set; }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public string MethodGroupName { get; set; }

        public string MethodGroupType { get; set; }

        /// <summary>
        /// Provides the modelProperty documentation string along with default value if any.
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter documentation string along with default value if any 
        /// in correct jsdoc notation</returns>
        public string GetPropertyDocumentationString(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }
            string propertyName = property.Name.Split('.').Last();
            string docString = string.Format(CultureInfo.InvariantCulture, ":ivar {0}:", propertyName);

            string summary = property.Summary;
            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (property.DefaultValue != PythonConstants.None)
            {
                if (documentation != null && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
                {
                    documentation += ".";
                }
                documentation += " Constant value: " + property.DefaultValue + ".";
            }

            if (!string.IsNullOrWhiteSpace(summary))
            {
                docString += " " + summary;
            }

            if (!string.IsNullOrWhiteSpace(documentation))
            {
                docString += " " + documentation;
            }
            return docString;
        }
    }
}