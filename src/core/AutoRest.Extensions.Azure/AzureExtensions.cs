// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Extensions.Azure.Model;
using AutoRest.Extensions.Azure.Properties;
using AutoRest.Swagger;
using AutoRest.Swagger.Model;
using Newtonsoft.Json;
using ParameterLocation = AutoRest.Core.Model.ParameterLocation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Extensions.Azure
{
    /// <summary>
    /// Base code generator for Azure.
    /// Normalizes the ServiceClient according to Azure conventions and Swagger extensions.
    /// </summary>
    public abstract class AzureExtensions : SwaggerExtensions
    {
        public const string LongRunningExtension = "x-ms-long-running-operation";
        public const string PageableExtension = "x-ms-pageable";
        public const string AzureResourceExtension = "x-ms-azure-resource";
        public const string ODataExtension = "x-ms-odata";
        public const string ClientRequestIdExtension = "x-ms-client-request-id";
        public const string ExternalExtension = "x-ms-external";

        //TODO: Ideally this would be the same extension as the ClientRequestIdExtension and have it specified on the response headers,
        //TODO: But the response headers aren't currently used at all so we put an extension on the operation for now
        public const string RequestIdExtension = "x-ms-request-id";
        public const string ApiVersion = "api-version";
        public const string AcceptLanguage = "accept-language";
        
        private const string ResourceType = "Resource";
        private const string SubResourceType = "SubResource";
        private const string ResourceProperties = "Properties";

        /// <summary>
        /// Defines the possible set of valid HTTP status codes for HEAD requests.
        /// </summary>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Security", "CA2104:DoNotDeclareReadOnlyMutableReferenceTypes")]
        public static readonly Func<HttpStatusCode, bool> HttpHeadStatusCodeSuccessFunc = code => (int)code >= 200 && (int)code < 300;

        /// <summary>
        /// Normalizes client model using Azure-specific extensions.
        /// </summary>
        /// <param name="codeModelient">Service client</param>
        /// <param name="settings">AutoRest settings</param>
        /// <param name="codeNamer">AutoRest settings</param>
        /// <returns></returns>
        public static void NormalizeAzureClientModel(CodeModel codeModel)
        {
            var settings = Settings.Instance;
            using (NewContext)
            {
                settings = new Settings().LoadFrom(settings);
                settings.AddCredentials = true;

                if (codeModel == null)
                {
                    throw new ArgumentNullException("codeModel");
                }
               

                // This extension from general extensions must be run prior to Azure specific extensions.
                ProcessParameterizedHost(codeModel);

                ProcessClientRequestIdExtension(codeModel);
                UpdateHeadMethods(codeModel);
                ParseODataExtension(codeModel);
                ProcessGlobalParameters(codeModel);
                FlattenModels(codeModel);
                FlattenMethodParameters(codeModel);
                ParameterGroupExtensionHelper.AddParameterGroups(codeModel);
                AddLongRunningOperations(codeModel);
                AddAzureProperties(codeModel);
                SetDefaultResponses(codeModel);
                AddPageableMethod(codeModel);
            }
        }

        /// <summary>
        /// Changes head method return type.
        /// </summary>
        /// <param name="codeModelient">Service client</param>
        public static void UpdateHeadMethods(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var method in codeModel.Methods.Where(m => m.HttpMethod == HttpMethod.Head)
                                                              .Where(m => m.ReturnType.Body == null))
            {
                HttpStatusCode successStatusCode = method.Responses.Keys.FirstOrDefault(AzureExtensions.HttpHeadStatusCodeSuccessFunc);

                if (method.Responses.Count == 2 &&
                    successStatusCode != default(HttpStatusCode) &&
                    method.Responses.ContainsKey(HttpStatusCode.NotFound))
                {
                    method.ReturnType = new Response(New<PrimaryType>(KnownPrimaryType.Boolean), method.ReturnType.Headers);
                }
                else
                {
                    Logger.LogInfo(string.Format(CultureInfo.InvariantCulture, Resources.HeadMethodPossibleIncorrectSpecification, method.Name));
                }
            }
        }

        /// <summary>
        /// Set default response to CloudError if not defined explicitly.
        /// </summary>
        /// <param name="codeModelient"></param>
        public static void SetDefaultResponses(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            // Create CloudError if not already defined
            CompositeType cloudError = codeModel.ModelTypes.FirstOrDefault(c =>
                c.Name.EqualsIgnoreCase("cloudError"));
            if (cloudError == null)
            {
                cloudError = New<CompositeType>( new
                {
                    Name = "cloudError",
                    SerializedName = "cloudError"
                });
                cloudError.Extensions[ExternalExtension] = true;
                codeModel.Add(cloudError);
            }
            // Set default response if not defined explicitly
            foreach (var method in codeModel.Methods)
            {
                if (method.DefaultResponse.Body == null && method.ReturnType.Body != null)
                {
                    method.DefaultResponse = new Response(cloudError, method.ReturnType.Headers);
                }                
            }
        }

        /// <summary>
        /// Converts Azure Parameters to regular parameters.
        /// </summary>
        /// <param name="codeModelient">Service client</param>
        public static void ParseODataExtension(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var method in codeModel.Methods.Where(m => m.Extensions.ContainsKey(ODataExtension)))
            {
                string odataModelPath = (string) method.Extensions[ODataExtension];
                if (odataModelPath == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataEmpty, ODataExtension));
                }

                odataModelPath = odataModelPath.StripDefinitionPath();

                CompositeType odataType = codeModel.ModelTypes
                    .FirstOrDefault(t => t.Name.EqualsIgnoreCase(odataModelPath));

                if (odataType == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataInvalidReferance, ODataExtension));
                }
                var filterParameter = method.Parameters
                    .FirstOrDefault(p => p.Location == ParameterLocation.Query &&
                                         p.Name.FixedValue == "$filter");
                if (filterParameter == null)
                {
                    throw new InvalidOperationException(
                        string.Format(CultureInfo.InvariantCulture, 
                        Resources.ODataFilterMissing, ODataExtension));
                }

                filterParameter.ModelType = odataType;
            }
        }

        /// <summary>
        /// Creates long running operation methods.
        /// </summary>
        /// <param name="codeModelient"></param>
        public static void AddLongRunningOperations(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach( var method in codeModel.Methods.Where( each => each.Extensions.ContainsKey(LongRunningExtension)).Distinct( each  => each.Group + each.Name ).ToArray())
            {
                var isLongRunning = method.Extensions[LongRunningExtension];
                if (true == isLongRunning as bool?)
                {
                    // copy the method 
                    var m = Duplicate(method);

                    // change the name, remove the extension.
                    m.Name = "Begin" + m.Name.ToPascalCase();
                    m.Extensions.Remove(LongRunningExtension);

                    codeModel.Add(m);

                }
            }
        }

        /// <summary>
        /// Creates azure specific properties.
        /// </summary>
        /// <param name="codeModelient"></param>
        public static void AddAzureProperties(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            var apiVersion = codeModel.Properties
                .FirstOrDefault(p => ApiVersion.EqualsIgnoreCase(p.SerializedName));
            if (apiVersion != null)
            {
                apiVersion.DefaultValue = codeModel.ApiVersion;
                apiVersion.IsReadOnly = true;
                apiVersion.IsRequired = false;
            }

            var subscriptionId =
                codeModel.Properties.FirstOrDefault(
                    p => p.Name.EqualsIgnoreCase( "subscriptionId"));
            if (subscriptionId != null)
            {
                subscriptionId.IsRequired = true;
            }

            var acceptLanguage = codeModel.Properties
                .FirstOrDefault(p => AcceptLanguage.EqualsIgnoreCase(p.SerializedName));
            if (acceptLanguage == null)
            {
                acceptLanguage = New<Property>(new
                {
                    Name = AcceptLanguage,
                    Documentation = "Gets or sets the preferred language for the response.",
                    SerializedName = AcceptLanguage,
                    DefaultValue = "en-US"
                });
                codeModel.Add( acceptLanguage);
            }
            acceptLanguage.IsReadOnly = false;
            acceptLanguage.IsRequired = false;
            acceptLanguage.ModelType = New<PrimaryType>(KnownPrimaryType.String);
            codeModel.Methods
                .Where(m => !m.Parameters.Any(p => AcceptLanguage.EqualsIgnoreCase(p.SerializedName)))
                .ForEach(m2 => m2.Add(New<Parameter>(new 
                    {
                        ClientProperty = acceptLanguage,
                        Location = ParameterLocation.Header
                    }).LoadFrom(acceptLanguage)));

            codeModel.Insert(New<Property>(new
            {
                Name = "Credentials",
                SerializedName = "credentials",
                ModelType = New<PrimaryType>(KnownPrimaryType.Credentials),
                IsRequired = true,
                IsReadOnly = true,
                Documentation = "Credentials needed for the client to connect to Azure."
            }));

            codeModel.Add(New<Property>(new
            {
                Name = "LongRunningOperationRetryTimeout",
                SerializedName = "longRunningOperationRetryTimeout",
                ModelType = New<PrimaryType>(KnownPrimaryType.Int),
                Documentation = "Gets or sets the retry timeout in seconds for Long Running Operations. Default value is 30.",
                DefaultValue = "30"
            }));

            codeModel.Add( New<Property>(new 
            {
                Name = "GenerateClientRequestId",
                SerializedName = "generateClientRequestId",
                ModelType = New<PrimaryType>(KnownPrimaryType.Boolean),
                Documentation = "When set to true a unique x-ms-client-request-id value is generated and included in each request. Default is true.",
                DefaultValue = "true"
            }));
        }

        

        /// <summary>
        /// Determines a composite type as an External Resource if it's name equals "Resource" 
        /// and it has an extension named "x-ms-azure-resource" marked as true.
        /// </summary>
        /// <param name="compositeType">Type to determine if it is an external resource</param>
        /// <returns>True if it is an external resource, false otherwise</returns>
        public static bool IsAzureResource(CompositeType compositeType)
        {
            if (compositeType == null)
            {
                return false;
            }

            if (compositeType.ComposedExtensions.ContainsKey(AzureResourceExtension))
            {
                var external = compositeType.ComposedExtensions[AzureResourceExtension] as bool?;
                return (external == null || external.Value);
            }

            return false;
        }

        /// <summary>
        /// Adds ListNext() method for each List method with x-ms-pageable extension.
        /// </summary>
        /// <param name="codeModelient"></param>
        /// <param name="codeNamer"></param>
        public static void AddPageableMethod(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var method in codeModel.Methods.Distinct(each => each.Group + each.Name).ToArray())
            {
                if (method.Extensions.ContainsKey(PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(method.Extensions[PageableExtension].ToString());
                    if (string.IsNullOrWhiteSpace(pageableExtension.NextLinkName))
                    {
                        continue;
                    }

                    Method nextLinkMethod = null;
                    if (!string.IsNullOrEmpty(pageableExtension.OperationName))
                    {
                        nextLinkMethod = codeModel.Methods.FirstOrDefault(m =>
                            pageableExtension.OperationName.EqualsIgnoreCase(m.SerializedName));
                        if (nextLinkMethod != null)
                        {
                            nextLinkMethod.Extensions["nextLinkMethod"] = true;
                            method.Extensions["nextMethodName"] = nextLinkMethod.Name;
                            method.Extensions["nextMethodGroup"] = nextLinkMethod.Group;
                        }
                    }

                    if (nextLinkMethod == null)
                    {
                        nextLinkMethod = Duplicate<Method>(method);

                        if (!string.IsNullOrEmpty(pageableExtension.OperationName))
                        {
                            nextLinkMethod.Name = CodeNamer.Instance.GetMethodName(SwaggerModeler.GetMethodName(
                                new Operation { OperationId = pageableExtension.OperationName }));
                            nextLinkMethod.Group = CodeNamer.Instance.GetMethodGroupName(SwaggerModeler.GetMethodGroup(
                                new Operation { OperationId = pageableExtension.OperationName }));
                        }
                        else
                        {
                            nextLinkMethod.Name = nextLinkMethod.Name + "Next";
                        }
                        method.Extensions["nextMethodName"] = nextLinkMethod.Name;
                        method.Extensions["nextMethodGroup"] = nextLinkMethod.Group;
                        nextLinkMethod.Extensions["nextLinkMethod"] = true;
                        nextLinkMethod.ClearParameters();
                        nextLinkMethod.Url = "{nextLink}";
                        nextLinkMethod.IsAbsoluteUrl = true;
                        var nextLinkParameter = New<Parameter>(new
                        {
                            Name = "nextPageLink",
                            SerializedName = "nextLink",
                            ModelType = New<PrimaryType>(KnownPrimaryType.String),
                            Documentation = "The NextLink from the previous successful call to List operation.",
                            IsRequired = true,
                            Location = ParameterLocation.Path
                        });
                        nextLinkParameter.Extensions[SkipUrlEncodingExtension] = true;
                        nextLinkMethod.Add(nextLinkParameter);

                        // Need copy all the header parameters from List method to ListNext method
                       foreach (var param in method.Parameters.Where(p => p.Location == ParameterLocation.Header))
                       {
                            nextLinkMethod.Add(Duplicate(param));
                       }

                        // Copy all grouped parameters that only contain header parameters
                        nextLinkMethod.InputParameterTransformation.Clear();
                        method.InputParameterTransformation.GroupBy(t => t.ParameterMappings[0].InputParameter)
                            .ForEach(grouping => {
                                if (grouping.All(t => t.OutputParameter.Location == ParameterLocation.Header))
                                {
                                    // All grouped properties were header parameters, reuse data type
                                    nextLinkMethod.Add(grouping.Key);
                                    grouping.ForEach(t => nextLinkMethod.InputParameterTransformation.Add(t));
                                }
                                else if (grouping.Any(t => t.OutputParameter.Location == ParameterLocation.Header))
                                {
                                    // Some grouped properties were header parameters, creating new data types
                                    var headerGrouping = grouping.Where(t => t.OutputParameter.Location == ParameterLocation.Header);
                                    headerGrouping.ForEach(t => nextLinkMethod.InputParameterTransformation.Add((ParameterTransformation) t.Clone()));
                                    var newGroupingParam = CreateParameterFromGrouping(headerGrouping, nextLinkMethod, codeModel);
                                    nextLinkMethod.Add(newGroupingParam);
                                    //grouping.Key.Name = newGroupingParam.Name;
                                    // var inputParameter = (Parameter) nextLinkMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter.Clone();
                                    var inputParameter = Duplicate(nextLinkMethod.InputParameterTransformation.First().ParameterMappings[0].InputParameter);
                                    inputParameter.Name = CodeNamer.Instance.GetParameterName(newGroupingParam.Name);

                                    inputParameter.IsRequired = newGroupingParam.IsRequired;
                                    nextLinkMethod.InputParameterTransformation.ForEach(t => t.ParameterMappings[0].InputParameter = inputParameter);
                                }
                            });

                        codeModel.Add( nextLinkMethod);
                        
                    }
                }
            }
        }

        private static Parameter CreateParameterFromGrouping(IEnumerable<ParameterTransformation> grouping, Method method, CodeModel codeModel)
        {
            var properties = new List<Property>();
            string parameterGroupName = null;
            foreach (var parameter in grouping.Select(g => g.OutputParameter))
            {
                Newtonsoft.Json.Linq.JContainer extensionObject = parameter.Extensions[ParameterGroupExtension] as Newtonsoft.Json.Linq.JContainer;
                string specifiedGroupName = extensionObject.Value<string>("name");
                if (specifiedGroupName == null)
                {
                    string postfix = extensionObject.Value<string>("postfix") ?? "Parameters";
                    parameterGroupName = method.Group + "-" + method.Name + "-" + postfix;
                }
                else
                {
                    parameterGroupName = specifiedGroupName;
                }

                Property groupProperty = New<Property>(new
                {
                    IsReadOnly = false, //Since these properties are used as parameters they are never read only
                    Name = parameter.Name,
                    IsRequired = parameter.IsRequired,
                    DefaultValue = parameter.DefaultValue,
                    //Constraints = parameter.Constraints, Omit these since we don't want to perform parameter validation
                    Documentation = parameter.Documentation,
                    ModelType = parameter.ModelType,
                    SerializedName = default(string) //Parameter is never serialized directly
                });
                properties.Add(groupProperty);
            }
            
            var parameterGroupType = New <CompositeType>(parameterGroupName, new
            {
                Documentation = "Additional parameters for the " + method.Name + " operation."
            });

            //Add to the service client
            codeModel.Add(parameterGroupType);

            foreach (Property property in properties)
            {
                parameterGroupType.Add(property);
            }

            bool isGroupParameterRequired = parameterGroupType.Properties.Any(p => p.IsRequired);

            //Create the new parameter object based on the parameter group type
            return New<Parameter>(new
            {
                Name = parameterGroupName,
                IsRequired = isGroupParameterRequired,
                Location = ParameterLocation.None,
                SerializedName = string.Empty,
                ModelType = parameterGroupType,
                Documentation = "Additional parameters for the operation"
            });
        }

        public static void ProcessClientRequestIdExtension(CodeModel codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (Method method in codeModel.Methods)
            {
                const string defaultClientRequestIdName = "x-ms-client-request-id";
                string customClientRequestIdName =
                    method.Parameters.Where(parameter => parameter.Extensions.ContainsKey(ClientRequestIdExtension))
                    .Select(parameter =>
                        {
                            bool? extensionObject = parameter.Extensions[ClientRequestIdExtension] as bool?;
                            if (extensionObject != null && extensionObject.Value)
                            {
                                return parameter.SerializedName.Value;
                            }
                            return null;
                        })
                    .SingleOrDefault();

                string clientRequestIdName = customClientRequestIdName ?? defaultClientRequestIdName;
                method.Extensions.Add(ClientRequestIdExtension, clientRequestIdName);
            }
        }

        public static string GetClientRequestIdString(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }

            if (method.Extensions.ContainsKey(ClientRequestIdExtension))
            {
                return method.Extensions[ClientRequestIdExtension] as string;
            }
            else
            {
                throw new InvalidOperationException(string.Format(CultureInfo.CurrentCulture, "Method missing expected {0} extension", ClientRequestIdExtension));
            }
        }

        public static string GetRequestIdString(Method method)
        {
            if (method == null)
            {
                throw new ArgumentNullException("method");
            }

            string requestIdName = "x-ms-request-id";
            if (method.Extensions.ContainsKey(RequestIdExtension))
            {
                string extensionObject = method.Extensions[RequestIdExtension] as string;
                if (extensionObject != null)
                {
                    requestIdName = extensionObject;
                }
            }
            
            return requestIdName;
        }        
    }
}