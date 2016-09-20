// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.NodeJS.Azure.Model;
using AutoRest.NodeJS.Azure.Properties;
using AutoRest.NodeJS.Azure.Templates;
using AutoRest.NodeJS.Model;
using AutoRest.NodeJS.Templates;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.NodeJS.Azure
{
    public class AzureNodeJsCodeModelTransformer : NodeJsModelTransformer
    {
        internal AzureNodeJSCodeGenerator AzureCodeGenerator { get; set; }
        protected override CodeNamer NewCodeNamer => new NodeJsCodeNamer();

        protected override Context InitializeContext()
        {
            // our instance of the codeNamer.
            var codeNamer = NewCodeNamer;

            return new Context
            {
                // inherit anything from the parent class.
                // base.InitializeContext(),

                // on activation of this context, 
                () =>
                {
                    // set the singleton for the code namer.
                    Singleton<CodeNamer>.Instance = codeNamer;

                    // and the c# specific settings
                    Singleton<INodeJsSettings>.Instance = AzureCodeGenerator;
                },

                // add/override our own implementations 
                new Factory<CodeModel, CodeModelJsa>(),
                new Factory<Method, MethodJsa>(),
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
            var codeModel = cm as CodeModelJsa;
            if (codeModel == null)
            {
                throw new InvalidCastException("Code Model is not a nodejs code model.");
            }

            // MethodNames are normalized explicitly to provide a consitent method name while 
            // generating cloned methods for long running operations with reserved words. For
            // example - beginDeleteMethod() insteadof beginDelete() as delete is a reserved word.
            // Namer.NormalizeMethodNames(serviceClient);

            AzureExtensions.NormalizeAzureClientModel(codeModel);

            base.Transform(codeModel);

            NormalizePaginatedMethods(codeModel);
            ExtendAllResourcesToBaseResource(codeModel);

            return codeModel;
        }

        private static void ExtendAllResourcesToBaseResource(CodeModelJsa codeModel)
        {
            if (codeModel != null)
            {
                foreach (var model in codeModel.ModelTypes)
                {
                    if (model.Extensions.ContainsKey(AzureExtensions.AzureResourceExtension) &&
                        (bool)model.Extensions[AzureExtensions.AzureResourceExtension])
                    {
                        model.BaseModelType = New<CompositeType>( new { Name = "BaseResource", SerializedName = "BaseResource" });
                    }
                }
            }
        }

        /// <summary>
        /// Changes paginated method signatures to return Page type.
        /// </summary>
        /// <param name="codeModel"></param>
        public virtual void NormalizePaginatedMethods(CodeModelJsa codeModel)
        {
            if (codeModel == null)
            {
                throw new ArgumentNullException("codeModel");
            }

            foreach (var method in codeModel.Methods.Where(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension)))
            {
                string nextLinkName = null;
                var ext = method.Extensions[AzureExtensions.PageableExtension] as Newtonsoft.Json.Linq.JContainer;
                if (ext == null)
                {
                    continue;
                }

                nextLinkName = (string)ext["nextLinkName"];
                string itemName = (string)ext["itemName"] ?? "value";
                foreach (var responseStatus in method.Responses.Where(r => r.Value.Body is CompositeType).Select(s => s.Key).ToArray())
                {
                    var compositType = (CompositeType)method.Responses[responseStatus].Body;
                    var sequenceType = compositType.Properties.Select(p => p.ModelType).FirstOrDefault(t => t is SequenceType) as SequenceType;

                    // if the type is a wrapper over page-able response
                    if (sequenceType != null)
                    {
                        compositType.Extensions[AzureExtensions.PageableExtension] = true;
                        var pageTemplateModel = new PageCompositeTypeJsa(nextLinkName, itemName).LoadFrom(compositType);
                        // var pageTemplateModel = new PageTemplateModel(compositType, serviceClient, nextLinkName, itemName);
                        if (!codeModel.PageTemplateModels.Contains(pageTemplateModel))
                        {
                            codeModel.PageTemplateModels.Add(pageTemplateModel);
                        }
                    }
                }
            }
        }
    }

    public class AzureNodeJSCodeGenerator : NodeJSCodeGenerator
    {
        private const string ClientRuntimePackage = "ms-rest-azure version 1.15.0";

        public AzureNodeJSCodeGenerator() : this(new AzureNodeJsCodeModelTransformer())
        {
        }

        protected AzureNodeJSCodeGenerator(AzureNodeJsCodeModelTransformer transformer) : base(transformer)
        {
            transformer.AzureCodeGenerator = this;
        }

        public override string Name => "Azure.NodeJS";

        public override string Description => "Azure specific NodeJS code generator.";

        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture,
            Resources.UsageInformation, ClientRuntimePackage);

        public override string ImplementationFileExtension => ".js";


        /// <summary>
        /// Generate Azure NodeJS client code 
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            var codeModel = cm as CodeModelJsa;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a Azure NodeJS code model.");
            }

            // Service client
            var serviceClientTemplate = new AzureServiceClientTemplate { Model = codeModel };
            await Write(serviceClientTemplate, codeModel.Name.ToCamelCase() + ".js");

            if (!DisableTypeScriptGeneration)
            {
                var serviceClientTemplateTS = new AzureServiceClientTemplateTS { Model = codeModel, };
                await Write(serviceClientTemplateTS, codeModel.Name.ToCamelCase() + ".d.ts");
            }

            var modelIndexTemplate = new AzureModelIndexTemplate { Model = codeModel };
            await Write(modelIndexTemplate, Path.Combine("models", "index.js"));

            if (!DisableTypeScriptGeneration)
            {
                var modelIndexTemplateTS = new AzureModelIndexTemplateTS { Model = codeModel };
                await Write(modelIndexTemplateTS, Path.Combine("models", "index.d.ts"));
            }

            //Models
            if (codeModel.ModelTemplateModels.Any())
            {
                // Paged Models
                foreach (var pageModel in codeModel.PageTemplateModels)
                {
                    var pageTemplate = new PageModelTemplate { Model = pageModel };
                    await Write(pageTemplate, Path.Combine("models", pageModel.Name.ToCamelCase() + ".js"));
                }
                
                foreach (var modelType in codeModel.ModelTemplateModels.Where( each => !codeModel.PageTemplateModels.Any( ptm=> ptm.Name.EqualsIgnoreCase(each.Name)) ))
                {
                    var modelTemplate = new ModelTemplate { Model = modelType };
                    await Write(modelTemplate, Path.Combine("models", modelType.Name.ToCamelCase() + ".js"));
                }
            }

            //MethodGroups
            if (codeModel.MethodGroupModels.Any())
            {
                var methodGroupIndexTemplate = new MethodGroupIndexTemplate { Model = codeModel };
                await Write(methodGroupIndexTemplate, Path.Combine("operations", "index.js"));

                if (!DisableTypeScriptGeneration)
                {
                    var methodGroupIndexTemplateTS = new MethodGroupIndexTemplateTS { Model = codeModel };
                    await Write(methodGroupIndexTemplateTS, Path.Combine("operations", "index.d.ts"));
                }
                
                foreach (var methodGroupModel in codeModel.MethodGroupModels)
                {
                    var methodGroupTemplate = new AzureMethodGroupTemplate { Model = methodGroupModel };
                    await Write(methodGroupTemplate, Path.Combine("operations", methodGroupModel.TypeName.ToCamelCase() + ".js"));
                }
            }
        }
    }
}
