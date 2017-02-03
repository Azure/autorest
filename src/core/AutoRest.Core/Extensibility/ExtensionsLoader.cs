// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Configuration;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using IAnyPlugin = AutoRest.Core.Extensibility.IPlugin<AutoRest.Core.Extensibility.IGeneratorSettings, AutoRest.Core.IModelSerializer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.ITransformer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.CodeGenerator, AutoRest.Core.CodeNamer, AutoRest.Core.Model.CodeModel>;
namespace AutoRest.Core.Extensibility
{
    public static class ExtensionsLoader
    {
        public static IAnyPlugin GetPlugin(AutoRestConfiguration configuration)
        {
            Logger.Instance.Log(Category.Info, Resources.InitializingCodeGenerator);
            if (configuration == null)
            {
                throw new ArgumentNullException("configuration");
            }

            if (string.IsNullOrEmpty(configuration.CodeGenerator))
            {
                throw new ArgumentException(
                    string.Format(CultureInfo.InvariantCulture,
                        Resources.ParameterValueIsMissing, "CodeGenerator"));
            }

            IAnyPlugin plugin = null;

            if (configuration.CodeGenerator.EqualsIgnoreCase("None"))
            {
                plugin = new NoOpPlugin();
            }
            else
            {
                plugin = LoadTypeFromAssembly<IAnyPlugin>(configuration.Plugins, configuration.CodeGenerator);
                Settings.PopulateSettings(plugin.Settings, configuration.CustomSettings);
            }
            Logger.Instance.Log(Category.Info, Resources.GeneratorInitialized,
                configuration.CodeGenerator,
                plugin.GetType().Assembly.GetName().Version);
            return plugin;
        }

        /// <summary>
        /// Gets the modeler specified in the provided Settings.
        /// </summary>
        /// <returns>Modeler specified in Settings.Modeler</returns>
        public static dynamic GetModeler()
        {
            Logger.Instance.Log(Category.Info, Resources.InitializingModeler);

            var modeler = LoadTypeFromAssembly<dynamic>(new Dictionary<string, AutoRestProviderConfiguration>
            {
                { "Swagger", new AutoRestProviderConfiguration {TypeName = "SwaggerModeler, AutoRest.Swagger"} },
            }, "Swagger");

            Logger.Instance.Log(Category.Info, Resources.ModelerInitialized,
                "Swagger",
                modeler.GetType().Assembly.GetName().Version);
            return modeler;
        }

        [SuppressMessage("Microsoft.Reliability", "CA2001:AvoidCallingProblematicMethods", MessageId = "System.Reflection.Assembly.LoadFrom")]
        public static T LoadTypeFromAssembly<T>(IDictionary<string, AutoRestProviderConfiguration> section,
            string key)
        {
            T instance = default(T);

            if (section != null && !section.IsNullOrEmpty() && section.ContainsKey(key))
            {
                string fullTypeName = section[key].TypeName;
                if (string.IsNullOrEmpty(fullTypeName))
                {
                    throw ErrorManager.CreateError(Resources.ExtensionNotFound, key);
                }

                int indexOfComma = fullTypeName.IndexOf(',');
                if (indexOfComma < 0)
                {
                    throw ErrorManager.CreateError(Resources.TypeShouldBeAssemblyQualified, fullTypeName);
                }
                string typeName = fullTypeName.Substring(0, indexOfComma).Trim();
                string assemblyName = fullTypeName.Substring(indexOfComma + 1).Trim();

                try
                {
                    Assembly loadedAssembly;
                    try
                    {
                        loadedAssembly = Assembly.Load(assemblyName);
                    }
                    catch (FileNotFoundException)
                    {
                        loadedAssembly = Assembly.LoadFrom(assemblyName + ".dll");
                        if (loadedAssembly == null)
                        {
                            throw;
                        }
                    }

                    Type loadedType = loadedAssembly.GetTypes()
                        .Single(t => string.IsNullOrEmpty(typeName) ||
                                     t.Name == typeName ||
                                     t.FullName == typeName);

                    instance = (T)loadedType.GetConstructor(Type.EmptyTypes).Invoke(null);

                    if (!section[key].Settings.IsNullOrEmpty())
                    {
                        throw new NotImplementedException("UNEXPECTED");
                        foreach (var settingFromFile in section[key].Settings)
                        {
                            Settings.Instance.CustomSettings[settingFromFile.Key] = settingFromFile.Value;
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw ErrorManager.CreateError(Resources.ErrorLoadingAssembly, key, ex);
                }

                return instance;
            }
            throw ErrorManager.CreateError(Resources.ExtensionNotFound, key);
        }
    }
}
