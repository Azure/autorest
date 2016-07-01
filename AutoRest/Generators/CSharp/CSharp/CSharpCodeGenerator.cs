// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Globalization;
using System.Threading.Tasks;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.CSharp.Templates;
using System.Linq;
using System.Reflection;
using Microsoft.Rest.Generator.CSharp.Properties;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Generator.CSharp
{
    public class CSharpCodeGenerator : CodeGenerator
    {
        private readonly CSharpCodeNamer _namer;
        private const string ClientRuntimePackage = "Microsoft.Rest.ClientRuntime.2.2.0";

        public CSharpCodeGenerator(Settings settings) : base(settings)
        {
            _namer = new CSharpCodeNamer();
            ReferencedNamespaces = new HashSet<string>();
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

        /// <summary>
        /// Allows a client to reference models from another assembly instead of generating new models
        /// </summary>
        [SettingsInfo("ExternalModelAssemblies")]
        [SettingsAlias("modelAssemblies")]
        public string[] ExternalModelAssemblies { get; set; }

        /// <summary>
        /// Referenced namespaces
        /// </summary>
        public HashSet<string> ReferencedNamespaces { get; private set; }

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
            get
            {
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
            ReferencedNamespaces.UnionWith(ResolveExternalReferences(serviceClient));
            PopulateAdditionalProperties(serviceClient);
            Extensions.NormalizeClientModel(serviceClient, Settings);
            _namer.NormalizeClientModel(serviceClient);
            _namer.ResolveNameCollisions(serviceClient, Settings.Namespace,
                Settings.Namespace + ".Models");
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

        [SuppressMessage("Microsoft.Reliability", "CA2001:AvoidCallingProblematicMethods", MessageId = "System.Reflection.Assembly.LoadFrom")]
        private HashSet<string> ResolveExternalReferences(ServiceClient serviceClient)
        {
            List<Assembly> referenceAssemblies = new List<Assembly>();
            if (ExternalModelAssemblies == null)
                return new HashSet<string>();
            foreach (var assemblyPath in ExternalModelAssemblies)
            {
                var a = Assembly.LoadFrom(assemblyPath);
                if (a != null)
                {
                    referenceAssemblies.Add(a);
                }
                else
                {
                    Logger.LogError(new ArgumentException("ExternalModelAssemblies"),
                        Properties.Resources.ReferenceAssemblyFailure, assemblyPath);
                }
            }
            return ResolveExternalReferences(serviceClient, referenceAssemblies);
        }

        /// <summary>
        /// Looks for model types in external assemblies. When found, the model is removed from the serviceClient ModelTypes
        /// and the external namespace is added to the returned hashset.
        /// This method could potentially be moved to Extensions.cs
        /// </summary>
        /// <param name="serviceClient"></param>
        /// <param name="referenceAssemblies"></param>
        /// <returns></returns>
        private static HashSet<string> ResolveExternalReferences(ServiceClient serviceClient, ICollection<Assembly> referenceAssemblies)
        {
            HashSet<string> modelTypesToRemove = new HashSet<string>();
            HashSet<string> modelNamespaces = new HashSet<string>();
            HashSet<string> modelNames = new HashSet<string>(serviceClient.ModelTypes.Select(m => m.Name));

            var matchingExportedTypes =
                referenceAssemblies.SelectMany(t => t.ExportedTypes).Where(t => modelNames.Contains(t.Name)).ToList();
            foreach(var typeGroup in matchingExportedTypes.GroupBy(t => t.Name))
            {
                if (typeGroup.Count() == 1)
                {
                    modelTypesToRemove.Add(typeGroup.Key);
                    modelNamespaces.Add(matchingExportedTypes[0].Namespace);
                }
                else if (matchingExportedTypes.Count > 1)
                {
                    Logger.LogError(new ArgumentException("ExternalModelAssemblies"),
                            Properties.Resources.ConflictingTypesError, typeGroup.Key,
                            string.Join(", ", referenceAssemblies.Select(a => a.GetName())));
                }
            }
            foreach (var model in modelTypesToRemove)
            {
                serviceClient.ModelTypes.RemoveWhere(t => t.Name.Equals(model));
            }
            return modelNamespaces;
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
                Model = new ServiceClientTemplateModel(serviceClient, InternalConstructors, ReferencedNamespaces)
            };
            await Write(serviceClientTemplate, serviceClient.Name + ".cs");

            // Service client extensions
            if (serviceClient.Methods.Any(m => m.Group == null))
            {
                var extensionsTemplate = new ExtensionsTemplate
                {
                    Model = new ExtensionsTemplateModel(serviceClient, null, SyncMethods, ReferencedNamespaces),
                };
                await Write(extensionsTemplate, serviceClient.Name + "Extensions.cs");
            }

            // Service client interface
            var serviceClientInterfaceTemplate = new ServiceClientInterfaceTemplate
            {
                Model = new ServiceClientTemplateModel(serviceClient, InternalConstructors, ReferencedNamespaces),
            };
            await Write(serviceClientInterfaceTemplate, "I" + serviceClient.Name + ".cs");

            // Operations
            foreach (var group in serviceClient.MethodGroups)
            {
                // Operation
                var operationsTemplate = new MethodGroupTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group, ReferencedNamespaces),
                };
                await Write(operationsTemplate, operationsTemplate.Model.MethodGroupType + ".cs");

                // Service client extensions
                var operationExtensionsTemplate = new ExtensionsTemplate
                {
                    Model = new ExtensionsTemplateModel(serviceClient, group, SyncMethods, ReferencedNamespaces),
                };
                await Write(operationExtensionsTemplate, group + "Extensions.cs");

                // Operation interface
                var operationsInterfaceTemplate = new MethodGroupInterfaceTemplate
                {
                    Model = new MethodGroupTemplateModel(serviceClient, group, ReferencedNamespaces),
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
                await Write(modelTemplate, Path.Combine("Models", model.Name + ".cs"));
            }

            // Enums
            foreach (var enumType in serviceClient.EnumTypes)
            {
                var enumTemplate = new EnumTemplate
                {
                    Model = new EnumTemplateModel(enumType),
                };
                await Write(enumTemplate, Path.Combine("Models", enumTemplate.Model.TypeDefinitionName + ".cs"));
            }

            // Exception
            foreach (var exceptionType in serviceClient.ErrorTypes)
            {
                var exceptionTemplate = new ExceptionTemplate
                {
                    Model = new ModelTemplateModel(exceptionType),
                };
                await Write(exceptionTemplate, Path.Combine("Models", exceptionTemplate.Model.ExceptionTypeDefinitionName + ".cs"));
            }
        }
    }
}
