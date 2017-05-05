// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using AutoRest.Extensions;
using AutoRest.Extensions.Azure;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoRest.Go.Model
{
    public class ParameterGo : Parameter
    {
        public const string APIVersionName = "APIVersion";
        public ParameterGo()
        {

        }

        /// <summary>
        /// Add imports for the parameter in parameter type.
        /// </summary>
        /// <param name="parameter"></param>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            ModelType.AddImports(imports);
        }

        /// <summary>
        /// Return string with formatted Go map.
        /// xyz["abc"] = 123
        /// </summary>
        /// <param name="mapVariable"></param>
        /// <returns></returns>
        public string AddToMap(string mapVariable, bool isNext)
        {
            return string.Format("{0}[\"{1}\"] = {2}", mapVariable, NameForMap(), ValueForMap(isNext));
        }

        public string GetParameterName()
        {
            string retval;
            if (IsAPIVersion) 
            {
                retval = APIVersionName;
            }
            else if (IsClientProperty)
            {
                retval = "client." + Name.Value.Capitalize();
            }
            else 
            {
                retval = Name.Value;
            }
            return retval;
        }

        public override bool IsClientProperty => base.IsClientProperty == true && !IsAPIVersion;

        public virtual bool IsAPIVersion => SerializedName.Value.IsApiVersion();

        public virtual bool IsMethodArgument => !IsClientProperty && !IsAPIVersion;

        /// <summary>
        /// Get Name for parameter for Go map. 
        /// If parameter is client parameter, then return client.<parametername>
        /// </summary>
        /// <returns></returns>
        public string NameForMap()
        {
            return IsAPIVersion
                     ? AzureExtensions.ApiVersion
                     : SerializedName.Value;
        }

        public bool RequiresUrlEncoding()
        {
            return (Location == Core.Model.ParameterLocation.Query || Location == Core.Model.ParameterLocation.Path) && !Extensions.ContainsKey(SwaggerExtensions.SkipUrlEncodingExtension);
        }

        /// <summary>
        /// Return formatted value string for the parameter.
        /// </summary>
        /// <returns></returns>
        public string ValueForMap(bool isNext)
        {
            if (IsAPIVersion)
            {
                return APIVersionName;
            }

            var value = IsClientProperty
                ? isNext
                    ? "lastResults.client." + CodeNamerGo.Instance.GetPropertyName(Name.Value)
                    : "client." + CodeNamerGo.Instance.GetPropertyName(Name.Value)
                        : Name.Value;

            var format = IsRequired || ModelType.CanBeEmpty()
                                    ? "{0}"
                                    : "*{0}";

            var s = CollectionFormat != CollectionFormat.None
                            ? $"{format},\"{CollectionFormat.GetSeparator()}\""
                            : $"{format}";

            return string.Format(
                RequiresUrlEncoding()
                    ? $"autorest.Encode(\"{Location.ToString().ToLower()}\",{s})"
                    : $"{s}",
                        value);
        }
    }

    public static class ParameterGoExtensions
    {
        /// <summary>
        /// Return a Go map of required parameters.
        // Refactor -> Generator
        /// </summary>
        /// <param name="parameters"></param>
        /// <param name="mapVariable"></param>
        /// <returns></returns>
        public static string BuildParameterMap(this IEnumerable<ParameterGo> parameters, string mapVariable, bool isNext)
        {
            var builder = new StringBuilder();

            builder.Append(mapVariable);
            builder.Append(" := map[string]interface{} {");

            if (parameters.Count() > 0)
            {
                builder.AppendLine();
                var indented = new IndentedStringBuilder("  ");
                parameters
                    .Where(p => p.IsRequired)
                    .OrderBy(p => p.SerializedName.ToString())
                    .ForEach(p => indented.AppendLine("\"{0}\": {1},", p.NameForMap(), p.ValueForMap(isNext)));
                    builder.Append(indented);
            }
            builder.AppendLine("}");
            return builder.ToString();
        }


        /// <summary>
        /// Return list of parameters for specified location passed in an argument.
        /// Refactor -> Probably CodeModeltransformer, but even with 5 references, the other mkethods are not used anywhere
        /// </summary>
        /// <param name="parameters"></param>
        /// <param name="location"></param>
        /// <returns></returns>
        public static IEnumerable<ParameterGo> ByLocation(this IEnumerable<ParameterGo> parameters, ParameterLocation location)
        {
            return parameters
                .Where(p => p.Location == location);
        }

        /// <summary>
        /// Return list of retuired parameters for specified location passed in an argument.
        /// Refactor -> CodeModelTransformer, still, 3 erefences, but no one uses the other methods.
        /// </summary>
        /// <param name="parameters"></param>
        /// <param name="location"></param>
        /// <returns></returns>
        public static IEnumerable<ParameterGo> ByLocationAsRequired(this IEnumerable<ParameterGo> parameters, ParameterLocation location, bool isRequired)
        {
            return parameters
                .Where(p => p.Location == location && p.IsRequired == isRequired);
        }

        /// <summary>
        /// Return list of parameters as per their location in request.
        /// </summary>
        /// <param name="parameters"></param>
        /// <returns></returns>
        public static ParameterGo BodyParameter(this IEnumerable<ParameterGo> parameters)
        {
            var bodyParameters = parameters.ByLocation(ParameterLocation.Body);
            return bodyParameters.Any()
                    ? bodyParameters.First()
                    : null;
        }

        public static IEnumerable<ParameterGo> FormDataParameters(this IEnumerable<ParameterGo> parameters)
        {
            return parameters.ByLocation(ParameterLocation.FormData);
        }

        public static IEnumerable<ParameterGo> HeaderParameters(this IEnumerable<ParameterGo> parameters)
        {
            return parameters.ByLocation(ParameterLocation.Header);
        }

        public static IEnumerable<ParameterGo> HeaderParameters(this IEnumerable<ParameterGo> parameters, bool isRequired)
        {
            return parameters.ByLocationAsRequired(ParameterLocation.Header, isRequired);
        }

        public static IEnumerable<ParameterGo> URLParameters(this IEnumerable<ParameterGo> parameters)
        {
            var urlParams = new List<ParameterGo>();
            foreach (ParameterGo p in parameters.ByLocation(ParameterLocation.Path))
            {
                if (p.Method.CodeModel.BaseUrl.Contains(p.SerializedName))
                {
                    urlParams.Add(p);
                }
            }
            return urlParams;
        }

        public static IEnumerable<ParameterGo> PathParameters(this IEnumerable<ParameterGo> parameters)
        {
            var pathParams = new List<ParameterGo>();
            foreach (ParameterGo p in parameters.ByLocation(ParameterLocation.Path))
            {
                if (!p.Method.CodeModel.BaseUrl.Contains(p.SerializedName))
                {
                    pathParams.Add(p);
                }
            }
            return pathParams;
        }

        public static IEnumerable<ParameterGo> QueryParameters(this IEnumerable<ParameterGo> parameters)
        {
            return parameters.ByLocation(ParameterLocation.Query);
        }

        public static IEnumerable<ParameterGo> QueryParameters(this IEnumerable<ParameterGo> parameters, bool isRequired)
        {
            return parameters.ByLocationAsRequired(ParameterLocation.Query, isRequired);
        }

        public static string Validate(this IEnumerable<ParameterGo> parameters, HttpMethod method)
        {
            List<string> v = new List<string>();
            HashSet<string> ancestors = new HashSet<string>();

            foreach (var p in parameters)
            {
                if (p.IsAPIVersion)
                {
                    continue;
                }

                var name = !p.IsClientProperty
                        ? p.Name.Value
                        : "client." + p.Name.Value.Capitalize();

                List<string> x = new List<string>();
                if (p.ModelType is CompositeType)
                {
                    ancestors.Add(p.ModelType.Name);
                    x.AddRange(p.ValidateCompositeType(name, method, ancestors));
                    ancestors.Remove(p.ModelType.Name);
                }
                else
                    x.AddRange(p.ValidateType(name, method));

                if (x.Count != 0)
                    v.Add($"{{ TargetValue: {name},\n Constraints: []validation.Constraint{{{string.Join(",\n", x)}}}}}");
            }
            return string.Join(",\n", v);
        }
    }
}
