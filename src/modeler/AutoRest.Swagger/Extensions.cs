// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.IO;
using System.Net;
using AutoRest.Core.ClientModel;
using Newtonsoft.Json;
using YamlDotNet.Serialization;

namespace AutoRest.Swagger
{
    /// <summary>
    /// Provides useful extension methods to simplify common coding tasks.
    /// </summary>
    public static class Extensions
    {
        public static HttpStatusCode ToHttpStatusCode(this string statusCode)
        {
            return (HttpStatusCode) Enum.Parse(typeof (HttpStatusCode), statusCode);
        }

        public static HttpMethod ToHttpMethod(this string verb)
        {
            if (verb == null)
            {
                throw new ArgumentNullException("verb");
            }

            switch (verb.ToLower(CultureInfo.InvariantCulture))
            {
                case "get":
                    return HttpMethod.Get;
                case "post":
                    return HttpMethod.Post;
                case "put":
                    return HttpMethod.Put;
                case "head":
                    return HttpMethod.Head;
                case "delete":
                    return HttpMethod.Delete;
                case "patch":
                    return HttpMethod.Patch;
                case "options":
                    return HttpMethod.Options;
                default:
                    throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Removes #/definitions/ or url#/definitions from the reference path.
        /// </summary>
        /// <param name="reference">Definition reference.</param>
        /// <returns>Definition name with path.</returns>
        public static string StripDefinitionPath(this string reference)
        {
            if (reference != null && reference.Contains("#/definitions/"))
            {
                reference = reference.Substring(reference.IndexOf("#/definitions/", StringComparison.OrdinalIgnoreCase) +
                    "#/definitions/".Length);
            }

            return reference;
        }

        /// <summary>
        /// Removes #/parameters/ or url#/parameters from the reference path.
        /// </summary>
        /// <param name="reference">Parameter reference.</param>
        /// <returns>Parameter name with path.</returns>
        public static string StripParameterPath(this string reference)
        {
            if (reference != null && reference.Contains("#/parameters/"))
            {
                reference = reference.Substring(reference.IndexOf("#/parameters/", StringComparison.OrdinalIgnoreCase) +
                    "#/parameters/".Length);
            }

            return reference;
        }

        public static string EnsureYamlIsJson(this string text)
        {
            // is this something other than JSON?
            if (!string.IsNullOrWhiteSpace(text) && text[0] != '{')
            {
                using (var y = new StringReader(text))
                {
                    using (var s = new StringWriter(CultureInfo.CurrentCulture))
                    {
                        var d = new Deserializer();
                        d.NodeDeserializers.Insert( 0,new YamlBoolDeserializer() );
                        new JsonSerializer().Serialize(s, d.Deserialize(y));
                        return s.ToString();
                    }
                }
            }
            return text;
        }
    }
}