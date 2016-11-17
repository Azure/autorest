// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure.Model
{
    public class CodeModelCsa : CodeModelCs
    {
        public IDictionary<KeyValuePair<string, string>, string> pageClasses =
            new Dictionary<KeyValuePair<string, string>, string>();

        /// <summary>
        ///     Returns the using statements 
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest";
                yield return "Microsoft.Rest.Azure";

                if (ModelTypes.Any(m => !m.Extensions.ContainsKey(AzureExtensions.ExternalExtension)) ||
                    pageClasses.Any())
                {
                    yield return ModelsName;
                }
            }
        }
    }
}