// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using AutoRest.Core.Model;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Configuration;
using AutoRest.Core.Simplify;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Core
{
    /// <summary>
    /// Entry point for invoking code generation.
    /// </summary>
    public static class AutoRestController
    {
        /// <summary>
        /// Returns the version of this instance of AutoRest.
        /// </summary>
        public static string Version
        {
            get
            {
                FileVersionInfo fvi = FileVersionInfo.GetVersionInfo((typeof(Settings)).Assembly.Location);
                return fvi.FileVersion;
            }
        }

        /// <summary>
        /// Generates client using provided settings.
        /// </summary>
        public static async Task<MemoryFileSystem> Generate(IFileSystem fsInput, AutoRestConfiguration configuration)
        {
            Logger.Instance.Log(Category.Info, Resources.AutoRestCore, Version);

            CodeModel codeModel;

            using (NewContext)
            {
                var modeler = ExtensionsLoader.GetModeler();
                try
                {
                    bool validationErrorFound = false;
                    // TODO
                    //Logger.Instance.AddListener(new SignalingLogListener(Settings.Instance.ValidationLevel, _ => validationErrorFound = true));

                    var serviceDefinition = modeler.Parse(fsInput, configuration.InputFiles);

                    if (configuration.ValidationLinter)
                    {
                        // Look for semantic errors and warnings in the document.
                        var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
                        foreach (var validationEx in validator.GetValidationExceptions(serviceDefinition))
                        {
                            Logger.Instance.Log(validationEx);
                        }
                    }

                    // TODO: meh
                    if (!string.IsNullOrEmpty(configuration.ClientName))
                    {
                        serviceDefinition.Info.Title = configuration.ClientName;
                    }

                    // generate model from swagger 
                    codeModel = modeler.Build(serviceDefinition, configuration.ModelsName, configuration.Namespace);
                }

                catch (Exception exception)
                {
                    throw ErrorManager.CreateError(Resources.ErrorGeneratingClientModel, exception);
                }

                using (NewContext)
                {
                    Settings.ActivateConfiguration(configuration);
                    var plugin = ExtensionsLoader.GetPlugin(configuration);

                    Console.ResetColor();
                    Console.WriteLine(plugin.CodeGenerator.UsageInstructions);

                    try
                    {
                        var genericSerializer = new ModelSerializer<CodeModel>();
                        var modelAsJson = genericSerializer.ToJson(codeModel);

                        // ensure once we're doing language-specific work, that we're working
                        // in context provided by the language-specific transformer. 
                        using (plugin.Activate())
                        {
                            // load model into language-specific code model
                            codeModel = plugin.Serializer.Load(modelAsJson);

                            // apply language-specific tranformation (more than just language-specific types)
                            // used to be called "NormalizeClientModel" . 
                            codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                            // Generate code from CodeModel.
                            await plugin.CodeGenerator.Generate(codeModel);
                        }

                        // TODO: make me a proper pipeline step, make async
                        // pull setting from language specific config!
                        if (!configuration.DisableSimplifier &&
                            Settings.Instance.CodeGenerator.IndexOf("csharp", StringComparison.OrdinalIgnoreCase) > -1)
                        {
                            await new CSharpSimplifier().Run().ConfigureAwait(false);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(Resources.ErrorSavingGeneratedCode, exception);
                    }

                    return Settings.Instance.FileSystemOutput;
                }
            }
        }

        /// <summary>
        /// Compares two specifications.
        /// </summary>
        public static void Compare()
        {
            if (Settings.Instance == null)
            {
                throw new ArgumentNullException("settings");
            }
            Logger.Instance.Log(Category.Info, Resources.AutoRestCore, Version);
            dynamic modeler = ExtensionsLoader.GetModeler(); // TODO *cough*

            try
            {
                IEnumerable<ComparisonMessage> messages = modeler.Compare();

                foreach (var message in messages)
                {
                    Logger.Instance.Log(message);
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(Resources.ErrorGeneratingClientModel, exception);
            }

        }
    }
}
