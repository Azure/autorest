// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Model;
using AutoRest.Extensions;
using static AutoRest.Core.Utilities.DependencyInjection;
using MethodGroup = AutoRest.Core.Model.MethodGroup;

namespace AutoRest.CSharp
{
    public class CSharpModelTransformer : CodeModelTransformer
    {
        internal CSharpCodeGenerator CodeGenerator { get; set; }
        protected virtual CodeNamer  NewCodeNamer => new CSharpCodeNamer();

        protected override Context InitializeContext()
        {
            // our instance of the codeNamer.
            var codeNamer = NewCodeNamer;

            return new Context
            {
                // inherit anything from the parent class.
                base.InitializeContext(),

                // on activation of this context, 
                () =>
                {
                    // set the singleton for the code namer.
                    Singleton<CodeNamer>.Instance = codeNamer;

                    // and the c# specific settings
                    Singleton<ICSharpGeneratorSettings>.Instance = CodeGenerator;
                },

                // add/override our own implementations 
                new Factory<CodeModel> {() => new CodeModelCs(CodeGenerator.InternalConstructors)},
                new Factory<EnumType, EnumTypeCs>(),
                new Factory<Method, MethodCs>(),
                new Factory<CompositeType, CompositeTypeCs>(),
                new Factory<Parameter, ParameterTemplateCs>(),
                new Factory<Property, PropertyCs>(),
                new Factory<PrimaryType, PrimaryTypeCs>(),
                new Factory<DictionaryType, DictionaryTypeCs>(),
                new Factory<SequenceType, SequenceTypeCs>(),
                new Factory<MethodGroup, MethodGroupCs>(),
            };
        }

        protected override CodeModel Transform(CodeModel codeModel)
        {
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