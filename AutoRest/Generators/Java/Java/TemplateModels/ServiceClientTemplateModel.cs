// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Java.TemplateModels;
using Microsoft.Rest.Generator.Utilities;
using System.Globalization;

namespace Microsoft.Rest.Generator.Java
{
    public class ServiceClientTemplateModel : ServiceClient
    {
        public ServiceClientTemplateModel(ServiceClient serviceClient)
        {
            this.LoadFrom(serviceClient);
            MethodTemplateModels = new List<MethodTemplateModel>();
            ModelTemplateModels = new List<ModelTemplateModel>();
            Methods.Where(m => m.Group == null)
                .ForEach(m => MethodTemplateModels.Add(new MethodTemplateModel(m, serviceClient)));

            ModelTypes.ForEach(m => ModelTemplateModels.Add(new ModelTemplateModel(m, serviceClient)));
        }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public List<ModelTemplateModel> ModelTemplateModels { get; private set; }

        public virtual IEnumerable<MethodGroupTemplateModel> MethodGroupModels
        {
            get
            {
                return MethodGroups.Select(mg => new MethodGroupTemplateModel(this, mg));
            }
        }

        public string PolymorphicDictionary
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
                var polymorphicTypes = ModelTemplateModels.Where(m => m.IsPolymorphic);

                for (int i = 0; i < polymorphicTypes.Count(); i++ )
                {
                    builder.Append(string.Format(CultureInfo.InvariantCulture, 
                        "'{0}' : exports.{1}",
                            polymorphicTypes.ElementAt(i).SerializedName, 
                            polymorphicTypes.ElementAt(i).Name));

                    if(i == polymorphicTypes.Count() -1)
                    {
                        builder.AppendLine();
                    }
                    else 
                    {
                        builder.AppendLine(",");
                    }
                }
                
                return builder.ToString();
            }
        }

        public string RequiredConstructorParameters
        {
            get
            {
                var requireParams = new List<string>();
                this.Properties.Where(p => p.IsRequired)
                    .ForEach(p => requireParams.Add(p.Name.ToCamelCase()));
                requireParams.Add("baseUri");
                return string.Join(", ", requireParams);
            }
        }
    }
}