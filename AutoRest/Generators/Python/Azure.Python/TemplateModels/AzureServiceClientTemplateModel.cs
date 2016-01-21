// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Text;
using Microsoft.Rest.Generator.Python.TemplateModels;
using Microsoft.Rest.Generator.Python;

namespace Microsoft.Rest.Generator.Azure.Python
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
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.PageableExtension));
            ModelTemplateModels.RemoveAll(m => m.Extensions.ContainsKey(AzureExtensions.ExternalExtension));

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
            get { return MethodTemplateModels.Any(m => m.Extensions.ContainsKey(AzureExtensions.LongRunningExtension)); }
        }

        public bool HasAnyCloudErrors
        {
            get
            {
                return this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null || item.DefaultResponse.Body.Name == "CloudError");
            }
        }

        public bool HasAnyModel { get; private set; }

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
                foreach (var property in this.Properties)
                {
                    if (property.IsRequired)
                    {
                        requireParams.Add(property.Name.ToPythonCase());
                    }
                    else
                    {
                        string defaultValue = "None";
                        if (property.DefaultValue != null && property.Type is PrimaryType)
                        {
                            PrimaryType type = property.Type as PrimaryType;
                            if (type == PrimaryType.Double || type == PrimaryType.Int || type == PrimaryType.Long || type == PrimaryType.String)
                            {
                                defaultValue = property.DefaultValue;
                            }
                            else if (type == PrimaryType.Boolean)
                            {
                                if (property.DefaultValue == "true")
                                {
                                    defaultValue = "True";
                                }
                                else
                                {
                                    defaultValue = "False";
                                }
                            }
                        }
                        requireParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}={1}", property.Name.ToPythonCase(), defaultValue));
                    }
                }
                //requireParams.Add("baseUri");
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
                return "\"msrest>=0.0.1\", \"msrestazure>=0.0.1\"";
            }
        }
    }
}