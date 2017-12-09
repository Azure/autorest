// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.CSharp.LoadBalanced.Legacy.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public class TransformerCs : CodeModelTransformer<CodeModelCs>
    {
        public override CodeModelCs TransformCodeModel(CodeModel cs)
        {
            var codeModel = cs as CodeModelCs;
            // we're guaranteed to be in our language-specific context here.

            // add the Credentials
            PopulateAdditionalProperties(codeModel);

            // todo: these should be turned into individual transformers
            SwaggerExtensions.NormalizeClientModel(codeModel);

            // Do parameter transformations
            TransformParameters(codeModel);

            return codeModel;
        }

        protected void TransformParameters(CodeModel codeModel)
        {
            // todo: question -- is this just enforcing names?
            foreach (var method in codeModel.Methods)
                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name =
                        CodeNamer.Instance.GetUnique(
                            CodeNamer.Instance.GetParameterName(parameterTransformation.OutputParameter.GetClientName()),
                            method, method.IdentifiersInScope, method.Children);

                    foreach (var parameterMapping in parameterTransformation.ParameterMappings)
                    {
                        if (parameterMapping.InputParameterProperty != null)
                            parameterMapping.InputParameterProperty =
                                CodeNamer.Instance.GetPropertyName(parameterMapping.InputParameterProperty);

                        if (parameterMapping.OutputParameterProperty != null)
                            parameterMapping.OutputParameterProperty =
                                CodeNamer.Instance.GetPropertyName(parameterMapping.OutputParameterProperty);
                    }
                }
        }

        protected void PopulateAdditionalProperties(CodeModel codeModel)
        {
            if (Settings.Instance.AddCredentials)
                codeModel.Add(New<Property>(new
                {
                    Name = "Credentials",
                    ModelType = New<PrimaryType>(KnownPrimaryType.Credentials),
                    IsRequired = true,
                    IsReadOnly = true,
                    Documentation = "Subscription credentials which uniquely identify client subscription."
                }));
        }
    }
}