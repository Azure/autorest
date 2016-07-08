// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Java.TemplateModels
{
    public class EnumTemplateModel : EnumType
    {
        public EnumTemplateModel(EnumType source)
        {
            this.LoadFrom(source);
        }

        public virtual string ModelsPackage
        {
            get
            {
                return ".models";
            }
        }
    }
}