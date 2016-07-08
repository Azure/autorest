using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Reflection;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Generator.Properties;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator
{
    public class BaseSettings
    {
        public BaseSettings()
        {
            FileSystem = new FileSystem();
            CustomSettings = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            Modeler = "Swagger";
            ValidationLevel = LogEntrySeverity.Error;
        }

        /// <summary>
        /// Gets or sets the IFileSystem used by code generation.
        /// </summary>
        public IFileSystem FileSystem { get; set; }

        /// <summary>
        /// Custom provider specific settings.
        /// </summary>
        [SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly", Justification = "It needs to be writable.")]       
        public IDictionary<string, object> CustomSettings { get; set; }

        /// <summary>
        /// Gets or sets the path to the input specification file.
        /// </summary>
        [SettingsInfo("The location of the input specification.", true)]
        [SettingsAlias("i")]
        [SettingsAlias("input")]
        public string Input { get; set; }

        /// <summary>
        /// Gets or sets the path to the base specification file.
        /// </summary>
        [SettingsInfo("The location of the base specification, which the input will be compared against.", false)]
        [SettingsAlias("b")]
        [SettingsAlias("base")]
        public string BaseInput { get; set; }

        /// <summary>
        /// Gets or sets the modeler to use for processing the input specification.
        /// </summary>
        [SettingsInfo("The Modeler to use on the input. If not specified, defaults to Swagger.")]
        [SettingsAlias("m")]
        public string Modeler { get; set; }

        /// <summary>
        /// If set to true, print out help message.
        /// </summary>
        [SettingsAlias("?")]
        [SettingsAlias("h")]
        [SettingsAlias("help")]
        public bool ShowHelp { get; set; }

        /// <summary>
        /// If set to true, print out help message.
        /// </summary>
        [SettingsAlias("vl")]
        [SettingsAlias("validation")]
        public LogEntrySeverity ValidationLevel { get; set; }

        /// <summary>
        /// Factory method to generate CodeGenerationSettings from command line arguments.
        /// Matches dictionary keys to the settings properties.
        /// </summary>
        /// <param name="arguments">Command line arguments</param>
        /// <returns>CodeGenerationSettings</returns>
        public static Settings Create(string[] arguments)
        {
            var argsDictionary = new Dictionary<string, object>(StringComparer.OrdinalIgnoreCase);
            if (arguments != null && arguments.Length > 0)
            {
                string key = null;
                string value = null;
                for (int i = 0; i < arguments.Length; i++)
                {
                    string argument = arguments[i] ?? String.Empty;
                    argument = argument.Trim();

                    if (argument.StartsWith("-", StringComparison.OrdinalIgnoreCase))
                    {
                        if (key != null)
                        {
                            AddArgumentToDictionary(key, value, argsDictionary);
                            value = null;
                        }
                        key = argument.TrimStart('-');
                    }
                    else
                    {
                        value = argument;
                    }
                }
                AddArgumentToDictionary(key, value, argsDictionary);
            }
            else
            {
                argsDictionary["?"] = String.Empty;
            }

            return Create(argsDictionary);
        }

        /// <summary>
        /// Factory method to generate Settings from a dictionary. Matches dictionary
        /// keys to the settings properties.
        /// </summary>
        /// <param name="settings">Dictionary of settings</param>
        /// <returns>Settings</returns>
        public static Settings Create(IDictionary<string, object> settings)
        {
            var autoRestSettings = new Settings();
            if (settings == null || settings.Count == 0)
            {
                autoRestSettings.ShowHelp = true;
            }

            PopulateSettings(autoRestSettings, settings);

            return autoRestSettings;
        }

        /// <summary>
        /// Sets object properties from the dictionary matching keys to property names or aliases.
        /// </summary>
        /// <param name="entityToPopulate">Object to populate from dictionary.</param>
        /// <param name="settings">Dictionary of settings.Settings that are populated get removed from the dictionary.</param>
        /// <returns>Dictionary of settings that were not matched.</returns>
        public static void PopulateSettings(object entityToPopulate, IDictionary<string, object> settings)
        {
            if (entityToPopulate == null)
            {
                throw new ArgumentNullException("entityToPopulate");
            }

            if (settings != null && settings.Count > 0)
            {
                // Setting property value from dictionary
                foreach (var setting in settings.ToArray())
                {
                    PropertyInfo property = entityToPopulate.GetType().GetProperties()
                        .FirstOrDefault(p => setting.Key.Equals(p.Name, StringComparison.OrdinalIgnoreCase) ||
                                             CustomAttributeExtensions.GetCustomAttributes<SettingsAliasAttribute>(p)
                                                .Any(a => setting.Key.Equals(a.Alias, StringComparison.OrdinalIgnoreCase)));

                    if (property != null)
                    {
                        try
                        {
                            if ((setting.Value?.ToString()).IsNullOrEmpty() && property.PropertyType == typeof(bool))
                            {
                                property.SetValue(entityToPopulate, true);
                            }
                            else
                            {
                                property.SetValue(entityToPopulate,
                                    Convert.ChangeType(setting.Value, property.PropertyType, CultureInfo.InvariantCulture), null);
                            }

                            settings.Remove(setting.Key);
                        }
                        catch (Exception exception)
                        {
                            throw new ArgumentException(String.Format(CultureInfo.InvariantCulture, Resources.ParameterValueIsNotValid,
                                setting.Key, property.GetType().Name), exception);
                        }
                    }
                }
            }
        }

        protected static void AddArgumentToDictionary(string key, string value, IDictionary<string, object> argsDictionary)
        {
            if (argsDictionary == null)
            {
                throw new ArgumentNullException("argsDictionary");
            }
            key = key ?? "Default";
            value = value ?? String.Empty;
            argsDictionary[key] = value;
        }
    }
}
