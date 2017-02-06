// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using AutoRest.Core;
using AutoRest.Properties;
using static AutoRest.Core.Utilities.DependencyInjection;
using AutoRest.Core.Configuration;
using AutoRest.Core.Logging;
using AutoRest.Core.Utilities;
using YamlDotNet.Serialization;

namespace AutoRest
{
    internal class Program
    {
        private static readonly string DefaultConfigurationFileName = "readme.md";

        private static int Main(string[] args)
        {
            using (NewContext)
            {
                // set up logging
                Logger.Instance.AddListener(new ConsoleLogListener(Category.Warning)); // TODO: uhm, grab that from config file later? logging the startup must happen somehow...

                try
                {
                    AutoRestConfiguration configuration;

                    if (Settings.IsLegacyCommand(args))
                    {
                        // Logger.Instance.Log(Category.Warning, "Detected legacy command line arguments."); // TODO: let's go stealth for now
                        configuration = LegacyCLI.Process(args);
                        if (configuration == null)
                        {
                            return (int) ExitCode.Success;
                        }

                        using (var writer = new StringWriter())
                        {
                            new Serializer().Serialize(writer, configuration);
                            //Console.WriteLine(writer); // TODO
                        }
                    }
                    else
                    {
                        var commandLineArgs = CommandLineArguments.Parse(args);

                        // show help if parsing args failed
                        if (commandLineArgs == null)
                        {
                            commandLineArgs = new CommandLineArguments {Help = true};
                        }

                        // if no help was requested, try default config file
                        if (commandLineArgs.ConfigurationFilePath == null && !commandLineArgs.Help)
                        {
                            Logger.Instance.Log(Category.Info, $"No configuration file specified.");
                            if (File.Exists(DefaultConfigurationFileName))
                            {
                                Logger.Instance.Log(Category.Warning, $"Using default configuration file '{DefaultConfigurationFileName}'.");
                                commandLineArgs.ConfigurationFilePath = DefaultConfigurationFileName;
                            }
                            else
                            {
                                commandLineArgs = new CommandLineArguments { Help = true };
                            }
                        }

                        // try load config file, otherwise show help
                        if (commandLineArgs.ConfigurationFilePath != null && !File.Exists(commandLineArgs.ConfigurationFilePath))
                        {
                            Logger.Instance.Log(Category.Warning, $"Configuration file {commandLineArgs.ConfigurationFilePath} not found.");
                            commandLineArgs = new CommandLineArguments {Help = true};
                        }

                        string configurationFile = commandLineArgs.ConfigurationFilePath != null
                            ? new WebClient().DownloadString(commandLineArgs.ConfigurationFilePath)
                            : null;

                        // show help if requested
                        if (commandLineArgs.Help)
                        {
                            if (configurationFile == null)
                            {
                                ShowUsage();
                                return (int)ExitCode.Success;
                            }
                            else
                            {
                                throw new NotImplementedException("no config specific help yet"); // TODO
                            }
                        }

                        configuration = AutoRestConfigurationParser.Parse(configurationFile, commandLineArgs.Settings);
                    }

                    if (!configuration.Validate())
                    {
                        return (int) ExitCode.Error;
                    }

                    bool generationFailed = false;
                    Logger.Instance.AddListener(new SignalingLogListener(Category.Error, _ => generationFailed = true));
                    var fsOut = AutoRestController.Generate(new FileSystem(), configuration).GetAwaiter().GetResult();

                    fsOut.CommitToDisk(configuration.OutputFile == null
                        ? configuration.OutputFolder
                        : Path.GetDirectoryName(configuration.OutputFile));

                    return (int)(generationFailed ? ExitCode.Error : ExitCode.Success);
                }
                catch (Exception exception)
                {
                    Console.Error.WriteLine(Resources.ConsoleErrorMessage, exception.Message);
                    Console.Error.WriteLine(Resources.ConsoleErrorStackTrace, exception.StackTrace);
                    return (int) ExitCode.Error;
                }
            }
        }

        private static void ShowUsage()
        {
            Console.WriteLine(HelpGenerator.Generate(Resources.HelpTextTemplate, new Settings()));
            return;
            // TODO: abandon old help and show new
            Console.WriteLine("AutoRest.exe [help] [<configuration file>.md] [--<key>=<value> ...]");
            Console.WriteLine($"will assume {DefaultConfigurationFileName} as configuration file if none is specified");
        }
    }
}