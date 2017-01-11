// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Runtime.CompilerServices;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using Newtonsoft.Json;

namespace AutoRest.Python.Model
{
    public class CodeModelPy : CodeModel
    {
        public CodeModelPy()
        {
            // todo: properties is expected to be just the non-constant properties.
            // Properties.RemoveAll(p => ConstantProperties.Contains(p));
        }

        [JsonIgnore]
        public bool IsCustomBaseUri => Extensions.ContainsKey(SwaggerExtensions.ParameterizedHostExtension);

        [JsonIgnore]
        public IEnumerable<Property> ConstantProperties => Properties.Where(p => p.IsConstant);

        [JsonIgnore]
        public IEnumerable<MethodPy> MethodTemplateModels => Methods.Cast<MethodPy>();

        [JsonIgnore]
        public IEnumerable<CompositeTypePy> ModelTemplateModels => ModelTypes.Cast<CompositeTypePy>();

        [JsonIgnore]
        public virtual IEnumerable<MethodGroupPy> MethodGroupModels => Operations.Cast<MethodGroupPy>().Where( each => !each.IsCodeModelMethodGroup);
        

        public string PolymorphicDictionary
        {
            get
            {
                IndentedStringBuilder builder = new IndentedStringBuilder(IndentedStringBuilder.TwoSpaces);
                var polymorphicTypes = ModelTemplateModels.Where(m => m.BaseIsPolymorphic);

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
                var parameters = this.Properties.Where( each => !each.IsConstant).OrderBy(item => !item.IsRequired);
                var requireParams = new List<string>();
                foreach (var property in parameters)
                {
                    if (property.IsRequired)
                    {
                        requireParams.Add(property.Name);
                    }
                    else
                    {
                        requireParams.Add(string.Format(CultureInfo.InvariantCulture, "{0}=None", property.Name));
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
                var parameters = this.Properties.Where(each => !each.IsConstant).OrderBy(item => !item.IsRequired);
                var configParams = new List<string>();
                foreach (var property in parameters)
                {
                    configParams.Add(property.Name);
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
                foreach (var property in this.Properties.Where( each => !each.IsConstant ))
                {
                    if (property.IsRequired)
                    {
                        builder.
                            AppendFormat("if {0} is None:", property.Name).AppendLine().
                            Indent().
                                AppendLine(string.Format(CultureInfo.InvariantCulture, "raise ValueError(\"Parameter '{0}' must not be None.\")", property.Name)).
                            Outdent();
                        if (property.ModelType.IsPrimaryType(KnownPrimaryType.String))
                        {
                            builder.
                                AppendFormat("if not isinstance({0}, str):", property.Name).AppendLine().
                                Indent().
                                    AppendLine(string.Format(CultureInfo.InvariantCulture, "raise TypeError(\"Parameter '{0}' must be str.\")", property.Name)).
                                Outdent();
                        }
                    }
                    else
                    {
                        if (property.ModelType.IsPrimaryType(KnownPrimaryType.String))
                        {
                            builder.
                                AppendFormat("if {0} is not None and not isinstance({0}, str):", property.Name).AppendLine().
                                Indent().
                                    AppendLine(string.Format(CultureInfo.InvariantCulture, "raise TypeError(\"Optional parameter '{0}' must be str.\")", property.Name)).
                                Outdent();
                        }

                    }
                    

                }
                return builder.ToString();
            }
        }

        public virtual string UserAgent => PackageName;

        public virtual string SetupRequires => @"""msrest>=0.2.0""";
        

        public string Version => Settings.Instance.PackageVersion.Else(ApiVersion);

        public virtual bool HasAnyModel => ModelTemplateModels.Any();

        public string PackageName => Name.ToPythonCase().Replace("_", "");

        //TODO: Proper namespace validation and formatting
        public string modelNamespace => Namespace.Else(Name.ToPythonCase()).ToLower();

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
        public string GetPropertyDocumentationType(IModelType type)
        {
            return (type as IExtendedModelTypePy)?.TypeDocumentation ?? PythonConstants.None;
        }

        public virtual bool NeedsExtraImport => false;

        public bool HasAnyDefaultExceptions => MethodTemplateModels.Any(item => item.DefaultResponse.Body == null);

        public virtual string GetExceptionNameIfExist(IModelType type, bool needsQuote)
        {
            CompositeType compType = type as CompositeType;
            if (compType != null)
            {
                if (ErrorTypes.Contains(compType))
                {
                    if (needsQuote)
                    {
                        return ", '" + compType.GetExceptionDefineType() + "'";
                    }
                    return ", " + compType.GetExceptionDefineType();
                }
            }

            return string.Empty;
        }
    }
}