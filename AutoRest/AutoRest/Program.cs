// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.Cli.Properties;
using Microsoft.Rest.Generator.Extensibility;
using Microsoft.Rest.Generator.Logging;

namespace Microsoft.Rest.Generator.Cli
{
    internal class Program
    {
        private static int Main(string[] args)
        {
            int exitCode = (int)ExitCode.Error;

            try
            {
                Settings settings = null;
                try
                {
                    settings = Settings.Create(args);
                    if (settings.ShowHelp && IsShowMarkdownHelpIncluded(args))
                    {
                        Console.WriteLine(HelpGenerator.Generate(Resources.HelpMarkdownTemplate, settings));
                    }
                    else if (settings.ShowHelp)
                    {
                        Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate, settings));
                    }
                    else
                    {
                        AutoRest.Generate(settings);
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
                            Console.WriteLine(Resources.GenerationFailed);
                            Console.WriteLine(string.Format(CultureInfo.InvariantCulture, "{0} {1}",
                                typeof(Program).Assembly.ManifestModule.Name,
                                string.Join(" ", args)));
                        }
                        else
                        {
                            Console.WriteLine(Resources.GenerationComplete,
                                settings.CodeGenerator, settings.Input);
                            exitCode = (int)ExitCode.Success;
                        }
                    }

                    Console.ResetColor();
                    // Include LogEntrySeverity.Infos for verbose logging.
                    if (args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)))
                    {
                        Console.ForegroundColor = ConsoleColor.White;
                        Logger.WriteInfos(Console.Out);
                    }

                    Console.ForegroundColor = ConsoleColor.Yellow;
                    Logger.WriteWarnings(Console.Out);

                    Console.ForegroundColor = ConsoleColor.Red;
                    Logger.WriteErrors(Console.Error,
                        args.Any(a => "-Verbose".Equals(a, StringComparison.OrdinalIgnoreCase)));

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

        /// <summary>
        /// Returns true if show markdown flag is specified among the command line arguments.
        /// </summary>
        /// <param name="args">Command line arguments.</param>
        /// <returns>True if markdown formatted help should be shown, otherwise false.</returns>
        private static bool IsShowMarkdownHelpIncluded(string[] args)
        {
            if (args.Any(a => a == "-md" || "-markdown".Equals(a, StringComparison.OrdinalIgnoreCase)))
            {
                return true;
            }
            return false;
        }
    }
}