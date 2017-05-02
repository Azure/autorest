// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.Model
{
    public class ParameterPy : Parameter
    {
        public ParameterPy()
        {
            Name.OnGet += value =>
            {
                if (!value.StartsWith("self."))
                {
                    // api_version is always at the first level, operation group or client
                    // if it's a client property (could be a method property)
                    if (value == "api_version" && IsClientProperty)
                    {
                        return $"self.{value}";
                    }

                    if (IsClientProperty)
                    {
                        return $"self.config.{value}";
                    }
                }
                return value;
            };

            DefaultValue.OnGet += value => CodeNamer.Instance.EscapeDefaultValue(DefaultValue.RawValue, ModelType);
        }

        /// <summary>
        /// Gets parameter declaration
        /// </summary>
        public virtual string DeclarationExpression => ModelTypeName;

        public IEnumerable<Property> ComposedProperties
        {
            get
            {
                var composite = ModelType as CompositeType;
                return composite?.BaseModelType != null ? 
                    composite.Properties.Union(composite.BaseModelType.Properties.Where(p => !p.IsReadOnly)) : 
                    composite?.Properties;
            }
        }
    }
}