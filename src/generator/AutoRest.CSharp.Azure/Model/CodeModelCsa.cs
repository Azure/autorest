// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.Linq;
using AutoRest.CSharp.Model;
using AutoRest.Extensions.Azure;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using AutoRest.Core.Utilities;
using AutoRest.Core;

namespace AutoRest.CSharp.Azure.Model
{
    public class CodeModelCsa : CodeModelCs
    {
        public IDictionary<KeyValuePair<string, string>, string> pageClasses =
            new Dictionary<KeyValuePair<string, string>, string>();

        public override bool HaveModelNamespace => base.HaveModelNamespace || pageClasses.Any();

        /// <summary>
        ///     Returns the using statements 
        /// </summary>
        public override IEnumerable<string> Usings
        {
            get
            {
                yield return "Microsoft.Rest";
                yield return "Microsoft.Rest.Azure";

                if (HaveModelNamespace)
                {
                    yield return ModelsName;
                }
            }
        }
        
        /// <summary>
        /// Attempts to infer the name of the service referenced by this CodeModel.
        /// </summary>
        [JsonIgnore]
        public string ServiceName
        {
            get
            {
                if (Settings.Instance.CustomSettings.TryGetValue("ServiceName", out object obj))
                {
                    return obj.ToString();
                }

                var method = Methods[0];
                var match = Regex.Match(input: method.Url, pattern: @"/providers/microsoft\.(\w+)/", options: RegexOptions.IgnoreCase);
                var serviceName = match.Groups[1].Value.ToPascalCase();
                return serviceName;
            }
        }
    }
}