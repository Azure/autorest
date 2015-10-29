// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Collections.Generic;

namespace Microsoft.Rest.Generator.Python
{
    public class EnumTemplateModel
    {
        public EnumTemplateModel(IList<EnumType> source)
        {
            this.EnumTypes = source;
        }

        public IList<EnumType> EnumTypes { get; private set; }
    }
}