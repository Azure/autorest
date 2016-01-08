// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator.NodeJS
{
    public class ParameterTemplateModel : Parameter
    {
        public ParameterTemplateModel(Parameter source)
        {
            this.LoadFrom(source);
        }

        public IEnumerable<Property> ComposedProperties
        {
            get
            {
                CompositeType composite = this.Type as CompositeType;
                IEnumerable<Property> result = composite.Properties;
                if (composite != null && composite.BaseModelType != null)
                {
                    IEnumerable<Property> baseModelProperties =
                        composite.BaseModelType.Properties.Where(p => !p.IsReadOnly);
                    result = result.Union(baseModelProperties);
                }
                return result;
            }
        }
    }
}