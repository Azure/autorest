// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Linq;
using System.Collections.Generic;
using System.Globalization;
using Microsoft.Rest.Generator;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Logging;
using Microsoft.Rest.Modeler.CompositeSwagger.Properties;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Rest.Modeler.Swagger;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.CompositeSwagger
{
    public class CompositeSwaggerModeler : Generator.Modeler
    {
        public CompositeSwaggerModeler(Settings settings) : base(settings)
        {
            if (settings == null)
            {
                throw new ArgumentNullException("settings");
            }
        }

        public override string Name
        {
            get { return "CompositeSwagger"; }
        }

        public override ServiceClient Build()
        {
            var compositeSwaggerModel = Parse(Settings.Input);
            if (compositeSwaggerModel == null)
            {
                throw ErrorManager.CreateError(Resources.ErrorParsingSpec);
            }

            if (!compositeSwaggerModel.Documents.Any())
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, "Documents collection can not be empty."));
            }

            if (compositeSwaggerModel.Info == null)
            {
                throw ErrorManager.CreateError(Resources.InfoSectionMissing);
            }

            ServiceClient compositeClient = InitializeServiceClient(compositeSwaggerModel);

            foreach (var childSwaggerPath in compositeSwaggerModel.Documents)
            {
                Settings.Input = childSwaggerPath;
                var swaggerModeler = new SwaggerModeler(Settings);
                var serviceClient = swaggerModeler.Build();
                compositeClient = Merge(compositeClient, serviceClient);
            }
            return compositeClient;
        }

        private ServiceClient InitializeServiceClient(CompositeServiceDefinition compositeSwaggerModel)
        {
            ServiceClient compositeClient = new ServiceClient();

            if (string.IsNullOrWhiteSpace(Settings.ClientName))
            {
                if (compositeSwaggerModel.Info.Title == null)
                {
                    throw ErrorManager.CreateError(Resources.TitleMissing);
                }

                compositeClient.Name = compositeSwaggerModel.Info.Title.Replace(" ", "");
            }
            else
            {
                compositeClient.Name = Settings.ClientName;
            }
            compositeClient.Namespace = Settings.Namespace;
            compositeClient.Documentation = compositeSwaggerModel.Info.Description;

            return compositeClient;
        }

        private CompositeServiceDefinition Parse(string input)
        {
            var inputBody = Settings.FileSystem.ReadFileAsText(input);
            try
            {
                var settings = new JsonSerializerSettings
                {
                    TypeNameHandling = TypeNameHandling.None,
                    MetadataPropertyHandling = MetadataPropertyHandling.Ignore
                };
                return JsonConvert.DeserializeObject<CompositeServiceDefinition>(inputBody, settings);                
            }
            catch (JsonException ex)
            {
                throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture, "{0}. {1}",
                    Resources.ErrorParsingSpec, ex.Message), ex);
            }
        }

        private ServiceClient Merge(ServiceClient compositeClient, ServiceClient subClient)
        {
            if (compositeClient == null)
            {
                throw new ArgumentNullException("compositeClient");
            }

            if (subClient == null)
            {
                throw new ArgumentNullException("subClient");
            }

            // Merge
            // TODO: Convert APIVersion to Constants

            if(compositeClient.BaseUrl == null)
            {
                compositeClient.BaseUrl = subClient.BaseUrl;
            }
            else
            {
                AssertEquals(compositeClient.BaseUrl, subClient.BaseUrl, "BaseUrl");
            }

            foreach (var subClientProperty in subClient.Properties)
            {
                var compositeClientProperty = compositeClient.Properties.FirstOrDefault(p => p.Name == subClientProperty.Name);
                if (compositeClientProperty == null)
                {
                    compositeClient.Properties.Add(subClientProperty);
                }
                else
                {
                    AssertEquals(compositeClientProperty.Type, subClientProperty.Type, compositeClient.Name + "." + compositeClientProperty.Name);

                }
            }


            return compositeClient;
        }

        private void AssertEquals<T>(T compositeProperty, T subProperty, string propertyName)
        {
            if (compositeProperty != null)
            {
                if (!compositeProperty.Equals(subProperty))
                {
                    throw ErrorManager.CreateError(string.Format(CultureInfo.InvariantCulture,
                        "Property {0} has different values in sub swagger documents.",
                        propertyName));
                }
            }
        }
    }
}
