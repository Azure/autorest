// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;

namespace AutoRest.Python.TemplateModels
{
    public class ModelTemplateModel : CompositeType
    {
        private ModelTemplateModel _parent = null;
        private bool _isException = false;
        private readonly IList<CompositeType> _subModelTypes = new List<CompositeType>();
        
        public ModelTemplateModel(CompositeType source, ServiceClient serviceClient)
        {
            if (!string.IsNullOrEmpty(source.PolymorphicDiscriminator))
            {
                if (!source.Properties.Any(p => p.Name == source.PolymorphicDiscriminator))
                {
                    var polymorphicProperty = new Property
                    {
                        IsRequired = true,
                        Name = source.PolymorphicDiscriminator,
                        SerializedName = source.PolymorphicDiscriminator,
                        Documentation = "Polymorphic Discriminator",
                        Type = new PrimaryType(KnownPrimaryType.String) { Name = "str" }
                    };
                    source.Properties.Add(polymorphicProperty);
                }
            }
            this.LoadFrom(source);
            ServiceClient = serviceClient;
            
            if (ServiceClient.ErrorTypes.Contains(source))
            {
                _isException = true;
            }

            if (source.BaseModelType != null)
            {
                _parent = new ModelTemplateModel(source.BaseModelType, serviceClient);
            }

            foreach (var property in ComposedProperties)
            {
                if (string.IsNullOrWhiteSpace(property.DefaultValue))
                {
                    property.DefaultValue = PythonConstants.None;
                }
            }

            if (this.IsPolymorphic)
            {
                foreach (var modelType in ServiceClient.ModelTypes)
                {
                    if (modelType.BaseModelType == source)
                    {
                        _subModelTypes.Add(modelType);
                    }
                }
            }
        }

        public IList<CompositeType> SubModelTypes
        {
            get
            {
                return _subModelTypes;
            }
        }

        public bool IsException
        {
            get { return _isException; }
        }

        public bool IsParameterGroup
        {
            get
            {
                foreach (var prop in this.Properties)
                {
                    if (prop.SerializedName != null)
                    {
                        return false;
                    }
                }
                return true;
            }
        }

        public IList<string> Validators
        {
            get
            {
                List<string> validators = new List<string>();
                foreach (var parameter in ComposedProperties)
                {
                    var validation = new List<string>();
                    if (parameter.IsRequired)
                    {
                        validation.Add("'required': True");
                    }
                    if (parameter.IsConstant)
                    {
                        validation.Add("'constant': True");
                    }
                    if (parameter.IsReadOnly)
                    {
                        validation.Add("'readonly': True");
                    }
                    if (parameter.Constraints.Any())
                    {
                        validation.AddRange(BuildValidationParameters(parameter.Constraints));
                    }
                    if (validation.Any())
                    {
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'{0}': {{{1}}},", parameter.Name, string.Join(", ", validation)));
                    }
                }
                return validators;
            }
        }

        public ServiceClient ServiceClient { get; set; }

        private static List<string> BuildValidationParameters(Dictionary<Constraint, string> constraints)
        {
            List<string> validators = new List<string>();
            foreach (var constraint in constraints.Keys)
            {
                switch (constraint)
                {
                    case Constraint.ExclusiveMaximum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'maximum_ex': {0}", constraints[constraint]));
                        break;
                    case Constraint.ExclusiveMinimum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'minimum_ex': {0}", constraints[constraint]));
                        break;
                    case Constraint.InclusiveMaximum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'maximum': {0}", constraints[constraint]));
                        break;
                    case Constraint.InclusiveMinimum:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'minimum': {0}", constraints[constraint]));
                        break;
                    case Constraint.MaxItems:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'max_items': {0}", constraints[constraint]));
                        break;
                    case Constraint.MaxLength:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'max_length': {0}", constraints[constraint]));
                        break;
                    case Constraint.MinItems:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'min_items': {0}", constraints[constraint]));
                        break;
                    case Constraint.MinLength:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'min_length': {0}", constraints[constraint]));
                        break;
                    case Constraint.MultipleOf:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'multiple': {0}", constraints[constraint]));
                        break;
                    case Constraint.Pattern:
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'pattern': '{0}'", constraints[constraint]));
                        break;
                    case Constraint.UniqueItems:
                        var pythonBool = Convert.ToBoolean(constraints[constraint], CultureInfo.InvariantCulture) ? "True" : "False";
                        validators.Add(string.Format(CultureInfo.InvariantCulture, "'unique': {0}", pythonBool));
                        break;
                    default:
                        throw new NotSupportedException("Constraint '" + constraint + "' is not supported.");
                }
            }
            return validators;

        }

