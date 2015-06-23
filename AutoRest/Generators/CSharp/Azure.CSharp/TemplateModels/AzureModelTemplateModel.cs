// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;

namespace Microsoft.Rest.Generator.CSharp.Azure
{
    public class AzureModelTemplateModel : ModelTemplateModel
    {
        private readonly IScopeProvider _scope = new ScopeProvider();

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
                yield return "Microsoft.Azure";
                foreach (string usingString in base.Usings)
                {
                    yield return usingString;
                }
            }
        }
    }
}