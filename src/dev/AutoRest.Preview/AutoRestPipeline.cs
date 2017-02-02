using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;
using AutoRest.Core.Validation;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Core.Logging;

namespace AutoRest
{
    public static class AutoRestPipeline
    {
        private static readonly string autoRestJson = File.ReadAllText("AutoRest.json");
        
        public static MemoryFileSystem GenerateCodeForTest(string json, string codeGenerator, Action<IEnumerable<LogMessage>> processMessages)
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

                GenerateCodeInto(processMessages);

                return fs;
            }
        }

        private static void GenerateCodeInto(Action<IEnumerable<LogMessage>> processMessages)
        {
            using (NewContext)
            {
                var plugin = ExtensionsLoader.GetPlugin();
                var modeler = ExtensionsLoader.GetModeler();
                var messages = new List<LogMessage>();
                Logger.Instance.AddListener(new SignalingLogListener(Category.Info, message => messages.Add(message)));
                try
                {
                    var codeModel = modeler.Build();

                    using (plugin.Activate())
                    {
                        // load model into language-specific code model
                        codeModel = plugin.Serializer.Load(codeModel);

                        // apply language-specific tranformation (more than just language-specific types)
                        // used to be called "NormalizeClientModel" . 
                        codeModel = plugin.Transformer.TransformCodeModel(codeModel);

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
}
