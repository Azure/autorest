// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using System.Globalization;
using System.Text;
using AutoRest.Core.Model;
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
                if (currentSwaggerParam.In == ParameterLocation.Path)
                {
                    if (method == null || method.Url == null)
                    {
                       throw new ArgumentNullException("method"); 
                    }

                    method.Url = ((string)method.Url).Replace(
                        string.Format(CultureInfo.InvariantCulture, "{0}", currentSwaggerParam.Name),
                        string.Format(CultureInfo.InvariantCulture, "{0}", paramNameBuilder));
                }
            }
            return paramNameBuilder;
        }
    }
}