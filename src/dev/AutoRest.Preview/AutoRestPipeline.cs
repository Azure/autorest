﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest
{
    public static class AutoRestPipeline
    {
        private static readonly string autoRestJson = File.ReadAllText("AutoRest.json");
        
        public static async Task<MemoryFileSystem> GenerateCodeForTest(string json, string codeGenerator, Action<IEnumerable<ValidationMessage>> processMessages)
        {
            using (NewContext)
            {
                var fs = new MemoryFileSystem();
                var settings = new Settings
                {
                    Modeler = "Swagger",
                    CodeGenerator = codeGenerator,
                    FileSystem = fs,
                    OutputDirectory = "GeneratedCode",
                    Namespace = "Test",
                    Input = "input.json"
                };

                fs.WriteFile(settings.Input, json);
                fs.WriteFile("AutoRest.json", autoRestJson);

                await GenerateCodeInto(processMessages);

                return fs;
            }
        }

        private static async Task GenerateCodeInto(Action<IEnumerable<ValidationMessage>> processMessages)
        {
            var plugin = ExtensionsLoader.GetPlugin();
            var modeler = ExtensionsLoader.GetModeler();
            IEnumerable<ValidationMessage> messages = Enumerable.Empty<ValidationMessage>();
            try
            {
                var codeModel = modeler.Build();

                // After swagger Parser
                codeModel = AutoRestController.RunExtensions(Trigger.AfterModelCreation, codeModel);

                // After swagger Parser
                codeModel = AutoRestController.RunExtensions(Trigger.BeforeLoadingLanguageSpecificModel, codeModel);

                using (plugin.Activate())
                {
                    // load model into language-specific code model
                    codeModel = plugin.Serializer.Load(codeModel);

                    // we've loaded the model, run the extensions for after it's loaded
                    codeModel = AutoRestController.RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);

                    // apply language-specific tranformation (more than just language-specific types)
                    // used to be called "NormalizeClientModel" . 
                    codeModel = await plugin.Transformer.Transform(codeModel) as CodeModel;

                    // next set of extensions
                    codeModel = AutoRestController.RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);

                    // next set of extensions
                    codeModel = AutoRestController.RunExtensions(Trigger.BeforeGeneratingCode, codeModel);

                    // Generate code from CodeModel.
                    plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
                }
            }
            finally
            {
                processMessages(messages);
            }
        }
    }
}
