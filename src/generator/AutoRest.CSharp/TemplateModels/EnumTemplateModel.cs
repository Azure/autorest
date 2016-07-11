// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.CSharp.TemplateModels
{
    public class EnumTemplateModel : EnumType
    {
        public EnumTemplateModel(EnumType source)
        {
            this.LoadFrom(source);
        }
        /// <summary>
        /// Trim the Trailing '?' from the Type Name so that it 
        /// does not occur in the type definition
        /// </summary>
        public string TypeDefinitionName
        {
            get
            {
                return this.Name.TrimEnd('?');
            }
        }
    }
}