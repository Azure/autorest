// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using Microsoft.Rest.Generator.Extensibility;
using Newtonsoft.Json;

namespace Microsoft.Rest.Generator.Cli
{
    /// <summary>
    /// Helper class for dynamically generating CLI help from Settings.
    /// </summary>
    public static class HelpGenerator
    {
        private static readonly List<HelpExample> Examples = new List<HelpExample>
        {
            new HelpExample
            {
                Description = "Generate C# client in MyNamespace from swagger.json input:",
                Example = "AutoRest.exe -Namespace MyNamespace -Input swagger.json"
            },
            new HelpExample
            {
                Description =
                    "Generate C# client in MyNamespace including custom header from swagger.json input:",
                Example =
                    "AutoRest.exe -Namespace MyNamespace -Header \"Copyright Contoso Ltd\" -Input swagger.json",
            },
            new HelpExample
            {
                Description = "Generate C# client with a credentials property in MyNamespace from swagger.json input:",
                Example =
                    "AutoRest.exe -AddCredentials true -Namespace MyNamespace -CodeGenerator CSharp -Modeler Swagger -Input swagger.json"
            }
        };


        /// <summary>
        /// Generates help string based on the passed in template.
        /// <para>
        /// The following keywords are supported:
        ///   $version$ - version of AutoRest Core
        ///   $syntax$ - replaced with the usage syntax
        ///   $parameters-start$...$parameters-end$ - contains a template for a parameters
        ///   $parameter$ - parameter name  
        ///   $parameter-desc$ - parameter documentation
        ///   $examples-start$...$examples-end$ - contains a template for an example
        ///   $example-desc$ - example description
        ///   $example$ - example code
        /// </para>
        /// </summary>
        /// <example>
        ///    Microsoft (R) AutoRest Core $version$
        ///    Copyright (C) Microsoft Corporation. All rights reserved.
        ///    
        ///    Syntax         : $syntax$
        ///    
        ///    Parameters     :
        ///    $parameters-start$
        ///    -$parameter$ : $parameter-desc$
        ///    $parameters-end$
        ///    
        ///    Examples       :
        ///    
        ///    $examples-start$
        ///    $example-desc$
        ///    >$example$
        ///    $examples-end$
        /// </example>
        /// <param name="template">Template to use.</param>
        /// <param name="settings">Settings to use.</param>
        /// <returns>Generated help.</returns>
        [SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes", Justification = "By design.")]
        public static string Generate(string template, BaseSettings settings)
        {
            if (String.IsNullOrEmpty(template))
            {
                throw new ArgumentNullException("template");
            }

            // Reflect over properties in Settings to get documentation content
            var parameters = new List<Tuple<string, SettingsInfoAttribute>>();
            foreach (PropertyInfo property in typeof(Settings).GetProperties())
            {
                var doc = CustomAttributeExtensions.GetCustomAttributes<SettingsInfoAttribute>(property).FirstOrDefault();

                if (doc != null)
                {
                    parameters.Add(new Tuple<string, SettingsInfoAttribute>(property.Name, doc));
                }
            }

            // Generate usage syntax
            var syntaxSection = new StringBuilder("autorest ");
            foreach (var parameter in parameters.OrderBy(t => t.Item1).OrderByDescending(t => t.Item2.IsRequired))
            {
                if (parameter.Item2.IsRequired)
                {
                    syntaxSection.AppendFormat("-{0} <value> ", parameter.Item1);
                }
                else
                {
                    syntaxSection.AppendFormat("[-{0} <value>] ", parameter.Item1);
                }
            }

            StringBuilder parametersSection;
            string parametersPattern;
            GenerateParametersSection(template, out parametersSection, out parametersPattern);

            // Parse autorest.json
            AutoRestConfiguration autorestConfig = new AutoRestConfiguration();
            string configurationFile = ExtensionsLoader.GetConfigurationFileContent(settings);
            if (configurationFile != null)
            {
                try
                {
                    autorestConfig = JsonConvert.DeserializeObject<AutoRestConfiguration>(configurationFile);
                }
                catch
                {
                    // Ignore
                }
            }

            StringBuilder generatorsSection;
            string generatorsPattern;
            GenerateGeneratorsSection(template, settings, autorestConfig, out generatorsSection, out generatorsPattern);

            StringBuilder examplesSection;
            string examplesPattern;
            GenerateExamplesSection(template, out examplesSection, out examplesPattern);

            // Process template replacing all major sections.
            template = template.
                Replace("$version$", AutoRest.Version).
                Replace("$syntax$", syntaxSection.ToString());

            template = Regex.Replace(template, parametersPattern, parametersSection.ToString(), RegexOptions.Singleline);
            template = Regex.Replace(template, examplesPattern, examplesSection.ToString(), RegexOptions.Singleline);
            template = Regex.Replace(template, generatorsPattern, generatorsSection.ToString(), RegexOptions.Singleline);

            return template;
        }

        private static void GenerateParametersSection(string template, out StringBuilder parametersSection, out string parametersPattern)
        {
            // Generate parameters section
            parametersSection = new StringBuilder();
            parametersPattern = @"\$parameters-start\$(.+)\$parameters-end\$";
            var parameterTemplate = Regex.Match(template, parametersPattern, RegexOptions.Singleline).Groups[1].Value.Trim();
            foreach (PropertyInfo property in typeof(Settings).GetProperties().OrderBy(p => p.Name))
            {
                SettingsInfoAttribute doc = (SettingsInfoAttribute)property.GetCustomAttributes(
                    typeof(SettingsInfoAttribute)).FirstOrDefault();

                if (doc != null)
                {
                    string documentation = doc.Documentation;
                    string aliases = string.Join(", ",
                        CustomAttributeExtensions.GetCustomAttributes<SettingsAliasAttribute>(property).Select(a => "-" + a.Alias));
                    if (!string.IsNullOrWhiteSpace(aliases))
                    {
                        documentation += " Aliases: " + aliases;
                    }
                    parametersSection.AppendLine("  " + parameterTemplate.
                        Replace("$parameter$", property.Name).
                        Replace("$parameter-desc$", documentation));
                }
            }
        }

        [SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes", Justification = "By design.")]
        private static void GenerateGeneratorsSection(string template, BaseSettings settings, AutoRestConfiguration autorestConfig, out StringBuilder generatorsSection, out string generatorsPattern)
        {
            // Generate generators section
            generatorsSection = new StringBuilder();
            generatorsPattern = @"\$generators-start\$(.+)\$generators-end\$";
            var generatorsTemplate = Regex.Match(template, generatorsPattern, RegexOptions.Singleline).Groups[1].Value.Trim();
            foreach (string generator in autorestConfig.CodeGenerators.Keys.OrderBy(k => k))
            {
                try
                {
                    var codeGenerator = ExtensionsLoader.LoadTypeFromAssembly<CodeGenerator>(autorestConfig.CodeGenerators, generator,
                       settings);
                    generatorsSection.AppendLine("  " + generatorsTemplate.
                        Replace("$generator$", codeGenerator.Name).
                        Replace("$generator-desc$", codeGenerator.Description));
                }
                catch
                {
                    // Skip
                }
            }
        }

        private static void GenerateExamplesSection(string template, out StringBuilder examplesSection, out string examplesPattern)
        {
            // Generate examples section.
            examplesSection = new StringBuilder();
            examplesPattern = @"\$examples-start\$(.+)\$examples-end\$";
            var exampleTemplate = Regex.Match(template, examplesPattern, RegexOptions.Singleline).Groups[1].Value.Trim() + Environment.NewLine;
            foreach (HelpExample example in Examples)
            {
                examplesSection.AppendLine("  " + exampleTemplate.
                    Replace("$example$", example.Example).
                    Replace("$example-desc$", example.Description));
            }
        }
    }
}