        public bool IsPolymorphic
        {
            get
            {
                if(!string.IsNullOrEmpty(this.PolymorphicDiscriminator))
                {
                    return true;
                }
                else if(this._parent != null)
                {
                    return _parent.IsPolymorphic;
                }

                return false;
            }
        }

        public bool HasParent
        {
            get { return this._parent != null; }
        }

        public bool NeedsConstructor
        {
            get
            {
                var nonConstant = Properties.Where(p => !p.IsConstant);
                if (nonConstant.Any())
                {
                    return true;
                }
                else
                {
                    return (HasParent || NeedsPolymorphicConverter);
                }
            }
        }

        public string BuildSummaryAndDescriptionString()
        {
            string summaryString = string.IsNullOrWhiteSpace(this.Summary) &&
                                   string.IsNullOrWhiteSpace(this.Documentation)
                ? this.Name
                : this.Summary;

            return PythonCodeGenerator.BuildSummaryAndDescriptionString(summaryString, this.Documentation);
        }

        /// <summary>
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
            if (property.IsConstant || property.IsReadOnly)
            {
                docString = string.Format(CultureInfo.InvariantCulture, ":ivar {0}:", property.Name);
            }

            string summary = property.Summary;
            if (!string.IsNullOrWhiteSpace(summary) && !summary.EndsWith(".", StringComparison.OrdinalIgnoreCase))
            {
                summary += ".";
            }

            string documentation = property.Documentation;
            if (property.DefaultValue != PythonConstants.None)
            {
                if (documentation != null && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
                {
                    documentation += ".";
                }
                documentation += " Default value: " + property.DefaultValue + " .";
            }

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

        public IList<string> RequiredFieldsList
        {
            get
            {
                List<string> requiredFields = new List<string>();
                foreach (var property in Properties)
                {
                    if (property.IsRequired)
                    {
                        requiredFields.Add(property.Name);
                    }
                }
                if (this._parent != null)
                {
                    requiredFields.AddRange(this._parent.RequiredFieldsList);
                    requiredFields = requiredFields.Distinct().ToList();
                }
                return requiredFields;
            }
        }

        public IEnumerable<Property> ReadOnlyAttributes
        {
            get
            {
                return ComposedProperties.Where(p => p.IsConstant || p.IsReadOnly);
            }
        }

        public IDictionary<string, IType> ComplexConstants
        {
            get
            {
                Dictionary<string, IType> complexConstant = new Dictionary<string, IType> ();
                foreach (var property in Properties)
                {
                    if (property.IsConstant)
                    {
                        CompositeType compType = property.Type as CompositeType;
                        if (compType != null)
                        {
                            complexConstant[property.Name] = compType;
                        }
                    }
                }
                return complexConstant;
            }
        }

        public virtual string SuperParameterDeclaration()
        {
            List<string> combinedDeclarations = new List<string>();

            foreach (var property in ComposedProperties.Except(Properties).Except(ReadOnlyAttributes))
            {
                if (this.IsPolymorphic)
                    if (property.Name == this.BasePolymorphicDiscriminator)
                        continue;
                combinedDeclarations.Add(string.Format(CultureInfo.InvariantCulture, "{0}={0}", property.Name));
            }
            return string.Join(", ", combinedDeclarations);
        }

        public virtual string MethodParameterDeclaration()
        {
            List<string> declarations = new List<string>();
            List<string> requiredDeclarations = new List<string>();
            List<string> combinedDeclarations = new List<string>();

            foreach (var property in ComposedProperties.Except(ReadOnlyAttributes))
            {
                if (this.IsPolymorphic)
                    if (property.Name == this.BasePolymorphicDiscriminator)
                        continue;

                if (property.IsRequired && property.DefaultValue == PythonConstants.None)
                {
                    requiredDeclarations.Add(property.Name);
                }
                else
                {
                    declarations.Add(string.Format(CultureInfo.InvariantCulture, "{0}={1}", property.Name, property.DefaultValue));
                }
            }

            if (requiredDeclarations.Any())
            {
                combinedDeclarations.Add(string.Join(", ", requiredDeclarations));
            }
            if (declarations.Any())
            {
                combinedDeclarations.Add(string.Join(", ", declarations));
            }

            if (!combinedDeclarations.Any())
            {
                return string.Empty;
            }
            return ", " + string.Join(", ", combinedDeclarations);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Naming", "CA2204:Literals should be spelled correctly", MessageId = "PolymorphicDiscriminator")]
        public string BasePolymorphicDiscriminator
        {
            get
            {
                CompositeType type = this;
                while (type != null)
                {
                    if (!string.IsNullOrEmpty(type.PolymorphicDiscriminator))
                    {
                        return type.PolymorphicDiscriminator;
                    }
                    type = type.BaseModelType;
                }
                throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture, "No PolymorphicDiscriminator defined for type {0}", this.Name));
            }
        }

