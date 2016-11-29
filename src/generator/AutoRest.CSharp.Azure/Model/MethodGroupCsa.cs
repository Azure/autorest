// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Model
{
    public class MethodGroupCsa : MethodGroupCs
    {

        protected MethodGroupCsa() : base()
        {
            TypeName.OnGet += value =>
            {
                if (IsCodeModelMethodGroup)
                {
                    return value;
                }
                return value.Else("").Contains("Operations") ? value : value + "Operations";
            };
        }

        public MethodGroupCsa(string name)
            : base(name)
        {
        }

        /// <summary>
        /// Returns the using statements for the Operations.
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest.Azure";

                if (CodeModel.ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)) || 
                    CodeModel.HeaderTypes.Any() || 
                    (CodeModel as CodeModelCsa).pageClasses.Any())
                {
                    yield return CodeModel.ModelsName;
                }
            }
        }
    }
}