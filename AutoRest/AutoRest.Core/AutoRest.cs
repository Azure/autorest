// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Properties;
using System.Collections.Generic;
using System.Linq;

namespace Microsoft.Rest.Generator
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

            try
            {
                IEnumerable<ValidationMessage> messages = new List<ValidationMessage>();
                serviceClient = modeler.Build(out messages);

                foreach (var message in messages)
                {
                    Logger.Entries.Add(new LogEntry(message.Severity, message.ToString()));
                }

                if (messages.Any(entry => entry.Severity >= settings.ValidationLevel))
                {
                    throw ErrorManager.CreateError("Errors found during Swagger document validation.");
                }
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
            }

            if (serviceClient != null)
            {
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
        }

        public static void Compare(BaseSettings settings)
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
                modeler.Compare();
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
            }
        }
    }
}
