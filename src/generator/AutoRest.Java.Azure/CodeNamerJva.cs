// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Java.Azure.Model;
using AutoRest.Java.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Java.Azure
{
    public class CodeNamerJva : CodeNamerJv
    {
        #region normalization
        
        private static string GetPagingSetting(Dictionary<string, object> extensions, IDictionary<KeyValuePair<string, string>, string> pageClasses, out string nextLinkName)
        {
            // default value
            nextLinkName = null;
            var ext = extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
            if (ext == null)
            {
                return null;
            }

            nextLinkName = (string)ext["nextLinkName"];
            string itemName = (string)ext["itemName"] ?? "value";

            var keypair = new KeyValuePair<string, string>(nextLinkName, itemName);
            if (!pageClasses.ContainsKey(keypair))
            {
                string className = (string)ext["className"];
                if (string.IsNullOrEmpty(className))
                {
                    if (pageClasses.Count > 0)
                    {
                        className = String.Format(CultureInfo.InvariantCulture, "PageImpl{0}", pageClasses.Count);
                    }
                    else
                    {
                        className = "PageImpl";
                    }
                }
                pageClasses.Add(keypair, className);
            }
            ext["className"] = pageClasses[keypair];

            return pageClasses[keypair];
        }

        // TODO: ask the cowboy - some parts rely on singular, later parts on plural!
        public override string GetMethodGroupName(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                return name;
            }
            name = PascalCase(name);
            //no pluralization yet
            return name;
        }

        #endregion
    }
}