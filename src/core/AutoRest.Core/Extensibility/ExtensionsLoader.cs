// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Utilities;
using IAnyPlugin = AutoRest.Core.Extensibility.IPlugin<AutoRest.Core.Extensibility.IGeneratorSettings, AutoRest.Core.IModelSerializer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.ITransformer<AutoRest.Core.Model.CodeModel>, AutoRest.Core.CodeGenerator, AutoRest.Core.CodeNamer, AutoRest.Core.Model.CodeModel>;

namespace AutoRest.Core.Extensibility
{
    public static class ExtensionsLoader
    {
        public static IAnyPlugin GetPlugin(string pluginName)
        {
            Logger.Instance.Log(Category.Debug, Resources.InitializingCodeGenerator);

            if (string.IsNullOrEmpty(pluginName))
            {
                throw new ArgumentException(
                    string.Format(CultureInfo.InvariantCulture,
                        Resources.ParameterValueIsMissing, "CodeGenerator"));
            }

            IAnyPlugin plugin = null;
            
            var config = AutoRestConfiguration.Get();
            plugin = LoadTypeFromAssembly<IAnyPlugin>(config.Plugins, pluginName);
            Settings.PopulateSettings(plugin.Settings, Settings.Instance.CustomSettings);
            Logger.Instance.Log(Category.Debug, Resources.GeneratorInitialized,
                pluginName,
                plugin.GetType().GetAssembly().GetName().Version);
            return plugin;

        }

        [SuppressMessage("Microsoft.Reliability", "CA2001:AvoidCallingProblematicMethods", MessageId = "System.Reflection.Assembly.LoadFrom")]
        private static T LoadTypeFromAssembly<T>(IDictionary<string, AutoRestProviderConfiguration> section, string key)
        {
            T instance = default(T);

            if (Settings.Instance != null && section != null && !section.IsNullOrEmpty() && section.ContainsKey(key))
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
                    Assembly loadedAssembly = null;
                    try
                    {
                        loadedAssembly = Assembly.Load(new AssemblyName(assemblyName));
                    }
                    catch (FileNotFoundException)
                    {
                        // loadedAssembly = Assembly.LoadFrom(assemblyName + ".dll");
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
