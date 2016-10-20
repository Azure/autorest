// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.NodeJS.Model;
using static AutoRest.Core.Utilities.DependencyInjection;


namespace AutoRest.NodeJS
{
    public class TransformerJs : CodeModelTransformer<CodeModelJs>
    {
        public override CodeModelJs TransformCodeModel(CodeModel cm)
        {
            var codeModel = cm as CodeModelJs;

            // we're guaranteed to be in our language-specific context here.

            SwaggerExtensions.NormalizeClientModel(codeModel);
            PopulateAdditionalProperties(codeModel);

            NormalizeOdataFilterParameter(codeModel);

            foreach (var method in codeModel.Methods)
            {
                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name =
                        method.GetUniqueName(
                            CodeNamer.Instance.GetParameterName(parameterTransformation.OutputParameter.GetClientName()));

                    foreach (var parameterMapping in parameterTransformation.ParameterMappings)
                    {
                        if (parameterMapping.InputParameterProperty != null)
                        {
                            parameterMapping.InputParameterProperty = 
                                CodeNamer.Instance.GetPropertyName(parameterMapping.InputParameterProperty);
                        }

                        if (parameterMapping.OutputParameterProperty != null)
                        {
                            parameterMapping.OutputParameterProperty =
                                CodeNamer.Instance.GetPropertyName(parameterMapping.OutputParameterProperty);
                        }
                    }
                }
            }

            return codeModel;
        }

        /// <summary>
        ///     Normalize odata filter parameter to PrimaryType.String
        /// </summary>
        /// <param name="client">Service Client</param>
        public void NormalizeOdataFilterParameter(CodeModelJs client)
        {
            if (client == null)
            {
                throw new ArgumentNullException(nameof(client));
            }

            foreach (var method in client.Methods)
            {
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.SerializedName.EqualsIgnoreCase("$filter") &&
                        (parameter.Location == ParameterLocation.Query) &&
                        parameter.ModelType is CompositeType)
                    {
                        parameter.ModelType = New<PrimaryType>(KnownPrimaryType.String);
                    }
                }
            }
        }


        private void PopulateAdditionalProperties(CodeModel codeModel)
        {
            if (Settings.Instance.AddCredentials)
            {
                if (!codeModel.Properties.Any(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    codeModel.Add(New<Property>(new
                    {
                        Name = "credentials",
                        SerializedName = "credentials",
                        ModelType = New<PrimaryType>(KnownPrimaryType.Credentials),
                        IsRequired = true,
                        Documentation = "Subscription credentials which uniquely identify client subscription."
                    }));
                }
            }
        }
    }
}