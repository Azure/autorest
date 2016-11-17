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
                    Settings settings = null;
                    try
                    {
                        settings = Settings.Create(args);
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
                        Logger.LogError(exception, exception.Message);
                    }
                    finally
                    {
                        if (
                            Logger.Entries.Any(
                                e => e.Severity == LogEntrySeverity.Error || e.Severity == LogEntrySeverity.Fatal))
                        {
                            Console.ForegroundColor = ConsoleColor.Red;
                        }
                        else if (Logger.Entries.Any(e => e.Severity == LogEntrySeverity.Warning))
                        {
                            Console.ForegroundColor = ConsoleColor.Yellow;
                        }

                        if (settings != null && !settings.ShowHelp)
                        {
                            if (Logger.Entries.Any(e => e.Severity == LogEntrySeverity.Error || e.Severity == LogEntrySeverity.Fatal))
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Console.WriteLine(Resources.GenerationFailed);
                                    Console.WriteLine(string.Format(CultureInfo.InvariantCulture, "{0} {1}",
                                        typeof(Program).Assembly.ManifestModule.Name,
                                        string.Join(" ", args)));
                                }
                            }
                            else
                            {
                                if (!"None".EqualsIgnoreCase(settings.CodeGenerator))
                                {
                                    Console.WriteLine(Resources.GenerationComplete,
                                        settings.CodeGenerator, settings.Input);
                                }
                                exitCode = (int) ExitCode.Success;
                            }
                        }

                        // Write all messages to Console
                        var validationLevel = settings?.ValidationLevel ?? LogEntrySeverity.Error;
                        var shouldShowVerbose = settings?.Verbose ?? false;
                        var shouldShowDebug = settings?.Debug ?? false;
                        foreach (var severity in (LogEntrySeverity[]) Enum.GetValues(typeof(LogEntrySeverity)))
                        {
                            if (severity == LogEntrySeverity.Debug && !shouldShowDebug)
                            {
                                continue;
                            }

                            // Determine if this severity of messages should be treated as errors
                            bool isErrorMessage = severity >= validationLevel;
                            // Set the output stream based on if the severity should be an error or not
                            var outputStream = isErrorMessage ? Console.Error : Console.Out;
                            // If it's an error level severity or we want to see all output, write to console
                            if (isErrorMessage || shouldShowVerbose)
                            {
                                // write out the message
                                Logger.WriteMessages(outputStream, severity, shouldShowVerbose, severity.GetColorForSeverity());
                            }
                        }
                        Console.ResetColor();
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