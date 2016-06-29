// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using AutoRest.CSharp.TemplateModels;
using Microsoft.Rest.Generator.ClientModel;

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