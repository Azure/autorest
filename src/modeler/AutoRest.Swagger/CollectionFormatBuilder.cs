// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using System.Globalization;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using ParameterLocation = AutoRest.Swagger.Model.ParameterLocation;

namespace AutoRest.Swagger
{
    public static class CollectionFormatBuilder
    {
        public static StringBuilder OnBuildMethodParameter(Method method,
            SwaggerParameter currentSwaggerParam,
            StringBuilder paramNameBuilder)
        {
            if (currentSwaggerParam == null)
            {
                throw new ArgumentNullException("currentSwaggerParam");
            }

            bool hasCollectionFormat = currentSwaggerParam.CollectionFormat != CollectionFormat.None;

            if (currentSwaggerParam.Type == DataType.Array && !hasCollectionFormat)
            {
                // If the parameter type is array default the collectionFormat to csv
                currentSwaggerParam.CollectionFormat = CollectionFormat.Csv;
            }

            if (hasCollectionFormat)
            {
                AddCollectionFormat(currentSwaggerParam, paramNameBuilder);
                if (currentSwaggerParam.In == ParameterLocation.Path)
                {
                    if (method == null || method.Url == null)
                    {
                       throw new ArgumentNullException("method"); 
                    }

                    method.Url = method.Url.Replace(
                        string.Format(CultureInfo.InvariantCulture, "{0}", currentSwaggerParam.Name),
                        string.Format(CultureInfo.InvariantCulture, "{0}", paramNameBuilder));
                }
            }
            return paramNameBuilder;
        }

        private static void AddCollectionFormat(SwaggerParameter swaggerParameter, StringBuilder parameterName)
        {
            if (swaggerParameter.In == ParameterLocation.FormData)
            {
                // http://vstfrd:8080/Azure/RD/_workitems/edit/3172874
                throw new NotImplementedException();
            }

            //Debug.Assert(!string.IsNullOrEmpty(swaggerParameter.CollectionFormat));
            Debug.Assert(swaggerParameter.CollectionFormat != CollectionFormat.None);
            parameterName.Append(":");

            switch (swaggerParameter.CollectionFormat)
            {
                case CollectionFormat.Csv:
                    parameterName.Append("commaSeparated");
                    break;

                case CollectionFormat.Pipes:
                    parameterName.Append("pipeSeparated");
                    break;

                case CollectionFormat.Ssv:
                    parameterName.Append("spaceSeparated");
                    break;

                case CollectionFormat.Tsv:
                    parameterName.Append("tabSeparated");
                    break;

                case CollectionFormat.Multi:
                    if (swaggerParameter.In != ParameterLocation.Query)
                    {
                        throw new NotSupportedException(string.Format(CultureInfo.InvariantCulture,
                            Resources.MultiCollectionFormatNotSupported,
                            swaggerParameter.Name));
                    }
                    parameterName.Append("ampersandSeparated");
                    break;

                default:
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, 
                        Resources.InvalidCollectionFormat,
                        swaggerParameter.CollectionFormat, 
                        swaggerParameter.Name));
            }
        }
    }
}