// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;

namespace AutoRest.Python.TemplateModels
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
            ServiceClient = serviceClient;
            this.Version = this.ApiVersion;

            this.HasAnyModel = false;
            if (ModelTemplateModels.Any())
            {
                this.HasAnyModel = true;
            }
            ConstantProperties = Properties.Where(p => p.IsConstant).ToList();
            Properties.RemoveAll(p => ConstantProperties.Contains(p));
            this.IsCustomBaseUri = serviceClient.Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);
        }

        public bool IsCustomBaseUri { get; private set; }

        public List<Property> ConstantProperties { get; set; }

        public ServiceClient ServiceClient { get; set; }

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

        public virtual string RequiredConstructorParameters
        {
            get
            {
                var parameters = this.Properties.OrderBy(item => !item.IsRequired);
                var requireParams = new List<string>();
                foreach (var property in parameters)
                {
                    if (property.IsRequired)
                    {
                        requireParams.Add(property.Name.ToPythonCase());
                    }
                    else
                    {
                        requireParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}=None", property.Name.ToPythonCase()));
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

        public virtual string ConfigConstructorParameters
        {
            get
            {
                var parameters = this.Properties.OrderBy(item => !item.IsRequired);
                var configParams = new List<string>();
                foreach (var property in parameters)
                {
                    configParams.Add(property.Name.ToPythonCase());
                }
                var param = string.Join(", ", configParams);
                if (!param.IsNullOrEmpty())
                {
                    param += ", ";
                }
                return param;
            }
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "ValueError"),
            System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "TypeError"),
            System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "str"),
            System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1303:Do not pass literals as localized parameters", MessageId = "AutoRest.Core.Utilities.IndentedStringBuilder.AppendLine(System.String)")]
        public virtual string ValidateRequiredParameters
        {
            get
            {
                var builder = new IndentedStringBuilder("    ");
                foreach (var property in this.Properties)
                {
                    if (property.IsRequired)
                    {
                        builder.
                            AppendFormat("if {0} is None:", property.Name.ToPythonCase()).AppendLine().
                            Indent().
                                AppendLine(string.Format(CultureInfo.InvariantCulture, "raise ValueError(\"Parameter '{0}' must not be None.\")", property.Name.ToPythonCase())).
                            Outdent();
                        if (property.Type.IsPrimaryType(KnownPrimaryType.String))
                        {
                            builder.
                                AppendFormat("if not isinstance({0}, str):", property.Name.ToPythonCase()).AppendLine().
                                Indent().
                                    AppendLine(string.Format(CultureInfo.InvariantCulture, "raise TypeError(\"Parameter '{0}' must be str.\")", property.Name.ToPythonCase())).
                                Outdent();
                        }
                    }
                    else
                    {
                        if (property.Type.IsPrimaryType(KnownPrimaryType.String))
                        {
                            builder.
                                AppendFormat("if {0} is not None and not isinstance({0}, str):", property.Name.ToPythonCase()).AppendLine().
                                Indent().
                                    AppendLine(string.Format(CultureInfo.InvariantCulture, "raise TypeError(\"Optional parameter '{0}' must be str.\")", property.Name.ToPythonCase())).
                                Outdent();
                        }

                    }
                    

                }
                return builder.ToString();
            }
        }

        public virtual string UserAgent
        {
            get
            {
                return PackageName;
            }
        }

        public virtual string SetupRequires
        {
            get
            {
                return "\"msrest>=0.2.0\"";
            }
        }
       
        public virtual string CredentialObject
        {
            get
            {
                return "A msrest Authentication object<msrest.authentication>";
            }
        }

        public string Version { get; set; }

        public bool HasAnyModel { get; protected set; }

        public string PackageName
        {
            get
            {
                return this.Name.ToPythonCase().Replace("_", "");
            }
        }

        public string ServiceDocument
        {
            get
            {
                if (string.IsNullOrWhiteSpace(this.Documentation))
                {
                    return this.Name;
                }
                else
                {
                    return this.Documentation.EscapeXmlComment();
                }
            }
        }

        /// Provides the modelProperty documentation string along with default value if any.
        /// </summary>
        /// <param name="property">Parameter to be documented</param>
        /// <returns>Parameter documentation string along with default value if any 
        /// in correct jsdoc notation</returns>
        public static string GetPropertyDocumentationString(Property property)
        {
            if (property == null)
            {
                throw new ArgumentNullException("property");
            }
            string docString = string.Format(CultureInfo.InvariantCulture, ":param {0}:", property.Name);
            if (property.IsConstant)
            {
                docString = string.Format(CultureInfo.InvariantCulture, ":ivar {0}:", property.Name);
            }

            string summary = property.Summary;
            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (!string.IsNullOrWhiteSpace(summary))
            {
                docString += " " + summary;
            }

            if (!string.IsNullOrWhiteSpace(documentation))
            {
                docString += " " + documentation;
            }
            return docString;
        }

        /// <summary>
        /// Provides the type of the modelProperty
        /// </summary>
        /// <param name="type">Parameter type to be documented</param>
        /// <returns>Parameter name in the correct jsdoc notation</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public string GetPropertyDocumentationType(IType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var modelNamespace = ServiceClient.Name.ToPythonCase();
            if (!ServiceClient.Namespace.IsNullOrEmpty())
                modelNamespace = ServiceClient.Namespace;

            string result = "object";
            var primaryType = type as PrimaryType;
            var listType = type as SequenceType;
            if (primaryType != null)
            {
                if (primaryType.Type == KnownPrimaryType.Credentials)
                {
                    result = string.Format(CultureInfo.InvariantCulture, ":mod:`{0}`", CredentialObject);
                }
                else
                {
                    result = type.Name;
                }
            }
            else if (listType != null)
            {
                result = string.Format(CultureInfo.InvariantCulture, "list of {0}", GetPropertyDocumentationType(listType.ElementType));
            }
            else if (type is EnumType)
            {
                result = string.Format(CultureInfo.InvariantCulture, "str or :class:`{0} <{1}.models.{0}>`", type.Name, modelNamespace);
            }
            else if (type is DictionaryType)
            {
                result = "dict";
            }
            else if (type is CompositeType)
            {
                result = string.Format(CultureInfo.InvariantCulture, ":class:`{0} <{1}.models.{0}>`", type.Name, modelNamespace);
            }

            return result;
        }

        public virtual bool NeedsExtraImport
        {
            get { return false; }
        }

        public bool HasAnyDefaultExceptions
        {
            get { return this.MethodTemplateModels.Any(item => item.DefaultResponse.Body == null); }
        }
    }
}