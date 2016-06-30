// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.NodeJS.TemplateModels
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
            this.IsCustomBaseUri = serviceClient.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);
        }

        public bool IsCustomBaseUri { get; private set; }

        public List<MethodTemplateModel> MethodTemplateModels { get; private set; }

        public List<ModelTemplateModel> ModelTemplateModels { get; private set; }

        /// <summary>
        /// Provides an ordered ModelTemplateModel list such that the parent 
        /// type comes before in the list than its child. This helps when 
        /// requiring models in index.js
        /// </summary>
        public List<ModelTemplateModel> OrderedModelTemplateModels 
        {
            get
            {
                List<ModelTemplateModel> orderedList = new List<ModelTemplateModel>();
                foreach (var model in ModelTemplateModels)
                {
                    constructOrderedList(model, orderedList);
                }
                return orderedList;
            }
        }

        public bool ContainsDurationProperty()
        {
            Property prop = Properties.FirstOrDefault(p =>
                (p.Type is PrimaryType && (p.Type as PrimaryType).Type == KnownPrimaryType.TimeSpan) ||
                (p.Type is SequenceType && (p.Type as SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                (p.Type is DictionaryType && (p.Type as DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)));
            return prop != null;
        }

        private void constructOrderedList(ModelTemplateModel model, List<ModelTemplateModel> orderedList)
        {
            if (model == null)
            {
                throw new ArgumentNullException("model");
            }

            // BaseResource and CloudError are specified in the ClientRuntime. 
            // They are required explicitly in a different way. Hence, they
            // are not included in the ordered list.
            if (model.BaseModelType == null ||
                (model.BaseModelType != null && 
                 (model.BaseModelType.Name == "BaseResource" || 
                  model.BaseModelType.Name == "CloudError")))
            {
                if (!orderedList.Contains(model))
                {
                    orderedList.Add(model);
                }
                return;
            }

            var baseModel = ModelTemplateModels.FirstOrDefault(m => m.Name == model.BaseModelType.Name);
            if (baseModel != null)
            {
                constructOrderedList(baseModel, orderedList);
            }
            // Add the child type after the parent type has been added.
            if (!orderedList.Contains(model))
            {
                orderedList.Add(model);
            }
        }

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
                    string discriminatorField = polymorphicTypes.ElementAt(i).SerializedName;
                    var polymorphicType = polymorphicTypes.ElementAt(i) as CompositeType;
                    if (polymorphicType.BaseModelType != null)
                    {
                        while (polymorphicType.BaseModelType != null)
                        {
                            polymorphicType = polymorphicType.BaseModelType;
                        }
                        discriminatorField = string.Format(CultureInfo.InvariantCulture, "{0}.{1}",
                            polymorphicType.Name,
                            polymorphicTypes.ElementAt(i).SerializedName);
                        builder.Append(string.Format(CultureInfo.InvariantCulture,
                        "'{0}' : exports.{1}",
                            discriminatorField,
                            polymorphicTypes.ElementAt(i).Name));
                    }
                    else
                    {
                        builder.Append(string.Format(CultureInfo.InvariantCulture,
                        "'{0}' : exports.{1}",
                            discriminatorField,
                            polymorphicTypes.ElementAt(i).Name));
                    }
                    

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
                this.Properties.Where(p => p.IsRequired && !p.IsConstant && string.IsNullOrEmpty(p.DefaultValue))
                    .ForEach(p => requireParams.Add(p.Name.ToCamelCase()));
                if (!IsCustomBaseUri)
                {
                    requireParams.Add("baseUri");
                }

                if(requireParams == null || requireParams.Count == 0)
                {
                    return string.Empty;
                }

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
                    if (!p.IsRequired || p.IsConstant || (p.IsRequired && !string.IsNullOrEmpty(p.DefaultValue)))
                        continue;

                    if (!first)
                        requiredParams.Append(", ");

                    requiredParams.Append(p.Name);
                    requiredParams.Append(": ");
                    requiredParams.Append(p.Type.TSType(false));

                    first = false;
                }

                if (!IsCustomBaseUri)
                {
                    if (!first)
                        requiredParams.Append(", ");

                    requiredParams.Append("baseUri: string");
                }

                return requiredParams.ToString();
            }
        }

        public bool ContainsTimeSpan
        {
            get
            {
                return this.Methods.FirstOrDefault(
                    m => m.Parameters.FirstOrDefault(p => p.Type.IsPrimaryType(KnownPrimaryType.TimeSpan)) != null) != null;
            }
        }
    }
}