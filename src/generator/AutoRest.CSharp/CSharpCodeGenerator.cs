// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.CSharp.TemplateModels;
using AutoRest.CSharp.Templates;
using AutoRest.Extensions;
using AutoRest = AutoRest.Core.AutoRest;

namespace AutoRest.CSharp
{
    public class CSharpCodeGenerator : CodeGenerator
    {
        private readonly CSharpCodeNamer _namer;
        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.2.2.0";

        public CSharpCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new CSharpCodeNamer();
            IsSingleFileGenerationSupported = true;
        }

        /// <summary>
        /// Indicates whether ctor needs to be generated with internal protection level.
        /// </summary>
        [SettingsInfo("The namespace to use for generated code.")]
        [SettingsAlias("internal")]
        public bool InternalConstructors { get; set; }

        /// <summary>
        /// Specifies mode for generating sync wrappers.
        /// </summary>
        [SettingsInfo("Specifies mode for generating sync wrappers.")]
        [SettingsAlias("syncMethods")]
        public SyncMethodsGenerationMode SyncMethods { get; set; }

        public override string Name
        {
            get { return "CSharp"; }
        }

        public override string Description
        {
            // TODO resource string.
            get { return "Generic C# code generator."; }
        }

        public override string UsageInstructions
        {
            get {
                return string.Format(CultureInfo.InvariantCulture,
                    Properties.Resources.UsageInformation, ClientRuntimePackage);
            }
        }

        public override string ImplementationFileExtension
        {
            get { return ".cs"; }
        }

        public override void PopulateSettings(IDictionary<string, object> settings)
        {
            base.PopulateSettings(settings);
            Settings.PopulateSettings(_namer, settings);
        }

        /// <summary>
        /// Normalizes client model by updating names and types to be language specific.
        /// </summary>
        /// <param name="serviceClient"></param>
        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
            PopulateAdditionalProperties(serviceClient);
            SwaggerExtensions.NormalizeClientModel(serviceClient, Settings);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + "." + Settings.ModelsName);
        }

        private void PopulateAdditionalProperties(ServiceClient serviceClient)
        {
            if (Settings.AddCredentials)
            {
                serviceClient.Properties.Add(new Property
                {
                    Name = "Credentials",
                    Type = new PrimaryType(KnownPrimaryType.Credentials),
                    IsRequired = true,
                    IsReadOnly = true,
                    Documentation = "Subscription credentials which uniquely identify client subscription."
                });
            }
        }

        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <returns></returns>
        public override async Task Generate(ServiceClient serviceClient)
        {
            // Service client
            var serviceClientTemplate = new ServiceClientTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient, InternalConstructors),
            };
            await Write(serviceClientTemplate, serviceClient.Name + ".cs");

            // Service client extensions
            if (serviceClient.Methods.Any(m => m.Group == null))
            {
                var extensionsTemplate = new ExtensionsTemplate
                {
                    Model = new ExtensionsTemplateModel(serviceClient, null, SyncMethods),
                };
                await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");
            }

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient, InternalConstructors),
            };
            await Write(serviceClientInterfaceTemplate, "I" + serviceClient.Name + ".cs");

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsTemplate, operationsTemplate.Model.MethodGroupType + ".cs");

                // Service client extensions
                var operationExtensionsTemplate = new ExtensionsTemplate
                {
                    Model = new ExtensionsTemplateModel(serviceClient, group, SyncMethods),
                };
                await Write(operationExtensionsTemplate, group + "Extensions.cs");

                // Operation interface
                var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group),
                };
                await Write(operationsInterfaceTemplate, "I" + operationsInterfaceTemplate.Model.MethodGroupType + ".cs");
            }

            // Models
            foreach (var model in serviceClient.ModelTypes.Concat(serviceClient.HeaderTypes))
            {
                var modelTemplate = new ModelTemplate
                {
                    Model = new ModelTemplateModel(model),
                };
                await Write(modelTemplate, Path.Combine(Settings.ModelsName, model.Name + ".cs"));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine(Settings.ModelsName, enumTemplate.Model.TypeDefinitionName + ".cs"));
            }

            // Exception
            foreach (var exceptionType in serviceClient.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate
                {
                    Model = new ModelTemplateModel(exceptionType),
                };
                await Write(exceptionTemplate, Path.Combine(Settings.ModelsName, exceptionTemplate.Model.ExceptionTypeDefinitionName + ".cs"));
            }
        }
    }
}
