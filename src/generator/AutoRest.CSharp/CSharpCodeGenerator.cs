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
using AutoRest.CSharp.Model;
using AutoRest.CSharp.Templates;

namespace AutoRest.CSharp
{
    public class CSharpCodeGenerator : CodeGenerator, ICSharpGeneratorSettings
    {
        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.2.2.0";

        protected CSharpCodeGenerator(CSharpModelTransformer transformer) :base(transformer)
        {
            transformer.CodeGenerator = this;
        }

        public CSharpCodeGenerator() : this(new CSharpModelTransformer())
        {
        }

        #region ICSharpGeneratorSettings 
        [SettingsInfo("Indicates whether to use DateTimeOffset instead of DateTime to model date-time types")]
        public bool UseDateTimeOffset { get; set; }

        /// <summary>
        /// Indicates whether ctor needs to be generated with internal protection level.
        /// </summary>
        [SettingsInfo("Indicates whether ctor needs to be generated with internal protection level.")]
        [SettingsAlias("internal")]
        public bool InternalConstructors { get; set; }

        /// <summary>
        /// Specifies mode for generating sync wrappers.
        /// </summary>
        [SettingsInfo("Specifies mode for generating sync wrappers.")]
        [SettingsAlias("syncMethods")]
        public SyncMethodsGenerationMode SyncMethods { get; set; }
        #endregion

        public override bool IsSingleFileGenerationSupported => true;

        public override string Name => "CSharp";

        public override string Description => "Generic C# code generator.";

        public override string UsageInstructions => string.Format(CultureInfo.InvariantCulture,
            Properties.Resources.UsageInformation, ClientRuntimePackage);

        public override string ImplementationFileExtension => ".cs";
        
        /// <summary>
        /// Generates C# code for service client.
        /// </summary>
        /// <param name="cm"></param>
        /// <returns></returns>
        public override async Task Generate(CodeModel cm)
        {
            // get c# specific codeModel
            var codeModel = cm as CodeModelCs;
            if (codeModel == null)
            {
                throw new InvalidCastException("CodeModel is not a c# CodeModel");
            }

            // Service client
            var serviceClientTemplate = new ServiceClientTemplate{ Model = codeModel };
            await Write(serviceClientTemplate, $"{codeModel.Name}{ImplementationFileExtension}" );

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate { Model = codeModel };
            await Write(serviceClientInterfaceTemplate, $"I{codeModel.Name}{ImplementationFileExtension}");

            // operations
            foreach (MethodGroupCs methodGroup in codeModel.Operations)
            {
                if(!methodGroup.Name.IsNullOrEmpty()) { 
                    // Operation
                    var operationsTemplate = new MethodGroupTemplate { Model = methodGroup };
                    await Write(operationsTemplate, $"{operationsTemplate.Model.TypeName}{ImplementationFileExtension}");

                    // Operation interface
                    var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate { Model = methodGroup };
                    await Write(operationsInterfaceTemplate, $"I{operationsInterfaceTemplate.Model.TypeName}{ImplementationFileExtension}");
                }

                var operationExtensionsTemplate = new ExtensionsTemplate { Model = methodGroup };
                await Write(operationExtensionsTemplate, $"{methodGroup.ExtensionTypeName}Extensions{ImplementationFileExtension}");
            }

            // Models
            foreach (CompositeTypeCs model in codeModel.ModelTypes.Union(codeModel.HeaderTypes))
            {
                var modelTemplate = new ModelTemplate{ Model = model };
                await Write(modelTemplate, Path.Combine(Settings.Instance.ModelsName, $"{model.Name}{ImplementationFileExtension}"));
            }

            // Enums
            foreach (EnumTypeCs enumType in codeModel.EnumTypes)
            {
                var enumTemplate = new EnumTemplate { Model = enumType };
                await Write(enumTemplate, Path.Combine(Settings.Instance.ModelsName, $"{enumTemplate.Model.Name}{ImplementationFileExtension}"));
            }

            // Exceptions
            foreach (CompositeTypeCs exceptionType in codeModel.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate { Model = exceptionType, };
                await Write(exceptionTemplate, Path.Combine(Settings.Instance.ModelsName, $"{exceptionTemplate.Model.ExceptionTypeDefinitionName}{ImplementationFileExtension}"));
            }
        }
    }
}
