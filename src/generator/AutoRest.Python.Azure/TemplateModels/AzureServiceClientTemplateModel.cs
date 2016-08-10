// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions.Azure;
using AutoRest.Python.TemplateModels;

namespace AutoRest.Python.Azure.TemplateModels
{
    public class AzureServiceClientTemplateModel : ServiceClientTemplateModel
    {
        public AzureServiceClientTemplateModel(ServiceClient serviceClient) : base(serviceClient)
        {
            MethodTemplateModels.Clear();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new AzureMethodTemplateModel(m, serviceClient)));
            // Removing all models that contain the extension "x-ms-external", as they will be 
            // generated in python client runtime for azure - "ms-rest-azure".
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension) && (bool)m.Extensions[AzureExtensions.PageableExtension]);
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.ExternalExtension) && (bool)m.Extensions[AzureExtensions.ExternalExtension]);

            HasAnyModel = false;
            if (serviceClient.ModelTypes.Any())
            {
                foreach (var model in serviceClient.ModelTypes)
                {
                    if (!model.Extensions.ContainsKey(AzureExtensions.ExternalExtension) || !(bool)model.Extensions[AzureExtensions.ExternalExtension])
                    {
                        HasAnyModel = true;
                        break;
                    }
                }
            }
        }

        public bool HasAnyLongRunOperation
        {
            get { return MethodTemplateModels.Any(m => m.Extensions.ContainsKey(AzureExtensions.LongRunningExtension) && (bool)m.Extensions[AzureExtensions.LongRunningExtension]); }
        }

        public bool HasAnyCloudErrors
        {
            get
            {
                return this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null || item.DefaultResponse.Body.Name == "CloudError");
            }
        }

        public override IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new AzureMethodGroupTemplateModel(this, mg));
            }
        }

        public override string RequiredConstructorParameters
        {
            get
            {
                var requireParams = new List<string>();
                var optionalParams = new List<string>();
                foreach (var property in this.Properties)
                {
                    if (property.IsRequired)
                    {
                        requireParams.Add(property.Name.ToPythonCase());
                    }
                    else
                    {
                        string defaultValue = PythonConstants.None;
                        if (!string.IsNullOrWhiteSpace(property.DefaultValue) && property.Type is PrimaryType)
                        {
                            defaultValue = property.DefaultValue;
                        }
                        optionalParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}={1}", property.Name.ToPythonCase(), defaultValue));
                    }
                }

                // The parameter without default value has to be in front of the parameters with default value
                requireParams.AddRange(optionalParams);
                var param = string.Join(", ", requireParams);
                if (!string.IsNullOrEmpty(param))
                {
                    param += ", ";
                }
                return param;
            }
        }

        public override string SetupRequires
        {
            get
            {
                return "\"msrest>=0.4.0\", \"msrestazure>=0.4.0\"";
            }
        }

        public override bool NeedsExtraImport
        {
            get
            {
                return true;
            }
        }

        public override string CredentialObject
        {
            get
            {
                return "A msrestazure Credentials object<msrestazure.azure_active_directory>";
            }
        }
    }
}