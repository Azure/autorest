// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Diagnostics;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Properties;

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
                FileVersionInfo fvi = FileVersionInfo.GetVersionInfo((typeof (Settings)).Assembly.Location);
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
            ServiceClient serviceClient;
            try
            {
                serviceClient = modeler.Build();
            }
            catch (Exception exception)
            {
                throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel, exception.Message);
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
    }
}
