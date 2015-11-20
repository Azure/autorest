// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Collections;
using System.Text;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
{
    public class AzureMethodTemplateModel : MethodTemplateModel
    {
        public AzureMethodTemplateModel(Method source, ServiceClient serviceClient)
            : base(source, serviceClient)
        {
            if (source == null)
            {
                throw new ArgumentNullException("source");
            }
            
            this.ClientRequestIdString = AzureExtensions.GetClientRequestIdString(source);
        }

        public bool IsPagingMethod
        {
            get
            {
                return this.Extensions.ContainsKey(AzureExtensions.PageableExtension);
            }
        }

        public string PagedResponseClassName
        {
            get
            {
                var ext = this.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;

                return (string)ext["className"];
            }
        }

        public string ClientRequestIdString { get; private set; }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureExtensions.LongRunningExtension); }
        }

        public override string RaisedException
        {
            get
            {
                if (DefaultResponse != null && DefaultResponse.Name == "CloudError")
                {
                    return "CloudException(self._deserialize, response)";
                }

                return base.RaisedException;
            }
        }

        /// <summary>
        /// Generate the method parameter declarations for a method
        /// </summary>
        /// <param name="addCustomHeaderParameters">If true add the customHeader to the parameters</param>
        /// <returns>Generated string of parameters</returns>
        public override string MethodParameterDeclaration(bool addCustomHeaderParameters)
        {
            List<string> declarations = new List<string>();
            foreach (var parameter in LocalParameters)
            {
                declarations.Add(parameter.Name);
            }

            if (addCustomHeaderParameters)
            {
                declarations.Add("custom_headers={}");
            }

            declarations.Add("raw=False");
            declarations.Add("callback=None");
            var declaration = string.Join(", ", declarations);
            return declaration;
        }
		
        /// <summary>
        /// Generate code to build the URL from a url expression and method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the url in.</param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "Microsoft.Rest.Generator.Utilities.IndentedStringBuilder.AppendLine(System.String)"), System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "pathformatarguments")]
        public override string BuildUrlPath(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            var pathParameterList = this.LogicalParameters.Where(p => p.Location == ParameterLocation.Path).ToList();
            if (pathParameterList.Any())
            {
                builder.AppendLine("path_format_arguments = {").Indent();
                //builder.AppendLine("{0} = {0}.format(", variableName).Indent();

                for (int i = 0; i < pathParameterList.Count; i ++)
                {
                    builder.AppendLine("'{0}': self._parse_url(\"{1}\", {1}, '{2}', {3}){4}",
                        pathParameterList[i].SerializedName,
                        pathParameterList[i].Name,
                        pathParameterList[i].Type.ToPythonRuntimeTypeString(),
                        pathParameterList[i].SkipUrlEncoding(),
                        i == pathParameterList.Count-1 ? "}" : ",");
                }

                builder.Outdent();
                builder.AppendLine("{0} = {0}.format(**path_format_arguments)", variableName);
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the query of URL from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the query in.</param>
        /// <returns></returns>
        public override string BuildUrlQuery(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            foreach (var queryParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Query))
            {
                builder.AppendLine("if {0} is not None:", queryParameter.Name)
                    .Indent()
                    .AppendLine("{0}['{1}'] = self._parse_url(\"{2}\", {2}, '{3}', {4})", 
                            variableName,
                            queryParameter.SerializedName, 
                            queryParameter.Name, 
                            queryParameter.Type.ToPythonRuntimeTypeString(), 
                            queryParameter.SkipUrlEncoding())
                    .Outdent();
            }

            return builder.ToString();
        }

        /// <summary>
        /// Generate code to build the headers from method parameters
        /// </summary>
        /// <param name="variableName">The variable to store the headers in.</param>
        /// <returns></returns>
        public override string BuildHeaders(string variableName)
        {
            var builder = new IndentedStringBuilder("    ");

            foreach (var headerParameter in this.LogicalParameters.Where(p => p.Location == ParameterLocation.Header))
            {
                builder.AppendLine("if {0} is not None:", headerParameter.Name)
                    .Indent()
                    .AppendLine("{0}['{1}'] = {2}", variableName,
                        headerParameter.SerializedName, headerParameter.Type.ToString(headerParameter.Name))
                    .Outdent();
            }

            return builder.ToString();
        }

        /// <summary>
        /// Gets the expression for default header setting. 
        /// </summary>
        public override string SetDefaultHeaders
        {
            get
            {
                var sb = new IndentedStringBuilder();
                sb.Append(base.SetDefaultHeaders).AppendLine("headers['{0}'] = str(uuid.uuid1())", this.ClientRequestIdString);
                return sb.ToString();
            }
        }
    }
}