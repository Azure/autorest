// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.NodeJS.Model
{
    public class ParameterJs : Parameter
    {
        public ParameterJs()
        {
            // if this is a client property, the name should be prefixed.
            Name.OnGet += value =>
                IsClientProperty
                    ? false == Method?.MethodGroup?.IsCodeModelMethodGroup
                        ? $"this.client.{ClientProperty.Name}"
                        : $"this.{ClientProperty.Name}"
                    : CodeNamer.Instance.GetParameterName(value);
        }

        [JsonIgnore]
        public IEnumerable<Core.Model.Property> ComposedProperties
        {
            get
            {
                var composite = ModelType as CompositeType;
                IEnumerable<Core.Model.Property> result = null;
                if (composite != null)
                {
                    result = composite.Properties;
                    if (composite.BaseModelType != null)
                    {
                        result = composite.Properties;
                        var baseModelProperties =
                            composite.BaseModelType.Properties.Where(p => !p.IsReadOnly);
                        result = result.Union(baseModelProperties);
                    }
                }
                return result;
            }
        }

        [JsonIgnore]
        public bool IsLocal => (!IsClientProperty) && !string.IsNullOrWhiteSpace(Name) && !IsConstant;
    }
}