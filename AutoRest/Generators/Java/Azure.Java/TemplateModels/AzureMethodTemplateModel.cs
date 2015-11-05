// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Azure;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.Azure.Properties;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.Java.Azure
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

            this.ClientRequestIdString = AzureCodeGenerator.GetClientRequestIdString(source);
            this.RequestIdString = AzureCodeGenerator.GetRequestIdString(source);
        }

        public string ClientRequestIdString { get; private set; }

        public string RequestIdString { get; private set; }

        public AzureMethodTemplateModel GetMethod
        {
            get
            {
                var getMethod = ServiceClient.Methods.FirstOrDefault(m => m.Url == Url
                                                                          && m.HttpMethod == HttpMethod.Get &&
                                                                          m.Group == Group);
                if (getMethod == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture,
                        Resources.InvalidLongRunningOperationForCreateOrUpdate,
                            Name, Group));
                }
                return new AzureMethodTemplateModel(getMethod, ServiceClient);
            }
        }

        /// <summary>
        /// Returns true if method has x-ms-long-running-operation extension.
        /// </summary>
        public bool IsLongRunningOperation
        {
            get { return Extensions.ContainsKey(AzureCodeGenerator.LongRunningExtension); }
        }

        public bool IsPagingNextOperation
        {
            get { return Url == "{nextLink}"; }
        }

        public override string MethodParameterApiDeclaration
        {
            get
            {
                var declaration = base.MethodParameterApiDeclaration;
                if (IsPagingNextOperation)
                {
                    declaration = declaration.Replace("@Path(\"nextLink\")", "@Url");
                }
                return declaration;
            }
        }

        public string Exceptions
        {
            get
            {
                List<string> exceptions = new List<string>();
                exceptions.Add("ServiceException");
                if (this.IsLongRunningOperation)
                {
                    exceptions.Add("IOException");
                    exceptions.Add("InterruptedException");
                }
                return string.Join(", ", exceptions);
            }
        }

        public List<string> ExceptionStatements
        {
            get
            {
                List<string> exceptions = new List<string>();
                exceptions.Add("ServiceException exception thrown from REST call");
                if (this.IsLongRunningOperation)
                {
                    exceptions.Add("IOException exception thrown from serialization/deserialization");
                    exceptions.Add("InterruptedException exception thrown when long running operation is interrupted");
                }
                return exceptions;
            }
        }

        public string PollingMethod
        {
            get
            {
                if (this.HttpMethod == HttpMethod.Put || this.HttpMethod == HttpMethod.Patch)
                {
                    return "getPutOrPatchResult";
                }
                else if (this.HttpMethod == HttpMethod.Delete || this.HttpMethod == HttpMethod.Post)
                {
                    return "getPostOrDeleteResult";
                }
                throw new InvalidOperationException("Invalid long running operation HTTP method " + this.HttpMethod);
            }
        }
        public override string ServiceResponseBuilderArgs
        {
            get
            {
                return "new AzureJacksonHelper()";
            }
        }

        public override List<string> InterfaceImports
        {
            get
            {
                var imports = base.InterfaceImports;
                this.Exceptions.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex => imports.Add(JavaCodeNamer.GetJavaException(ex)));
                if (IsPagingNextOperation)
                {
                    imports.Remove("retrofit.http.Path");
                    imports.Add("retrofit.http.Url");
                }
                return imports;
            }
        }

        public override List<string> ImplImports
        {
            get
            {
                var imports = base.ImplImports;
                this.Exceptions.Split(new string[] { ", " }, StringSplitOptions.RemoveEmptyEntries)
                    .ForEach(ex => imports.Add(JavaCodeNamer.GetJavaException(ex)));
                if (this.IsLongRunningOperation)
                {
                    imports.Remove("com.microsoft.rest.ServiceResponseEmptyCallback");
                    imports.Remove("com.microsoft.rest.ServiceResponseCallback");
                    imports.Remove("com.microsoft.rest.ServiceResponseBuilder");
                    imports.Add("retrofit.Callback");
                    this.Responses.Select(r => r.Value).Concat(new IType[]{ DefaultResponse })
                        .SelectMany(t => t.ImportFrom(ServiceClient.Namespace))
                        .Where(i => !this.Parameters.Any(p => p.Type.ImportFrom(ServiceClient.Namespace).Contains(i)))
                        .ForEach(i => imports.Remove(i));
                }
                else
                {
                    imports.Add("com.microsoft.rest.serializer.AzureJacksonHelper");
                }
                return imports;
            }
        }
    }
}