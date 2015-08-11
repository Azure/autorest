// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java
{
    public class EnumTemplateModel : EnumType
    {
        public EnumTemplateModel(EnumType source)
        {
            this.LoadFrom(source);
        }
    }
}