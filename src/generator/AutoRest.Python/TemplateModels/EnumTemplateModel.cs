// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.ClientModel;

namespace AutoRest.Python.TemplateModels
{
    public class EnumTemplateModel
    {
        public EnumTemplateModel(ISet<EnumType> source)
        {
            this.EnumTypes = source;
        }

        public ISet<EnumType> EnumTypes { get; private set; }
    }
}