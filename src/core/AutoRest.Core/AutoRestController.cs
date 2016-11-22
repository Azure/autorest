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
using IAnyPlugin = AutoRest.Core.Extensibility.IPlugin<AutoRest.Core.Extensibility.IGeneratorSettings, AutoRest.Core.IModelSerializer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.ITransformer, AutoRest.Core.CodeGenerator, AutoRest.Core.CodeNamer, AutoRest.Core.Model.CodeModel>;

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
            Settings.Instance.Validate();
            if (string.IsNullOrWhiteSpace(Settings.Instance.Input))
            {
                throw ErrorManager.CreateError(Resources.InputRequired);
            }

            IAnyPlugin plugin = null;

            // FIXED SCHEDULE
            var messages = new List<ValidationMessage>();
            var schedule = Schedule.FromLinearPipeline(
                ExtensionsLoader.GetParser(),
                new FuncTransformer<object, object>("SwaggerValidation", serviceDefinition =>
                {
                    var validator = new RecursiveObjectValidator(PropertyNameResolver.JsonName);
                    messages.AddRange(validator.GetValidationExceptions(serviceDefinition));
                    return serviceDefinition;
                }),
                ExtensionsLoader.GetModeler(),
                new FuncTransformer<CodeModel, CodeModel>("AfterModelCreation", codeModel =>
                {
                    try
                    {
                        return RunExtensions(Trigger.AfterModelCreation, codeModel);
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel,
                            exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, CodeModel>("BeforeLoadingLanguageSpecificModel", codeModel =>
                {
                    try
                    {
                        return RunExtensions(Trigger.BeforeLoadingLanguageSpecificModel, codeModel);
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel,
                            exception.Message);
                    }
                }),
                new ActionTransformer<object>("Logging", codeModel =>
                {
                    try
                    {
                        foreach (var message in messages)
                        {
                            Logger.Entries.Add(new LogEntry(message.Severity, message.ToString()));
                        }

                        if (messages.Any(entry => entry.Severity >= Settings.Instance.ValidationLevel))
                        {
                            throw ErrorManager.CreateError(null, Resources.ErrorGeneratingClientModel,
                                "Errors found during Swagger validation");
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorGeneratingClientModel,
                            exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, string>("model2json", codeModel => new ModelSerializer<CodeModel>().ToJson(codeModel)),
                new ActionTransformer<string>("load plugin", _ =>
                {
                    plugin = ExtensionsLoader.GetPlugin();
                    Logger.WriteOutput(plugin.CodeGenerator.UsageInstructions);
                }),
                //new FuncTransformer<string, CodeModel>(async json =>
                //{
                //    try
                //    {
                //        using (plugin.Activate())
                //        {
                //            var codeModel = plugin.Serializer.Load(json);
                //            codeModel = RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);
                //            codeModel = await plugin.Transformer.Transform(codeModel) as CodeModel;
                //            codeModel = RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);
                //            codeModel = RunExtensions(Trigger.BeforeGeneratingCode, codeModel);
                //            await plugin.CodeGenerator.Generate(codeModel);
                //            return codeModel;
                //        }
                //    }
                //    catch (Exception exception)
                //    {
                //        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                //    }
                //}),
                new FuncTransformer<string, CodeModel>("json2model", json =>
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // load model into language-specific code model
                            return plugin.Serializer.Load(json);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, CodeModel>("AfterLoadingLanguageSpecificModel", codeModel =>
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // we've loaded the model, run the extensions for after it's loaded
                            return RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, CodeModel>("plugin.Transformer", async codeModel =>
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // apply language-specific tranformation (more than just language-specific types)
                            // used to be called "NormalizeClientModel" . 
                            return await plugin.Transformer.TransformAsync(codeModel) as CodeModel;
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, CodeModel>("AfterLanguageSpecificTransform", codeModel =>
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // next set of extensions
                            return RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                }),
                new FuncTransformer<CodeModel, CodeModel>("BeforeGeneratingCode", codeModel =>
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // next set of extensions
                            return RunExtensions(Trigger.BeforeGeneratingCode, codeModel);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                }),
                new ActionTransformer<CodeModel>("generate code", async codeModel => // TODO: return MemoryFS containing code
                {
                    try
                    {
                        using (plugin.Activate())
                        {
                            // Generate code from CodeModel.
                            await plugin.CodeGenerator.Generate(codeModel);
                        }
                    }
                    catch (Exception exception)
                    {
                        throw ErrorManager.CreateError(exception, Resources.ErrorSavingGeneratedCode, exception.Message);
                    }
                })
            );

                    
            //Logger.LogInfo(Resources.ParsingSwagger);
            var input = Settings.Instance.FileSystem.ReadFileAsText(Settings.Instance.Input);

            //if (serviceDefinition == null)
            //{
            //    throw ErrorManager.CreateError("Resources.ErrorParsingSpec"); 
            //    // TODO: extract that into Transformer! Or is there any transformer that may return null?
            //}

            schedule.Run(input).GetAwaiter().GetResult();
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
