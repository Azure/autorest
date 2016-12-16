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

namespace AutoRest
{
    internal class Program
    {
        private static int Main(string[] args)
        {
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
                        // set up logging
                        Logger.Instance.AddListener(new ConsoleLogListener(
                            settings.Debug ? Category.Debug : Category.Warning,
                            settings.ValidationLevel,
                            settings.Verbose));
                        Logger.Instance.AddListener(new SignalingLogListener(Category.Error, _ => generationFailed = true));

                        string defCodeGen = (args.Where(arg => arg.ToLowerInvariant().Contains("codegenerator")).IsNullOrEmpty()) ? "" : settings.CodeGenerator;
                        if (settings.ShowHelp && IsShowMarkdownHelpIncluded(args))
                        {
                            settings.CodeGenerator = defCodeGen;
                            Console.WriteLine(HelpGenerator.Generate(Resources.HelpMarkdownTemplate, settings));
                        }
                        else if (settings.ShowHelp)
                        {
                            settings.CodeGenerator = defCodeGen;
                            Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate, settings));
                        }
                        else if (!string.IsNullOrEmpty(settings.Previous))
                        {
                            Core.AutoRestController.Compare();
                        }
                        else
                        {
                            Core.AutoRestController.Generate();
                            if (!Settings.Instance.DisableSimplifier && Settings.Instance.CodeGenerator.IndexOf("csharp", StringComparison.OrdinalIgnoreCase) > -1)
                            {
                                new CSharpSimplifier().Run().ConfigureAwait(false).GetAwaiter().GetResult();
                            }
                        }
                    }
                    catch (Exception exception)
                    {
                        Logger.Instance.Log(Category.Error, exception.Message);
                    }
                    finally
                    {
                        if (settings != null && !settings.ShowHelp)
                        {
                            if (generationFailed)
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Instance.Log(Category.Error, Resources.GenerationFailed);
                                    Logger.Instance.Log(Category.Error, "{0} {1}",
                                        typeof(Program).Assembly.ManifestModule.Name, string.Join(" ", args));
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