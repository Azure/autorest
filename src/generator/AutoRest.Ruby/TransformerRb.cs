// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using AutoRest.Ruby.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Ruby
{
    public class TransformerRb : CodeModelTransformer<CodeModelRb> 
    {
        public override CodeModelRb TransformCodeModel(CodeModel cm)
        {
            var codeModel = cm as CodeModelRb;
            SwaggerExtensions.NormalizeClientModel(codeModel);
            PopulateAdditionalProperties(codeModel);
            Flattening(codeModel);

            return codeModel;
        }

        /// <summary>
        ///     Adds special properties to the service client (e.g. credentials).
        /// </summary>
        /// <param name="codeModel">The service client.</param>
        protected void PopulateAdditionalProperties(CodeModelRb codeModel)
        {
            if (Settings.Instance.AddCredentials)
            {
                if (!codeModel.Properties.Any(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Credentials)))
                {
                    codeModel.Add(New<Property>(new
                    {
                        Name = "Credentials",
                        ModelType = New<PrimaryType>(KnownPrimaryType.Credentials),
                        IsRequired = true,
                        Documentation = "Subscription credentials which uniquely identify client subscription."
                    }));
                }
            }
        }
        protected void Flattening(CodeModelRb codeModel)
        {
            foreach (var method in codeModel.Methods)
            {
                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name = method.GetUniqueName(CodeNamer.Instance.GetParameterName(parameterTransformation.OutputParameter.GetClientName()));

                    // QuoteParameter(parameterTransformation.OutputParameter);

                    foreach (var parameterMapping in parameterTransformation.ParameterMappings)
                    {
                        if (parameterMapping.InputParameterProperty != null)
                        {
                            parameterMapping.InputParameterProperty = CodeNamer.Instance.GetPropertyName(parameterMapping.InputParameterProperty);
                        }

                        if (parameterMapping.OutputParameterProperty != null)
                        {
                            parameterMapping.OutputParameterProperty = CodeNamer.Instance.GetPropertyName(parameterMapping.OutputParameterProperty);
                        }
                    }
                }
            }
        }
    }
}
