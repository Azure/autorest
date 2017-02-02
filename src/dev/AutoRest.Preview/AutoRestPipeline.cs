using System;
using System.Collections.Generic;
using System.IO;
using AutoRest.Core;
using AutoRest.Core.Configuration;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Preview
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
                    CodeGenerator = codeGenerator,
                    Namespace = "Test",
                    Input = "input.json"
                };

                fs.WriteAllText(settings.Input, json);
                fs.WriteAllText("AutoRest.json", autoRestJson);

                GenerateCodeInto(fs, processMessages);

                return settings.FileSystemOutput;
            }
        }

        private static void GenerateCodeInto(IFileSystem fs, Action<IEnumerable<LogMessage>> processMessages)
        {
            using (NewContext)
            {
                var config = AutoRestConfiguration.Create();
                config.CodeGenerator = Settings.Instance.CodeGenerator;
                var plugin = ExtensionsLoader.GetPlugin(config);
                var modeler = ExtensionsLoader.GetModeler(Settings.Instance.Modeler);
                var messages = new List<LogMessage>();
                Logger.Instance.AddListener(new SignalingLogListener(Category.Info, message => messages.Add(message)));
                try
                {
                    var codeModel = modeler.Build(fs, new [] { Settings.Instance.Input });

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
