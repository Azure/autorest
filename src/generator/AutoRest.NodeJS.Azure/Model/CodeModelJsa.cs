// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Extensions.Azure;
using AutoRest.NodeJS.Model;
using Newtonsoft.Json;
using AutoRest.Core.Utilities;

namespace AutoRest.NodeJS.Azure.Model
{
    
    public class CodeModelJsa : CodeModelJs
    {
        public CodeModelJsa()
            : base()
        {
        }
        [JsonIgnore]
        public override bool IsAzure => true;


        [JsonIgnore]
        public override IEnumerable<CompositeTypeJs> ModelTemplateModels => ModelTypes.Cast<CompositeTypeJs>().Concat(PageTemplateModels).Where(each => !PageTemplateModels.Any(ptm => ptm.Name.EqualsIgnoreCase(each.Name)));



        public override CompositeType Add(CompositeType item)
        {
            // Removing all models that contain the extension "x-ms-external", as they will be
            // generated in nodejs client runtime for azure - "ms-rest-azure".
            if (item.Extensions.ContainsKey(AzureExtensions.PageableExtension) ||
                item.Extensions.ContainsKey(AzureExtensions.ExternalExtension))
            {
                return null;
            }

            return base.Add(item);
        }

        public IList<PageCompositeTypeJsa> PageTemplateModels { get; set; } = new List<PageCompositeTypeJsa>();

        public bool shouldOptionsInterfaceBeDeclared
        {
            get
            {
                List<string> predefinedOptionalParameters = new List<string>() { "apiVersion", "acceptLanguage", "longRunningOperationRetryTimeout", "generateClientRequestId", "rpRegistrationRetryTimeout" };
                var optionalParameters = this.Properties.Where(
                    p => (!p.IsRequired || p.IsRequired && !string.IsNullOrEmpty(p.DefaultValue)) 
                    && !p.IsConstant && !predefinedOptionalParameters.Contains(p.Name));
                return optionalParameters.Count() > 0;
            }
        }

        public override string ConstructImportTS()
        {
            IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
            if (this.MethodTemplateModels.Any())
            {
                builder.Append("import { ServiceClient, ServiceClientOptions, ServiceCallback, HttpOperationResponse, ServiceClientCredentials } from 'ms-rest';");
            }
            else
            {
                builder.Append("import { ServiceClientCredentials } from 'ms-rest';");
            }
            return builder.ToString();
        }

        public string ConstructImportTSAzure()
        {
            IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
            builder.Append("import { AzureServiceClient, AzureServiceClientOptions } from 'ms-rest-azure';");
            return builder.ToString();
        }
    }
}