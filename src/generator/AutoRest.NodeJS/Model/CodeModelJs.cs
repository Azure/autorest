// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.NodeJS.Model
{
   public class CodeModelJs : CodeModel
    {
        public CodeModelJs()
        {
        }

        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        [JsonIgnore]
        public IEnumerable<MethodJs> MethodTemplateModels => Methods.Cast<MethodJs>().Where( each => each.MethodGroup.IsCodeModelMethodGroup);

        [JsonIgnore]
        public virtual IEnumerable<CompositeTypeJs> ModelTemplateModels => ModelTypes.Cast<CompositeTypeJs>();

        [JsonIgnore]
        public virtual IEnumerable<MethodGroupJs> MethodGroupModels => Operations.Cast<MethodGroupJs>().Where( each => !each.IsCodeModelMethodGroup );

        /// <summary>
        /// Provides an ordered ModelTemplateModel list such that the parent 
        /// type comes before in the list than its child. This helps when 
        /// requiring models in index.js
        /// </summary>
        [JsonIgnore]
        public virtual IEnumerable<CompositeTypeJs> OrderedModelTemplateModels 
        {
            get
            {
                List<CompositeTypeJs> orderedList = new List<CompositeTypeJs>();
                foreach (var model in ModelTemplateModels)
                {
                    constructOrderedList(model, orderedList);
                }
                return orderedList;
            }
        }

        public bool ContainsDurationProperty()
        {
            Core.Model.Property prop = Properties.FirstOrDefault(p =>
                (p.ModelType is PrimaryTypeJs && (p.ModelType as PrimaryTypeJs).KnownPrimaryType == KnownPrimaryType.TimeSpan) ||
                (p.ModelType is Core.Model.SequenceType && (p.ModelType as Core.Model.SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                (p.ModelType is Core.Model.DictionaryType && (p.ModelType as Core.Model.DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)));
            return prop != null;
        }

        private void constructOrderedList(CompositeTypeJs model, List<CompositeTypeJs> orderedList)
        {
            if (model == null)
            {
                throw new ArgumentNullException(nameof(model));
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

        public string PolymorphicDictionary
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
                var polymorphicTypes = ModelTemplateModels.Where(m => m.BaseIsPolymorphic);

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
                    requiredParams.Append(p.ModelType.TSType(false));

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

        public string ConstructImportTS()
        {
            IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
            builder.Append("import { ServiceClientOptions, RequestOptions, ServiceCallback");
            if (Properties.Any(p => p.Name.EqualsIgnoreCase("credentials")))
            {
                builder.Append(", ServiceClientCredentials");
            }

            builder.Append(" } from 'ms-rest';");
            return builder.ToString();
        }

        public bool ContainsTimeSpan
        {
            get
            {
                return this.Methods.FirstOrDefault(
                    m => m.Parameters.FirstOrDefault(p => p.ModelType.IsPrimaryType(KnownPrimaryType.TimeSpan)) != null) != null;
            }
        }
    }
}