        public string SubModelTypeList
        {
            get
            {
                List<string> typeTuple = new List<string>();
                foreach (var modelType in this.SubModelTypes)
                {
                    typeTuple.Add(
                        string.Format(CultureInfo.InvariantCulture, "'{0}': '{1}'",
                            modelType.SerializedName, modelType.Name
                        ));
                }

                return string.Join(", ", typeTuple);
            }
        }

        public virtual string ExceptionTypeDefinitionName
        {
            get
            {
                return this.GetExceptionDefineType();
            }
        }

        public virtual string InitializeProperty(Property modelProperty)
        {
            if (modelProperty == null || modelProperty.Type == null)
            {
                throw new ArgumentNullException("modelProperty");
            }

            //'id':{'key':'id', 'type':'str'},
            return string.Format(CultureInfo.InvariantCulture,
                "'{0}': {{'key': '{1}', 'type': '{2}'}},",
                modelProperty.Name, modelProperty.SerializedName,
                ClientModelExtensions.GetPythonSerializationType(modelProperty.Type));
        }

        public string InitializeProperty(string objectName, Property property)
        {
            if (property == null || property.Type == null)
            {
                throw new ArgumentNullException("property");
            }
            if (property.IsReadOnly)
            {
                return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = None", objectName, property.Name);
            }
            if (property.IsConstant)
            {
                if (ComplexConstants.ContainsKey(property.Name))
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0} = {1}()", property.Name, property.Type.Name);
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", property.Name, property.DefaultValue);
                }
            }
            if (IsPolymorphic)
            {
                if (property.Name == this.BasePolymorphicDiscriminator)
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = None", objectName, property.Name);
                }
            }
            return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = {1}", objectName, property.Name);
        }

        public bool NeedsPolymorphicConverter
        {
            get
            {
                return this.IsPolymorphic && BaseModelType != null;
            }
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

            string result = "object";
            var modelNamespace = ServiceClient.Name.ToPythonCase();
            if (!ServiceClient.Namespace.IsNullOrEmpty())
                modelNamespace = ServiceClient.Namespace;

            var listType = type as SequenceType;
            if (type is PrimaryType)
            {
                result = type.Name;
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
    }
}