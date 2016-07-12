// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.Core.ClientModel;
using AutoRest.CSharp.TemplateModels;

namespace AutoRest.CSharp.Azure.TemplateModels
{
    public class AzureModelTemplateModel : ModelTemplateModel
    {
        public AzureModelTemplateModel(CompositeType source) : base(source)
        {
        }

        /// <summary>
        /// Returns the using statements for the model.
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest.Azure";
                foreach (string usingString in base.Usings)
                {
                    yield return usingString;
                }
            }
        }
    }
}