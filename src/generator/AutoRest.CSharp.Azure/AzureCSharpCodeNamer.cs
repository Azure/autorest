// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;

namespace AutoRest.CSharp.Azure
{
    public class AzureCSharpCodeNamer : CSharpCodeNamer
    {
        /// <summary>
        /// Skips name collision resolution for method groups (operations) as they get
        /// renamed in template models.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="exclusionDictionary"></param>
        protected override void ResolveMethodGroupNameCollision(ServiceClient serviceClient,
            Dictionary<string, string> exclusionDictionary)
        {
            // Do nothing
        }

        public AzureCSharpCodeNamer(Settings settings)
        {
            if (settings != null && settings.CustomSettings != null)
            {
                foreach (var setting in settings.CustomSettings.Keys)
                {
                    if (setting.Equals("useDateTimeOffset", StringComparison.OrdinalIgnoreCase))
                    {
                        bool toUse;
                        if (bool.TryParse(settings.CustomSettings[setting].ToString(), out toUse))
                        {
                            UseDateTimeOffset = toUse;
                        }
                        else
                        {
                            UseDateTimeOffset = false;
                        }
                    }
                }
            }
        }

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
                        className = String.Format(CultureInfo.InvariantCulture, "Page{0}", pageClasses.Count);
                    }
                    else
                    {
                        className = "Page";
                    }
                }
                pageClasses.Add(keypair, className);
            }

            return pageClasses[keypair];
        }

        protected override IType NormalizePrimaryType(PrimaryType primaryType)
        {
            if (primaryType != null && primaryType.Type == KnownPrimaryType.Credentials)
            {
                primaryType.Name = "Microsoft.Rest.ServiceClientCredentials";
                return primaryType;
            }
            else
            {
                return base.NormalizePrimaryType(primaryType);
            }
        }

        public virtual void NormalizeODataMethods(ServiceClient client)
        {
            if (client == null)
            {
                throw new ArgumentNullException("client");
            }

            foreach (var method in client.Methods)
            {
                if (method.Extensions.ContainsKey(AzureExtensions.ODataExtension))
                {
                    var odataFilter = method.Parameters.FirstOrDefault(p =>
                        p.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
                        p.Location == ParameterLocation.Query &&
                        p.Type is CompositeType);

                    if (odataFilter == null)
                    {
                        continue;
                    }

                    // Remove all odata parameters
                    method.Parameters.RemoveAll(source =>
                        (source.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) ||
                        source.SerializedName.Equals("$top", StringComparison.OrdinalIgnoreCase) ||
                        source.SerializedName.Equals("$orderby", StringComparison.OrdinalIgnoreCase) ||
                        source.SerializedName.Equals("$skip", StringComparison.OrdinalIgnoreCase) ||
                        source.SerializedName.Equals("$expand", StringComparison.OrdinalIgnoreCase))
                        && source.Location == ParameterLocation.Query);

                    var odataQuery = new Parameter
                    {
                        SerializedName = "$filter",
                        Name = "odataQuery",
                        Type = new CompositeType
                        {
                            Name = string.Format(CultureInfo.InvariantCulture, "Microsoft.Rest.Azure.OData.ODataQuery<{0}>", odataFilter.Type.Name)
                        },
                        Documentation = "OData parameters to apply to the operation.",
                        Location = ParameterLocation.Query,
                        IsRequired = odataFilter.IsRequired
                    };
                    odataQuery.Extensions[AzureExtensions.ODataExtension] = method.Extensions[AzureExtensions.ODataExtension];
                    method.Parameters.Insert(0, odataQuery);
                }
            }
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="pageClasses"></param>
        public virtual void NormalizePaginatedMethods(ServiceClient serviceClient, IDictionary<KeyValuePair<string, string>, string> pageClasses)
        {
            if (serviceClient == null)
            {
                throw new ArgumentNullException("serviceClient");
            }

            var convertedTypes = new Dictionary<IType, CompositeType>();

            foreach (var method in serviceClient.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkString;
                string pageClassName = GetPagingSetting(method.Extensions, pageClasses, out nextLinkString);
                if (string.IsNullOrEmpty(pageClassName))
                {
                    continue;
                }
                var pageTypeFormat = "{0}<{1}>";
                var ipageTypeFormat = "Microsoft.Rest.Azure.IPage<{0}>";
                if (string.IsNullOrWhiteSpace(nextLinkString))
                {
                    ipageTypeFormat = "System.Collections.Generic.IEnumerable<{0}>";
                }
                

                foreach (var responseStatus in method.Responses
                    .Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType) method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.Type).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if(sequenceType != null)
                    {
                        var pagableTypeName = string.Format(CultureInfo.InvariantCulture, pageTypeFormat, pageClassName, sequenceType.ElementType.Name);
                        var ipagableTypeName = string.Format(CultureInfo.InvariantCulture, ipageTypeFormat, sequenceType.ElementType.Name);

                        CompositeType pagedResult = new CompositeType
                        {
                            Name = pagableTypeName
                        };
                        pagedResult.Extensions[AzureExtensions.ExternalExtension] = true;
                        pagedResult.Extensions[AzureExtensions.PageableExtension] = ipagableTypeName;

                        convertedTypes[method.Responses[responseStatus].Body] = pagedResult;
                        method.Responses[responseStatus] = new Response(pagedResult, method.Responses[responseStatus].Headers);
                    }
                }

                if (convertedTypes.ContainsKey(method.ReturnType.Body))
                {
                    method.ReturnType = new Response(convertedTypes[method.ReturnType.Body], 
                        method.ReturnType.Headers);
                }
            }

            SwaggerExtensions.RemoveUnreferencedTypes(serviceClient, new HashSet<string>(convertedTypes.Keys.Cast<CompositeType>().Select(t => t.Name)));
        }
    }
}
