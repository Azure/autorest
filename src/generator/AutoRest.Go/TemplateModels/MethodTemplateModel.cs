// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Net;

using AutoRest.Core.ClientModel;
using AutoRest.Go.Properties;
using AutoRest.Core.Utilities;

namespace AutoRest.Go.TemplateModels
{
    public class MethodTemplateModel : Method
    {
        public readonly MethodScopeProvider MethodScope;
        public readonly string Owner;
        public readonly string PackageName;

        private readonly string lroDescription = " This method may poll for completion. Polling can be canceled by passing the cancel channel argument. " +
                                                 "The channel will be used to cancel polling and any outstanding HTTP requests.";


        public MethodTemplateModel(Method source, string owner, string packageName, MethodScopeProvider methodScope)
        {
            this.LoadFrom(source);

            MethodScope = methodScope;
            Owner = owner;
            PackageName = packageName;

            var parameter = Parameters.Find(p => p.Type.IsPrimaryType(KnownPrimaryType.Stream)
                                                && !(p.Location == ParameterLocation.Body || p.Location == ParameterLocation.FormData));
            if (parameter != null)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    Resources.IllegalStreamingParameter, parameter.Name));
            }

            if (string.IsNullOrEmpty(Description))
            {
                Description = string.Format("sends the {0} request.", ScopedName.ToPhrase());
            }

            if (this.IsLongRunningOperation())
            {
                Description += lroDescription;
            }
        }

        private string _scopedName;
        public string ScopedName
        {
            get
            {
                if (string.IsNullOrEmpty(_scopedName))
                {
                    _scopedName = MethodScope.GetMethodName(Name, Group);
                }
                return _scopedName;
            }
        }

        public string MethodSignature
        {
            get
            {
                return ScopedName + "(" + MethodParametersSignature + ")";
            }
        }

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
                                                        p.IsRequired || p.Type.CanBeEmpty()
                                                            ? "{0} {1}"
                                                            : "{0} *{1}", p.Name, p.Type.Name)));
                //for Cancelation channel option for long-running operations
                if (this.IsLongRunningOperation())
                {
                    declarations.Add("cancel <-chan struct{}");
                }
                return string.Join(", ", declarations);
            }
        }

        public string MethodReturnSignature
        {
            get
            {
                return !this.IsLongRunningOperation() && this.HasReturnValue()
                    ? string.Format("result {0}, err error", this.ReturnValue().Body.Name)
                    : "result autorest.Response, err error";
            }
        }

        public string NextMethodName
        {
            get
            {
                return ScopedName + "NextResults";
            }
        }

        public string PreparerMethodName
        {
            get
            {
                return ScopedName + "Preparer";
            }
        }

        public string SenderMethodName
        {
            get
            {
                return ScopedName + "Sender";
            }
        }

        public string ResponderMethodName
        {
            get
            {
                return ScopedName + "Responder";
            }
        }

        public string HelperInvocationParameters
        {
            get
            {
                List<string> invocationParams = new List<string>();
                LocalParameters
                    .ForEach(p => invocationParams.Add(p.Name));
                if (this.IsLongRunningOperation())
                {
                    invocationParams.Add("cancel");
                }
                return string.Join(", ", invocationParams);
            }
        }

        /// <summary>
        /// Return the parameters as they apopear in the method signature excluding global parameters.
        /// </summary>
        public IEnumerable<Parameter> LocalParameters
        {
            get
            {
                return
                    Parameters.Where(
                       p => p != null && p.IsMethodArgument() && !string.IsNullOrWhiteSpace(p.Name) && !p.SerializedName.IsApiVersion())
                        .OrderBy(item => !item.IsRequired);
            }
        }
        public string ParameterValidations
        {
            get
            {
                return Parameters.Validate(HttpMethod);
            }
        }

        public Parameter BodyParameter
        {
            get
            {
                return Parameters.BodyParameter();
            }
        }

        public IEnumerable<Parameter> FormDataParameters
        {
            get
            {
                return Parameters.FormDataParameters();
            }
        }

        public IEnumerable<Parameter> HeaderParameters
        {
            get
            {
                return Parameters.HeaderParameters();
            }
        }

        public IEnumerable<Parameter> OptionalHeaderParameters
        {
            get
            {
                return Parameters.HeaderParameters(false);
            }
        }

        public IEnumerable<Parameter> PathParameters
        {
            get
            {
                return Parameters.PathParameters();
            }
        }

        public string PathMap
        {
            get
            {
                return PathParameters.BuildParameterMap("pathParameters");
            }
        }

        public IEnumerable<Parameter> QueryParameters
        {
            get
            {
                return Parameters.QueryParameters();
            }
        }

        public IEnumerable<Parameter> OptionalQueryParameters
        {
            get
            {
                return Parameters.QueryParameters(false);
            }
        }

        public string QueryMap
        {
            get
            {
                return QueryParameters.BuildParameterMap("queryParameters");
            }
        }

        public string FormDataMap
        {
            get
            {
                return FormDataParameters.BuildParameterMap("formDataParameters");
            }
        }

        public List<string> ResponseCodes
        {
            get
            {
                var codes = new List<string>();
                if (!Responses.ContainsKey(HttpStatusCode.OK))
                {
                    codes.Add(GoCodeNamer.StatusCodeToGoString[HttpStatusCode.OK]);
                }
                foreach (var sc in Responses.Keys)
                {
                    codes.Add(GoCodeNamer.StatusCodeToGoString[sc]);
                }
                return codes;
            }
        }

        public List<string> PrepareDecorators
        {
            get
            {
                var decorators = new List<string>();

                if (BodyParameter != null && !BodyParameter.Type.IsPrimaryType(KnownPrimaryType.Stream))
                {
                    decorators.Add("autorest.AsJSON()");
                }

                decorators.Add(HTTPMethodDecorator);
                decorators.Add("autorest.WithBaseURL(client.BaseURI)");

                decorators.Add(string.Format(PathParameters.Any()
                            ? "autorest.WithPathParameters(\"{0}\",pathParameters)"
                            : "autorest.WithPath(\"{0}\")",
                        Url));

                if (BodyParameter != null && BodyParameter.IsRequired)
                {
                    decorators.Add(string.Format(BodyParameter.Type.IsPrimaryType(KnownPrimaryType.Stream) && BodyParameter.Location == ParameterLocation.Body
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
                        FormDataParameters.Any(p => p.Type.IsPrimaryType(KnownPrimaryType.Stream))
                            ? "autorest.WithMultiPartFormData(formDataParameters)"
                            : "autorest.WithFormData(autorest.MapToValues(formDataParameters))"
                        );
                }

                if (RequestHeaders.Any())
                {
                    foreach (var param in Parameters.Where(p => p.IsRequired && p.Location == ParameterLocation.Header))
                    {
                        decorators.Add(string.Format("autorest.WithHeader(\"{0}\",autorest.String({1}))",
                           param.SerializedName, param.Name));
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

                if (!this.IsLongRunningOperation() && this.HasReturnValue() && !this.ReturnValue().Body.IsStreamType())
                {
                    if (this.ReturnValue().Body is SyntheticType)
                    {
                        decorators.Add("autorest.ByUnmarshallingJSON(&result.Value)");
                    }
                    else
                    {
                        decorators.Add("autorest.ByUnmarshallingJSON(&result)");
                    }
                }

                if (!this.HasReturnValue() || !this.ReturnValue().Body.IsStreamType())
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
                return !this.IsLongRunningOperation() && this.HasReturnValue()
                    ? "result.Response = autorest.Response{Response: resp}"
                    : "result.Response = resp";
            }
        }

        public string AutorestError(string phase, string response = null, string parameter = null)
        {
            return !string.IsNullOrEmpty(parameter)
                        ? string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", nil , \"{3}\'{4}\'\")", PackageName, Owner, ScopedName, phase, parameter)
                        : string.IsNullOrEmpty(response)
                                 ? string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", nil , \"{3}\")", PackageName, Owner, ScopedName, phase)
                                 : string.Format("autorest.NewErrorWithError(err, \"{0}.{1}\", \"{2}\", {3}, \"{4}\")", PackageName, Owner, ScopedName, response, phase);

        }

        public string ValidationError()
        {
            return $"validation.NewErrorWithValidationError(err, \"{PackageName}.{Owner}\",\"{ScopedName}\")";
        }
    }
}
