// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Generator.NodeJS;
using Microsoft.Rest.Generator.Azure.NodeJS.Properties;

namespace Microsoft.Rest.Generator.Azure.NodeJS
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureCodeGenerator.LongRunningExtension); }
        }

        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        public override string BuildUrl(string variableName)
        {
            var builder = new IndentedStringBuilder("  ");

            if (this.Url != null && this.Url.Contains("{subscriptionId}")
                && !ParameterTemplateModels.Any(p => p.SerializedName.Equals("subscriptionId", StringComparison.OrdinalIgnoreCase)))
            {
                builder
                    .AppendLine("{0} = {0}.replace('{{subscriptionId}}', encodeURIComponent({1}.credentials.subscriptionId));",
                            variableName,
                            ClientReference);
            }

            foreach (var pathParameter in ParameterTemplateModels.Where(p => p.Location == ParameterLocation.Path))
            {
                string replaceString = "{0} = {0}.replace('{{{1}}}', encodeURIComponent({2}));";
                if (pathParameter.Extensions.ContainsKey(AzureCodeGenerator.SkipUrlEncodingExtension))
                {
                    replaceString = "{0} = {0}.replace('{{{1}}}', {2});";
                }

                builder.AppendLine(replaceString,
                    variableName,
                    pathParameter.Name,
                    pathParameter.Type.ToString(pathParameter.Name));
            }

            builder.AppendLine("var queryParameters = [];");
            if (ParameterTemplateModels.Any(p => p.Location == ParameterLocation.Query))
            {
                foreach (var queryParameter in ParameterTemplateModels
                    .Where(p => p.Location == ParameterLocation.Query))
                {
                    builder.AppendLine("if ({0} !== null && {0} !== undefined) {{", queryParameter.Name)
                        .Indent()
                        .AppendLine("queryParameters.push('{0}=' + encodeURIComponent({1}));",
                            queryParameter.SerializedName, queryParameter.GetFormattedReferenceValue()).Outdent()
                        .AppendLine("}");
                }
            }

            if (!Parameters.Any(p => p.Name.Equals("apiVersion", StringComparison.OrdinalIgnoreCase)) &&
                !IsAbsoluteUrl)
            {
                builder.AppendLine(
                    "queryParameters.push('api-version=' + encodeURIComponent({0}.apiVersion));",
                    ClientReference);
            }

            builder.AppendLine("if (queryParameters.length > 0) {")
                .Indent()
                .AppendLine("{0} += '?' + queryParameters.join('&');", variableName).Outdent()
                .AppendLine("}");  

            return builder.ToString();
        }

        /// <summary>
        /// Long running put request poller method
        /// </summary>
        public AzureMethodTemplateModel GetMethod
        {
            get
            {
                var getMethod = ServiceClient.Methods.FirstOrDefault(m => m.Url == Url
                                                                          && m.HttpMethod == HttpMethod.Get &&
                                                                          m.Group == Group);
                if (getMethod == null)
                {
                    throw new InvalidOperationException(Resources.InvalidLongRunningOperationForCreateOrUpdate);
                }
                return new AzureMethodTemplateModel(getMethod, ServiceClient);
            }
        }

        /// <summary>
        /// Gets the expression for response body initialization 
        /// </summary>
        public override string InitializeResponseBody
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Head &&
                    this.ReturnType != null)
                {
                    return "result.body = (statusCode === 204);";
                }
                return base.InitializeResponseBody;
            }
        }
    }
}