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
            using (NewContext)
            {
                int exitCode = (int) ExitCode.Error;

                try
                {
                    bool generationFailed = false;
                    Settings settings = null;
                    try
                    {
                        settings = Settings.Create(args);
                        // set up logging
                        Logger.AddListener(new ConsoleLogListener(
                            settings.Debug ? LogEntrySeverity.Debug : LogEntrySeverity.Info,
                            settings.ValidationLevel));
                        Logger.AddListener(new SignalingLogListener(LogEntrySeverity.Error,  _ => generationFailed = true));

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
                            if (!Settings.Instance.DisableSimplifier && Settings.Instance.CodeGenerator.IndexOf("csharp", StringComparison.OrdinalIgnoreCase) > -1 )
                            {
                                new CSharpSimplifier().Run().ConfigureAwait(false).GetAwaiter().GetResult();
                            }
                        }
                    }
                    catch (CodeGenerationException)
                    {
                        // Do not add the CodeGenerationException again. Will be written in finally block
                    }
                    catch (Exception exception)
                    {
                        Logger.Log(LogEntrySeverity.Error, exception.Message); // FATAL?
                    }
                    finally
                    {
                        if (settings != null && !settings.ShowHelp)
                        {
                            if (generationFailed)
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Log(Resources.GenerationFailed);
                                    Logger.Log(LogEntrySeverity.Error, "{0} {1}",
                                        typeof(Program).Assembly.ManifestModule.Name, string.Join(" ", args));
                                }
                            }
                            else
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Logger.Log(Resources.GenerationComplete,
                                        settings.CodeGenerator, settings.Input);
                                }
                                exitCode = (int) ExitCode.Success;
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