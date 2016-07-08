// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

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