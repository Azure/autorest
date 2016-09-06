// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using AutoRest.Core.ClientModel;
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
    public static class AutoRest
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
        /// <param name="settings">Code generator settings.</param>
        public static void Generate(Settings settings)
        {
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }
            Logger.Entries.Clear();
            Logger.LogInfo(Resources.AutoRestCore, Version);
            Modeler modeler = ExtensionsLoader.GetModeler(settings);
            ServiceClient serviceClient = null;

            IEnumerable<ValidationMessage> messages = new List<ValidationMessage>();
            try
            {
                serviceClient = modeler.Build(out messages);
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
            }
            finally
            {
                // Make sure to log any validation messages
                foreach (var message in messages)
                {
                    Logger.Entries.Add(new LogEntry(message.Severity, message.ToString()));
                }
                if (messages.Any(entry => entry.Severity >= settings.ValidationLevel))
                {
                    throw ErrorManager.CreateError(null, Resources.ErrorGeneratingClientModel, Resources.CodeGenerationError);
                }
            }

            CodeGenerator codeGenerator = ExtensionsLoader.GetCodeGenerator(settings);
            Logger.WriteOutput(codeGenerator.UsageInstructions);

            settings.Validate();
            try
            {
                codeGenerator.NormalizeClientModel(serviceClient);
                codeGenerator.Generate(serviceClient).GetAwaiter().GetResult();
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
            }
        }

        /// <summary>
        /// Compares two specifications.
        /// </summary>
        /// <param name="settings">Code generator settings.</param>
        public static void Compare(Settings settings)
        {
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }
            Logger.Entries.Clear();
            Logger.LogInfo(Resources.AutoRestCore, Version);
            Modeler modeler = ExtensionsLoader.GetModeler(settings);

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
