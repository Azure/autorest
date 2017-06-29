// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using AutoRest.Properties;
using AutoRest.Simplify;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.IO;
using AutoRest.Core.Parsing;
using YamlDotNet.RepresentationModel;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            if(args != null && args.Length > 0 && args[0] == "--server") {
              return new AutoRestAsAsService().Run().Result;
            }

            int exitCode = (int)ExitCode.Error;

            try
            {
                using (NewContext)
                {
                    bool generationFailed = false;
                    Settings settings = null;
                    try
                    {
                        settings = Settings.Create(args);

                        // opt into client side validation by default
                        if (!settings.CustomSettings.ContainsKey("ClientSideValidation"))
                        {
                            settings.CustomSettings.Add("ClientSideValidation", true);
                        }

                        Logger.Instance.AddListener(new SignalingLogListener(Category.Error, _ => generationFailed = true));

                        Settings.AutoRestFolder = Path.GetDirectoryName( typeof(Program).GetAssembly().Location);

                        // determine some reasonable default namespace
                        if (settings.Namespace == null)
                        {
                            if (settings.Input != null)
                            {
                                settings.Namespace = Path.GetFileNameWithoutExtension(settings.Input);
                            }
                            else
                            {
                                settings.Namespace = "default";
                            }
                        }

                        // main pipeline
                        AutoRestController.Generate();
                        if (!Settings.Instance.JsonValidationMessages && !Settings.Instance.DisableSimplifier && Settings.Instance.CodeGenerator.IndexOf("csharp", StringComparison.OrdinalIgnoreCase) > -1)
                        {
                            new Simplify.CSharpSimplifier().Run().ConfigureAwait(false).GetAwaiter().GetResult();
                        }
                        if (!settings.JsonValidationMessages)
                        {
                            Settings.Instance.FileSystemOutput.CommitToDisk(Settings.Instance.OutputFileName == null
                                ? Settings.Instance.OutputDirectory
                                : Path.GetDirectoryName(Settings.Instance.OutputFileName));
                        }
                    }
                    catch (Exception exception)
                    {
                        Logger.Instance.Log(Category.Error, exception.Message);
                    }
                    finally
                    {
                        if (settings != null)
                        {
                            if (generationFailed)
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Instance.Log(Category.Error, Resources.GenerationFailed);
                                    Logger.Instance.Log(Category.Error, "{0} {1}",
                                        typeof(Program).GetAssembly().ManifestModule.Name, string.Join(" ", args));
                                }
                            }
                            else
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Instance.Log(Category.Info, Resources.GenerationComplete,
                                        settings.CodeGenerator, settings.Input);
                                }
                                exitCode = (int)ExitCode.Success;
                            }
                        }
                    }
                }
            }
            catch (Exception exception)
            {
                Console.Error.WriteLine(Resources.ConsoleErrorMessage, exception.Message);
                Console.Error.WriteLine(Resources.ConsoleErrorStackTrace, exception.StackTrace);
            }
            return exitCode;
        }

        /// <summary>
        /// Returns true if show markdown flag is specified among the command line arguments.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>True if markdown formatted help should be shown, otherwise false.</returns>
        private static bool IsShowMarkdownHelpIncluded(string[] args)
        {
            if (args.Any(a => a == "-md" || "-markdown".EqualsIgnoreCase(a)))
            {
                return true;
            }
            return false;
        }
    }
}