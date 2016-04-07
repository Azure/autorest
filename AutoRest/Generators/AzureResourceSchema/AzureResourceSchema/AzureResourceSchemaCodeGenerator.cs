// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using Microsoft.Rest.Generator.ClientModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.Rest.Generator.AzureResourceSchema
{
    public class AzureResourceSchemaCodeGenerator : CodeGenerator
    {
        private const string resourceMethodPrefix = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/";

        public AzureResourceSchemaCodeGenerator(Settings settings)
            : base(settings)
        {
        }

        public string SchemaPath
        {
            get
            {
                string defaultSchemaFileName = Path.GetFileNameWithoutExtension(Settings.Input) + ".schema.json";
                return Path.Combine(Settings.OutputDirectory, Settings.OutputFileName ?? defaultSchemaFileName);
            }
        }

        public override string Description
        {
            get { return "Azure Resource Schema generator"; }
        }

        public override string ImplementationFileExtension
        {
            get { return ".json"; }
        }

        public override string Name
        {
            get { return "AzureResourceSchema"; }
        }

        public override string UsageInstructions
        {
            get { return "Your Azure Resource Schema can be found at " + SchemaPath; }
        }

        public override void NormalizeClientModel(ServiceClient serviceClient)
        {
        }

        public override async Task Generate(ServiceClient serviceClient)
        {
            StringWriter stringWriter = new StringWriter();
            using (JsonTextWriter writer = new JsonTextWriter(stringWriter))
            {
                writer.Formatting = Formatting.Indented;
                writer.Indentation = 2;
                writer.IndentChar = ' ';

                string resourceProvider = GetResourceProvider(serviceClient);
                IEnumerable<string> resourceFullTypes = GetResourceFullTypes(serviceClient);

                WriteObject(writer, () => {
                    WriteProperty(writer, "id", string.Format("http://schema.management.azure.com/schemas/{0}/Microsoft.Storage.json#", serviceClient.ApiVersion));
                    WriteProperty(writer, "$schema", "http://json-schema.org/draft-04/schema#");
                    WriteProperty(writer, "title", resourceProvider);
                    WriteProperty(writer, "description", resourceProvider.Replace('.', ' ') + " Resource Types");
                    WriteProperty(writer, "resourceDefinitions", () => {
                        foreach (string resourceFullType in resourceFullTypes)
                        {
                            string resourceShortType = resourceFullType.Substring(resourceFullType.IndexOf('/') + 1);

                            WriteProperty(writer, resourceShortType, () => {
                                WriteProperty(writer, "type", "object");
                                WriteProperty(writer, "properties", () => {
                                    WriteProperty(writer, "type", () => {
                                        WriteProperty(writer, "enum", new string[] {
                                            resourceFullType
                                        });
                                    });
                                    WriteProperty(writer, "apiVersion", () => {
                                        WriteProperty(writer, "enum", new string[] {
                                            serviceClient.ApiVersion
                                        });
                                    });
                                    WriteProperty(writer, "properties", () => {
                                        WriteProperty(writer, "type", "object");
                                        WriteProperty(writer, "properties", () => {
                                        });
                                        WriteProperty(writer, "required", new string[0]);
                                    });
                                });
                                WriteProperty(writer, "required", new string[] {
                                    "type",
                                    "apiVersion",
                                    "properties",
                                    "location"
                                });    
                                WriteProperty(writer, "description", resourceFullType);
                            });
                        }
                    });
                });
            }

            await Write(stringWriter.ToString(), SchemaPath);
        }

        private static IEnumerable<Method> GetResourceMethods(ServiceClient serviceClient)
        {
            return GetResourceMethods(serviceClient.Methods);
        }

        private static IEnumerable<Method> GetResourceMethods(IEnumerable<Method> methods)
        {
            return methods.Where(m => m.Url.StartsWith(resourceMethodPrefix));
        }

        private static IEnumerable<string> GetResourceMethodUrisAfterPrefix(ServiceClient serviceClient)
        {
            IEnumerable<Method> resourceMethods = GetResourceMethods(serviceClient);
            IEnumerable<string> resourceMethodUris = resourceMethods.Select(rm => rm.Url);
            return resourceMethodUris.Select(rmu => rmu.Substring(resourceMethodPrefix.Length));
        }

        private static string GetResourceProvider(ServiceClient serviceClient)
        {
            IEnumerable<string> resourceMethodUrisAfterPrefix = GetResourceMethodUrisAfterPrefix(serviceClient);
            return resourceMethodUrisAfterPrefix.Select(rmuap => rmuap.Substring(0, rmuap.IndexOf('/'))).Distinct().Single();
        }

        private static IEnumerable<string> GetResourceFullTypes(ServiceClient serviceClient)
        {
            IEnumerable<string> resourceMethodUrisAfterPrefix = GetResourceMethodUrisAfterPrefix(serviceClient);
            return resourceMethodUrisAfterPrefix.Select(rmuap =>
            {
                int forwardSlashAfterProvider = rmuap.IndexOf('/');
                int forwardSlashAfterType = rmuap.IndexOf('/', forwardSlashAfterProvider + 1);
                int startIndex = forwardSlashAfterProvider + 1;
                if (forwardSlashAfterType == -1)
                {
                    return rmuap;
                }
                else
                {
                    return rmuap.Substring(0, forwardSlashAfterType);
                }
            }).Distinct();
        }

        private static void WriteObject(JsonTextWriter writer, Action writeObjectContents)
        {
            writer.WriteStartObject();

            writeObjectContents.Invoke();

            writer.WriteEndObject();
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, string propertyValue)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteValue(propertyValue);
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, Action writeObjectContents)
        {
            writer.WritePropertyName(propertyName);
            WriteObject(writer, writeObjectContents);
        }

        private static void WriteProperty(JsonTextWriter writer, string propertyName, string[] writeArrayContents)
        {
            writer.WritePropertyName(propertyName);
            writer.WriteStartArray();

            foreach (string value in writeArrayContents)
            {
                writer.WriteValue(value);
            }

            writer.WriteEndArray();
        }
    }
}
