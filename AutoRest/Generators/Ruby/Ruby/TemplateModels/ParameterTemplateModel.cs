// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Ruby
{
    public class ParameterTemplateModel : Parameter
    {
        public ParameterTemplateModel(Parameter source)
        {
            this.LoadFrom(source);
        }

        public string ToStringExpression { get; set; }
    }
}