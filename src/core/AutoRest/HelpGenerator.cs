// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using Newtonsoft.Json;

namespace AutoRest
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
            },
            new HelpExample
            {
                Description = "Generate C# client in MyNamespace with custom Models name from swagger.json input:",
                Example =
                    "AutoRest.exe -Namespace MyNamespace -ModelsName MyModels -CodeGenerator CSharp -Modeler Swagger -Input swagger.json"
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
        public static string Generate(string template, Settings settings)
        {
            if (String.IsNullOrEmpty(template))
            {
                throw new ArgumentNullException("template");
            }

            // Reflect over properties in Settings to get documentation content
            var parameters = new List<Tuple<string, SettingsInfoAttribute>>();
            foreach (PropertyInfo property in typeof(Settings).GetProperties())
            {
                var doc = property.GetCustomAttributes<SettingsInfoAttribute>().FirstOrDefault();

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

            // Generate parameters section
            var parametersSection = new StringBuilder();
            const string parametersPattern = @"\$parameters-start\$(.+)\$parameters-end\$";
            var parameterTemplate = Regex.Match(template, parametersPattern, RegexOptions.Singleline).Groups[1].Value.Trim();
            foreach (PropertyInfo property in typeof(Settings).GetProperties().OrderBy(p => p.Name))
            {
                SettingsInfoAttribute doc = (SettingsInfoAttribute)property.GetCustomAttributes(
                    typeof(SettingsInfoAttribute)).FirstOrDefault();

                if (doc != null)
                {
                    string documentation = doc.Documentation;
                    string aliases = string.Join(", ", 
                        property.GetCustomAttributes<SettingsAliasAttribute>().Select(a => "-" + a.Alias));
                    if (!string.IsNullOrWhiteSpace(aliases))
                    {
                        documentation += " Aliases: " + aliases;
                    }
                    parametersSection.AppendLine("  " + parameterTemplate.
                        Replace("$parameter$", property.Name).
                        Replace("$parameter-desc$", documentation));
                }
            }

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

            // Generate generators section
            var generatorsSection = new StringBuilder();
            const string generatorsPattern = @"\$generators-start\$(.+)\$generators-end\$";
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

            // Generate examples section.
            var examplesSection = new StringBuilder();
            const string examplesPattern = @"\$examples-start\$(.+)\$examples-end\$";
            var exampleTemplate = Regex.Match(template, examplesPattern, RegexOptions.Singleline).Groups[1].Value.Trim() + Environment.NewLine;
            foreach (HelpExample example in Examples)
            {
                examplesSection.AppendLine("  " + exampleTemplate.
                    Replace("$example$", example.Example).
                    Replace("$example-desc$", example.Description));
            }

            // Process template replacing all major sections.
            template = template.
                Replace("$version$", Core.AutoRest.Version).
                Replace("$syntax$", syntaxSection.ToString());

            template = Regex.Replace(template, parametersPattern, parametersSection.ToString(), RegexOptions.Singleline);
            template = Regex.Replace(template, examplesPattern, examplesSection.ToString(), RegexOptions.Singleline);
            template = Regex.Replace(template, generatorsPattern, generatorsSection.ToString(), RegexOptions.Singleline);

            return template;
        }
    }
}