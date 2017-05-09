// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.Properties;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using AutoRest.Extensions.Azure.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;

namespace AutoRest.Go.Model
{
    public class MethodGo : Method
    {
        public string Owner { get; private set; }

        public string PackageName { get; private set; }

        public string APIVersion { get; private set; }

        private readonly string lroDescription = " This method may poll for completion. Polling can be canceled by passing the cancel channel argument. " +
                                                 "The channel will be used to cancel polling and any outstanding HTTP requests.";

        public bool NextAlreadyDefined { get; private set; }

        public bool IsCustomBaseUri
            => CodeModel.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        public MethodGo()
        {
            NextAlreadyDefined = true;
        }

        internal void Transform(CodeModelGo cmg)
        {
            Owner = (MethodGroup as MethodGroupGo).ClientName;
            PackageName = cmg.Namespace;
            NextAlreadyDefined = NextMethodExists(cmg.Methods.Cast<MethodGo>());

            var apiVersionParam =
              from p in Parameters
              let name = p.SerializedName.Value
              where name != null && name.IsApiVersion()
              select p.DefaultValue.Value?.Trim(new[] { '"' });

            // When APIVersion is blank, it means that it was unavailable at the method level
            // and we should default back to whatever is present at the client level. However,
            // we will continue embedding that in each method to have broader support.
            APIVersion = apiVersionParam.SingleOrDefault();
            if (APIVersion == default(string))
            {
                APIVersion = cmg.ApiVersion;
            }

            var parameter = Parameters.ToList().Find(p => p.ModelType.PrimaryType(KnownPrimaryType.Stream)
                                                && !(p.Location == ParameterLocation.Body || p.Location == ParameterLocation.FormData));

            if (parameter != null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    Resources.IllegalStreamingParameter, parameter.Name));
            }
            if (string.IsNullOrEmpty(Description))
            {
                Description = string.Format("sends the {0} request.", Name.ToString().ToPhrase());
            }

