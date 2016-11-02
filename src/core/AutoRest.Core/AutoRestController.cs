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
        public static void Generate()
        {
            if (Settings.Instance == null)
            {
                throw new ArgumentNullException("settings");
            }
            Logger.Entries.Clear();
            Logger.LogInfo(Resources.AutoRestCore, Version);
            
            CodeModel codeModel = null;
            
            var modeler = ExtensionsLoader.GetModeler();

            try
            {
                IEnumerable<ValidationMessage> messages = new List<ValidationMessage>();

                // generate model from swagger 
                codeModel = modeler.Build(out messages);

                // After swagger Parser
                codeModel = RunExtensions(Trigger.AfterModelCreation, codeModel);

                // After swagger Parser
                codeModel = RunExtensions(Trigger.BeforeLoadingLanguageSpecificModel, codeModel);

                foreach (var message in messages)
                {
                    Logger.Entries.Add(new LogEntry(message.Severity, message.ToString()));
                }

                if (messages.Any(entry => entry.Severity >= Settings.Instance.ValidationLevel))
                {
                    throw ErrorManager.CreateError(null, Resources.ErrorGeneratingClientModel, "Errors found during Swagger validation");
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
            }

            var plugin = ExtensionsLoader.GetPlugin();

            Logger.WriteOutput(plugin.CodeGenerator.UsageInstructions);

            Settings.Instance.Validate();
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

                    // we've loaded the model, run the extensions for after it's loaded
                    codeModel = RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);
     
                    // apply language-specific tranformation (more than just language-specific types)
                    // used to be called "NormalizeClientModel" . 
                    codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                    // next set of extensions
                    codeModel = RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);


                    // next set of extensions
                    codeModel = RunExtensions(Trigger.BeforeGeneratingCode, codeModel);

                    // Generate code from CodeModel.
                    plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
            }
        }

        public static CodeModel RunExtensions(Trigger trigger, CodeModel codeModel)
        {
            /*
             foreach (var extension in extensions.Where(each => each.trigger == trugger).SortBy(each => each.Priority))
                 codeModel = extension.Transform(codeModel);
            */

            return codeModel;
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
            Logger.Entries.Clear();
            Logger.LogInfo(Resources.AutoRestCore, Version);
            Modeler modeler = ExtensionsLoader.GetModeler();

            try
            {
                IEnumerable<ComparisonMessage> messages = modeler.Compare();

                foreach (var message in messages)
                {
                    Logger.Entries.Add(new LogEntry(message.Severity, message.ToString()));
                }

            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
            }

        }
    }
}
