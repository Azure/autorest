// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using System.Text;
using Microsoft.Rest.Generator.NodeJS.TemplateModels;

namespace Microsoft.Rest.Generator.NodeJS
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

        /// <summary>
        /// Return the service client constructor required parameters, in TypeScript syntax.
        /// </summary>
        public string RequiredConstructorParametersTS {
            get {
                StringBuilder requiredParams = new StringBuilder();

                bool first = true;
                foreach (var p in this.Properties) {
                    if (! p.IsRequired)
                        continue;

                    if (!first)
                        requiredParams.Append(", ");

                    requiredParams.Append(p.Name);
                    requiredParams.Append(": ");
                    requiredParams.Append(p.Type.TSType(false));

                    first = false;
                }

                if (!first)
                    requiredParams.Append(", ");

                requiredParams.Append("baseUri: string");
                return requiredParams.ToString();
            }
        }

        public bool ContainsTimeSpan
        {
            get { return this.Methods.FirstOrDefault(m => m.Parameters.FirstOrDefault(p => p.Type == PrimaryType.TimeSpan) != null) != null; }
        }
    }
}