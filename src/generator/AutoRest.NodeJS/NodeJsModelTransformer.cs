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
    public class NodeJsModelTransformer : CodeModelTransformer
    {
        protected internal NodeJSCodeGenerator CodeGenerator { get; set; }
        protected virtual CodeNamer NewCodeNamer => new NodeJsCodeNamer();

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
                    Singleton<INodeJsSettings>.Instance = CodeGenerator;
                },

                // add/override our own implementations 
                new Factory<CodeModel, CodeModelJs>(),
                new Factory<Method, MethodJs>(),
                new Factory<CompositeType, CompositeTypeJs>(),
                new Factory<Property, PropertyJs>(),
                new Factory<Parameter, ParameterJs>(),
                new Factory<DictionaryType, DictionaryTypeJs>(),
                new Factory<SequenceType, SequenceTypeJs>(),
                new Factory<MethodGroup, MethodGroupJs>(),
                 new Factory<EnumType, EnumType>(),
                new Factory<PrimaryType, PrimaryTypeJs>(),

            };
        }

        protected override CodeModel Transform(CodeModel cm)
        {
            var codeModel = cm as CodeModelJs;
            if (codeModel == null)
            {
                throw new InvalidCastException("Code Model is not a nodejs code model.");
            }

            // we're guaranteed to be in our language-specific context here.

            SwaggerExtensions.NormalizeClientModel(codeModel);
            PopulateAdditionalProperties(codeModel);

            NormalizeOdataFilterParameter(codeModel);

            foreach (var method in codeModel.Methods)
            {
                foreach (var parameterTransformation in method.InputParameterTransformation)
                {
                    parameterTransformation.OutputParameter.Name =

                    parameterTransformation.OutputParameter.Name =
                        method.GetUniqueName(
                            CodeNamer.Instance.GetParameterName(parameterTransformation.OutputParameter.GetClientName()));
                    // parameterTransformation.OutputParameter.Type = NormalizeTypeReference(parameterTransformation.OutputParameter.Type);

                    // QuoteParameter(parameterTransformation.OutputParameter);

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
                throw new ArgumentNullException("client");
            }

            foreach (var method in client.Methods)
            {
                foreach (var parameter in method.Parameters)
                {
                    if (parameter.SerializedName.Equals("$filter", StringComparison.OrdinalIgnoreCase) &&
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