            if (IsLongRunningOperation())
            {
                Description += lroDescription;
            }
        }

        public string MethodSignature => $"{Name}({MethodParametersSignature})";
        
        public string MethodParametersSignatureComplete
        {
            get
            {     
                var signature = new StringBuilder("(");
                signature.Append(MethodParametersSignature);
                if (!IsLongRunningOperation())
                {
                    if (MethodParametersSignature.Length > 0)
                    {
                        signature.Append( ", ");
                    }
                    signature.Append("cancel <-chan struct{}");
                }
                signature.Append(")");
                return signature.ToString();
            }
        }

        public string MethodReturnSignatureComplete
        {
            get
            {
                var signature = new StringBuilder("(<-chan ");
                signature.Append((ListElement.ModelType as SequenceTypeGo).GetElement);
                signature.Append(", <-chan error)");
                return signature.ToString();
            }
        }

        public string ParametersDocumentation
        {
            get
            {
                StringBuilder sb = new StringBuilder();
                foreach (var parameter in LocalParameters)
                {
                    if (!string.IsNullOrEmpty(parameter.Documentation))
                    {
                        sb.Append(parameter.Name);
                        sb.Append(" is ");
                        sb.Append(parameter.Documentation.FixedValue.ToSentence());
                        sb.Append(" ");
                    }
                    if (parameter.ModelType.PrimaryType(KnownPrimaryType.Stream))
                    {
                        sb.Append(parameter.Name);
                        sb.Append(" will be closed upon successful return. Callers should ensure closure when receiving an error.");
                    }
                }
                return sb.ToString();
            }
        }

        public PropertyGo ListElement
        {
            get
            {
                var properties = (ReturnType.Body as CompositeTypeGo).Properties.Cast<PropertyGo>().ToList();
                foreach (PropertyGo p in properties)
                {
                    if (p.ModelType is SequenceTypeGo)
                    {
                        return p;
                    }
                }
                return null;
            }
        }

        public string ListCompleteMethodName => $"{Name}Complete";

        /// <summary>
        /// Generate the method parameter declaration.
        /// </summary>
        public string MethodParametersSignature
        {
            get
            {
                List<string> declarations = new List<string>();
                LocalParameters
                    .ForEach(p => declarations.Add(string.Format(
                                                        p.IsRequired || p.ModelType.CanBeEmpty()
                                                            ? "{0} {1}"
                                                            : "{0} *{1}", p.Name, p.ModelType.Name)));
                //for Cancelation channel option for long-running operations
                if (IsLongRunningOperation())
                {
                    declarations.Add("cancel <-chan struct{}");
                }
                return string.Join(", ", declarations);
            }
        }

        /// <summary>
        /// Returns true if this method should return its results via channels.
        /// </summary>
        public bool ReturnViaChannel
        {
            get
            {
                // pageable operations will be handled separately
                return IsLongRunningOperation() && !IsPageable;
            }
        }

        /// <summary>
        /// Gets the return type name for this method.
        /// </summary>
        public string MethodReturnType
        {
            get
            {
                return HasReturnValue() ? ReturnValue().Body.Name.ToString() : "autorest.Response";
            }
        }

        /// <summary>
        /// Returns the method return signature for this method (e.g. "foo, bar").
        /// </summary>
        /// <param name="helper">Indicates if this method is a helper method (i.e. preparer/sender/responder).</param>
        /// <returns>The method signature for this method.</returns>
        public string MethodReturnSignature(bool helper)
        {
            var retValType = MethodReturnType;
            var retVal = $"result {retValType}";
            var errVal = "err error";

            // for LROs return the response types via a channel.
            // only do this for the "real" API; for "helper" methods
            // i.e. preparer/sender/responder don't use a channel.
            if (!helper && ReturnViaChannel)
            {
                retVal = $"<-chan {retValType}";
                errVal = "<-chan error";
            }

            return $"{retVal}, {errVal}";
        }

        public string NextMethodName => $"{Name}NextResults";

        public string PreparerMethodName => $"{Name}Preparer";

        public string SenderMethodName => $"{Name}Sender";

        public string ResponderMethodName => $"{Name}Responder";

        public string HelperInvocationParameters(bool complete)
        {
            List<string> invocationParams = new List<string>();
            foreach (ParameterGo p in LocalParameters)
            {
                if (p.Name.EqualsIgnoreCase("nextlink") && complete)
                {
                    invocationParams.Add(string.Format("*list.{0}", NextLink));
                }
                else
                {
                    invocationParams.Add(p.Name);
                }
            }
            if (IsLongRunningOperation())
            {
                invocationParams.Add("cancel");
            }
            return string.Join(", ", invocationParams);
        }

        /// <summary>
        /// Return the parameters as they appear in the method signature excluding global parameters.
        /// </summary>
        public IEnumerable<ParameterGo> LocalParameters
        {
            get
            {
                return
                    Parameters.Cast<ParameterGo>().Where(
                        p => p != null && p.IsMethodArgument && !string.IsNullOrWhiteSpace(p.Name))
                                .OrderBy(item => !item.IsRequired);
            }
        }

        public IEnumerable<ParameterGo> ParametersGo => Parameters.Cast<ParameterGo>();

        public string ParameterValidations => ParametersGo.Validate(HttpMethod);

        public ParameterGo BodyParameter => ParametersGo.BodyParameter();

        public IEnumerable<ParameterGo> FormDataParameters => ParametersGo.FormDataParameters();

        public IEnumerable<ParameterGo> HeaderParameters => ParametersGo.HeaderParameters();

        public IEnumerable<ParameterGo> OptionalHeaderParameters => ParametersGo.HeaderParameters(false);

        public IEnumerable<ParameterGo> URLParameters => ParametersGo.URLParameters();

        public string URLMap => URLParameters.BuildParameterMap("urlParameters");

        public IEnumerable<ParameterGo> PathParameters => ParametersGo.PathParameters();

        public string PathMap => PathParameters.BuildParameterMap("pathParameters");

        public IEnumerable<ParameterGo> QueryParameters => ParametersGo.QueryParameters();

        public IEnumerable<ParameterGo> OptionalQueryParameters => ParametersGo.QueryParameters(false);

        public string QueryMap => QueryParameters.BuildParameterMap("queryParameters");

        public string FormDataMap => FormDataParameters.BuildParameterMap("formDataParameters");

        public List<string> ResponseCodes
        {
            get
            {
                var codes = new List<string>();
                // Refactor -> CodeModelTransformer
                // Actually, this is the kind of stuff that would be better in the core...
                if (!Responses.ContainsKey(HttpStatusCode.OK))
                {
                    codes.Add(CodeNamerGo.Instance.StatusCodeToGoString[HttpStatusCode.OK]);
                }
                // Refactor -> generator
                foreach (var sc in Responses.Keys)
                {
                    codes.Add(CodeNamerGo.Instance.StatusCodeToGoString[sc]);
                }
                return codes;
            }
        }

        public List<string> PrepareDecorators
        {
            get
            {
                var decorators = new List<string>();

                if (BodyParameter != null && !BodyParameter.ModelType.PrimaryType(KnownPrimaryType.Stream))
                {
                    decorators.Add("autorest.AsJSON()");
                }

                decorators.Add(HTTPMethodDecorator);
                if (!this.IsCustomBaseUri)
                {
                    decorators.Add(string.Format("autorest.WithBaseURL(client.BaseURI)"));
                }
                else
                {
                    decorators.Add(string.Format("autorest.WithCustomBaseURL(\"{0}\", urlParameters)", CodeModel.BaseUrl));
                }

                decorators.Add(string.Format(PathParameters.Any()
                            ? "autorest.WithPathParameters(\"{0}\",pathParameters)"
                            : "autorest.WithPath(\"{0}\")",
                        Url));

                if (BodyParameter != null && BodyParameter.IsRequired)
                {
                    decorators.Add(string.Format(BodyParameter.ModelType.PrimaryType(KnownPrimaryType.Stream) && BodyParameter.Location == ParameterLocation.Body
                                        ? "autorest.WithFile({0})"
                                        : "autorest.WithJSON({0})",
                                BodyParameter.Name));
                }

                if (QueryParameters.Any())
                {
                    decorators.Add("autorest.WithQueryParameters(queryParameters)");
                }

                if (FormDataParameters.Any())
                {
                    decorators.Add(
                        FormDataParameters.Any(p => p.ModelType.PrimaryType(KnownPrimaryType.Stream))
                            ? "autorest.WithMultiPartFormData(formDataParameters)"
                            : "autorest.WithFormData(autorest.MapToValues(formDataParameters))"
                        );
                }

                if (HeaderParameters.Any())
                {
                    foreach (var param in Parameters.Where(p => p.IsRequired && p.Location == ParameterLocation.Header))
                    {
                        if (param.IsClientProperty)
                        {
                            decorators.Add(string.Format("autorest.WithHeader(\"{0}\",client.{1})", param.SerializedName, param.Name.ToPascalCase().ToString()));
                        }
                        else
                        {
                            decorators.Add(string.Format("autorest.WithHeader(\"{0}\",autorest.String({1}))", param.SerializedName, param.Name.ToString()));
                        }
                    }
                }

                return decorators;
            }
        }

        public string HTTPMethodDecorator
        {
            get
            {
                switch (HttpMethod)
                {
                    case HttpMethod.Delete: return "autorest.AsDelete()";
                    case HttpMethod.Get: return "autorest.AsGet()";
                    case HttpMethod.Head: return "autorest.AsHead()";
                    case HttpMethod.Options: return "autorest.AsOptions()";
                    case HttpMethod.Patch: return "autorest.AsPatch()";
                    case HttpMethod.Post: return "autorest.AsPost()";
                    case HttpMethod.Put: return "autorest.AsPut()";
                    default:
                        throw new ArgumentException(string.Format("The HTTP verb {0} is not supported by the Go SDK", HttpMethod));
                }
            }
        }

        public List<string> RespondDecorators
        {
            get
            {
                var decorators = new List<string>();
                decorators.Add("client.ByInspecting()");
                decorators.Add(string.Format("azure.WithErrorUnlessStatusCode({0})", string.Join(",", ResponseCodes.ToArray())));

                if (HasReturnValue() && !ReturnValue().Body.IsStreamType())
                {
                    if (((CompositeTypeGo)ReturnValue().Body).IsWrapperType)
                    {
                        decorators.Add("autorest.ByUnmarshallingJSON(&result.Value)");
                    }
                    else
                    {
                        decorators.Add("autorest.ByUnmarshallingJSON(&result)");
                    }
                }

                if (!HasReturnValue() || !ReturnValue().Body.IsStreamType())
                {
                    decorators.Add("autorest.ByClosing()");
                }
                return decorators;
            }
        }

        public string Response
        {
            get
            {
                return HasReturnValue()
                    ? "result.Response = autorest.Response{Response: resp}"
                    : "result.Response = resp";
            }
        }

        public string AutorestError(string phase, string response = null, string parameter = null)
        {
            return !string.IsNullOrEmpty(parameter)
                ? string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", nil , \"{3}\'{4}\'\")", PackageName, Owner, Name, phase, parameter)
                : string.IsNullOrEmpty(response)
                    ? string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", nil , \"{3}\")", PackageName, Owner, Name, phase)
                    : string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", {3}, \"{4}\")", PackageName, Owner, Name, response, phase);
        }

        public string ValidationError => $"validation.NewErrorWithValidationError(err, \"{PackageName}.{Owner}\",\"{Name}\")";

        /// <summary>
        /// Check if method has a return response.
        /// </summary>
        /// <returns></returns>
        public bool HasReturnValue()
        {
            return ReturnValue()?.Body != null;
        }

        /// <summary>
        /// Return response object for the method.
        /// </summary>
        /// <returns></returns>
        public Response ReturnValue()
        {
            return ReturnType ?? DefaultResponse;
        }

        /// <summary>
        /// Checks if method has pageable extension (x-ms-pageable) enabled.  
        /// </summary>
        /// <returns></returns>

        public bool IsPageable => !string.IsNullOrEmpty(NextLink);

        public bool IsNextMethod => Name.Value.EqualsIgnoreCase(NextOperationName);

        /// <summary>
        /// Checks if method for next page of results on paged methods is already present in the method list.
        /// </summary>
        /// <param name="methods"></param>
        /// <returns></returns>
        public bool NextMethodExists(IEnumerable<MethodGo> methods)
        {
            string next = NextOperationName;
            if (string.IsNullOrEmpty(next))
            {
                return false; 
            }
            return methods.Any(m => m.Name.Value.EqualsIgnoreCase(next));
        }

        public MethodGo NextMethod
        {
            get
            {
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());
                    if (pageableExtension != null && !string.IsNullOrWhiteSpace(pageableExtension.OperationName))
                    {
                        return (CodeModel.Methods.First(m => m.SerializedName.EqualsIgnoreCase(pageableExtension.OperationName)) as MethodGo);
                    }
                }
                return null;
            }
        }

        public string NextOperationName
        {
            get
            {
                if (NextMethod != null)
                {
                    return NextMethod.Name.Value;
                }
                return null;
            }
        }

        public Method NextOperation
        {
            get
            {
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = JsonConvert.DeserializeObject<PageableExtension>(Extensions[AzureExtensions.PageableExtension].ToString());
                    if (pageableExtension != null && !string.IsNullOrWhiteSpace(pageableExtension.OperationName))
                    {
                        return CodeModel.Methods.First(m => m.SerializedName.EqualsIgnoreCase(pageableExtension.OperationName));
                    }
                }
                return null;
            }
        }

        /// <summary>
        /// Check if method has long running extension (x-ms-long-running-operation) enabled. 
        /// </summary>
        /// <returns></returns>
        public bool IsLongRunningOperation()
        {
            try
            {
                return Extensions.ContainsKey(AzureExtensions.LongRunningExtension) && (bool)Extensions[AzureExtensions.LongRunningExtension];
            }
            catch (InvalidCastException e)
            {
                var message = $@"{
                    e.Message
                    } The value \'{
                    Extensions[AzureExtensions.LongRunningExtension]
                    }\' for extension {
                    AzureExtensions.LongRunningExtension
                    } for method {
                    Group
                    }. {
                    Name
                    } is invalid in Swagger. It should be boolean.";

                throw new InvalidOperationException(message);
            }
        }

        /// <summary>
        /// Add NextLink attribute for pageable extension for the method.
        /// </summary>
        /// <returns></returns>
        public string NextLink
        {
            get
            {
                string nextLink = "";

                // Note:
                // -- The CSharp generator applies a default link name if the extension is present but the link name is not.
                //    Yet, the MSDN for methods whose nextLink is missing are not paged methods. It appears the CSharp code is
                //    outdated vis a vis the specification.
                // TODO (gosdk): Ensure obtaining the nextLink is correct.
                if (Extensions.ContainsKey(AzureExtensions.PageableExtension))
                {
                    var pageableExtension = Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                    if (pageableExtension != null)
                    {
                        var nextLinkName = (string)pageableExtension["nextLinkName"];
                        if (!string.IsNullOrEmpty(nextLinkName))
                        {
                            nextLink = CodeNamerGo.PascalCaseWithoutChar(nextLinkName, '.');
                        }
                    }
                }

                return nextLink;
            }
        }
    }
}
