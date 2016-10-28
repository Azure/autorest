// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python.Model
{
    public class MethodGroupPy : MethodGroup
    {
        public MethodGroupPy()
        {
            Initialize();
        }
        public MethodGroupPy(string name) : base(name)
        {
            Initialize();
        }

        private void Initialize()
        {
            TypeName.OnGet +=  value => (value??"").EndsWith("Operations") ? value :  $"{value}Operations";
            
        }
        public virtual bool HasAnyModel => CodeModel.ModelTypes.Any();

        public bool HasAnyDefaultExceptions => this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null);

        public IEnumerable<PropertyPy> ConstantProperties { get; internal set; }

#if yuck
        public IEnumerable<PropertyPy> ConstantProperties
        {
            get
            {
                var uniq = new HashSet<string>();
                var allParameters = MethodTemplateModels.SelectMany(x => x.Parameters)
                        .Where(p => p.IsConstant && !p.IsClientProperty).ToArray();

                foreach (var parameter in allParameters)
                {
                    if (allParameters.Any(p => p.Name == parameter.Name && p.DefaultValue != parameter.DefaultValue))
                    {
                        continue;
                    }

                    if (!uniq.Contains(parameter.Name.RawValue))
                    {
                        uniq.Add(parameter.Name.RawValue);
                        yield return New<PropertyPy>(new
                        {
                            Name = parameter.Name.RawValue,
                            DefaultValue = parameter.DefaultValue.RawValue,
                            IsConstant = true,
                            IsRequired = parameter.IsRequired,
                            Documentation = parameter.Documentation,
                            SerializedName = parameter.SerializedName.RawValue,
                            ModelType = parameter.ModelType,
                            IsSpecialConstant = true
                        });
                    }
                }
            }
        }
#endif

        public IEnumerable<MethodPy> MethodTemplateModels => Methods.Cast<MethodPy>();

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
                throw new ArgumentNullException(nameof(property));
            }
            string propertyName = ((string)property.Name).Split('.').Last();
            string docString = string.Format(CultureInfo.InvariantCulture, ":ivar {0}:", propertyName);

            string summary = property.Summary;
            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (!property.DefaultValue.RawValue.IsNullOrEmpty() )
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