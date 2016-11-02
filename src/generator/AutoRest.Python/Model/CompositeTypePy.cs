// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python.Model
{
    public class CompositeTypePy : CompositeType, IExtendedModelTypePy
    {
        private CompositeTypePy _parent => BaseModelType as CompositeTypePy;
        
        private readonly IList<CompositeType> _subModelTypes = new List<CompositeType>();
        
        protected CompositeTypePy()
        {
        }

        protected CompositeTypePy(string name) : base(name)
        {
            
        }

        public override Property Add(Property item)
        {
            var result = base.Add(item);
            if (result != null)
            {
                AddPolymorphicPropertyIfNecessary();
            }
            return result;
        }

        /// <summary>
        /// Gets or sets the discriminator property for polymorphic types.
        /// </summary>
        public override string PolymorphicDiscriminator
        {
            get { return base.PolymorphicDiscriminator; }
            set
            {
                base.PolymorphicDiscriminator = value;
                AddPolymorphicPropertyIfNecessary();
            }
        }

        /// <summary>
        /// If PolymorphicDiscriminator is set, makes sure we have a PolymorphicDiscriminator property.
        /// </summary>
        private void AddPolymorphicPropertyIfNecessary()
        {
            if (!string.IsNullOrEmpty(PolymorphicDiscriminator) && Properties.All(p => p.Name != PolymorphicDiscriminator))
            {
                base.Add(New<Property>(new
                {
                    IsRequired = true,
                    Name = PolymorphicDiscriminator,
                    SerializedName = PolymorphicDiscriminator,
                    Documentation = "Polymorphic Discriminator",
                    ModelType = New<PrimaryType>(KnownPrimaryType.String)
                }));
            }
        }

        public IEnumerable<CompositeType> SubModelTypes => BaseIsPolymorphic?  CodeModel.ModelTypes.Where(each => ReferenceEquals(this, each.BaseModelType) ) : Enumerable.Empty<CompositeType>();

        public bool IsException => CodeModel.ErrorTypes.Contains(this);

        public bool IsParameterGroup => Properties.All(prop => prop.SerializedName == null);

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

        public bool HasParent => _parent != null;

        public bool NeedsConstructor
        {
            get
            {
                var nonConstant = Properties.Where(p => !p.IsConstant);
                if (nonConstant.Any())
                {
                    return true;
                }

                return (HasParent || NeedsPolymorphicConverter);
            }
        }

        public string BuildSummaryAndDescriptionString()
        {
            string summaryString = string.IsNullOrWhiteSpace(Summary) &&
                                   string.IsNullOrWhiteSpace(Documentation)
                ? (string)Name
                : Summary;

            return CodeGeneratorPy.BuildSummaryAndDescriptionString(summaryString, Documentation);
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

            string documentation = property.Documentation.Else(string.Empty);
            if (!property.DefaultValue.EqualsIgnoreCase(PythonConstants.None) )
            {
                if (!string.IsNullOrEmpty(documentation) && !documentation.EndsWith(".", StringComparison.OrdinalIgnoreCase))
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

        public IDictionary<string, IModelType> ComplexConstants
        {
            get
            {
                Dictionary<string, IModelType> complexConstant = new Dictionary<string, IModelType> ();
                foreach (var property in Properties)
                {
                    if (property.IsConstant)
                    {
                        CompositeType compType = property.ModelType as CompositeType;
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

            foreach (var property in ComposedProperties.Except(Properties).Except(ReadOnlyAttributes).Where( each =>!each.IsPolymorphicDiscriminator))
            {
                combinedDeclarations.Add(string.Format(CultureInfo.InvariantCulture, "{0}={0}", property.Name));
            }
            return string.Join(", ", combinedDeclarations);
        }

        public virtual string MethodParameterDeclaration()
        {
            List<string> declarations = new List<string>();
            List<string> requiredDeclarations = new List<string>();
            List<string> combinedDeclarations = new List<string>();

            foreach (var property in ComposedProperties.Except(ReadOnlyAttributes).Where(each => !each.IsPolymorphicDiscriminator))
            {
                if (this.BaseIsPolymorphic)
                    if (property.Name == this.BasePolymorphicDiscriminator)
                        continue;

                if (property.IsRequired && property.DefaultValue.RawValue.IsNullOrEmpty())
                {
                    requiredDeclarations.Add(property.Name);
                }
                else
                {
                    declarations.Add($"{property.Name}={property.DefaultValue}");
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
            if (modelProperty == null || modelProperty.ModelType == null)
            {
                throw new ArgumentNullException("modelProperty");
            }

            //'id':{'key':'id', 'type':'str'},
            return string.Format(CultureInfo.InvariantCulture,
                "'{0}': {{'key': '{1}', 'type': '{2}'}},",
                modelProperty.Name, modelProperty.SerializedName,
                ClientModelExtensions.GetPythonSerializationType(modelProperty.ModelType));
        }

        public string InitializeProperty(string objectName, Property property)
        {
            if (property == null || property.ModelType == null)
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
                    return string.Format(CultureInfo.InvariantCulture, "{0} = {1}()", property.Name, property.ModelTypeName);
                }
                else
                {
                    return string.Format(CultureInfo.InvariantCulture, "{0} = {1}", property.Name, property.DefaultValue);
                }
            }
            if (BaseIsPolymorphic && property.IsPolymorphicDiscriminator)
            {
                return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = None", objectName, property.Name);
            }
            return string.Format(CultureInfo.InvariantCulture, "{0}.{1} = {1}", objectName, property.Name);
        }

        public bool NeedsPolymorphicConverter => BaseIsPolymorphic && BaseModelType != null;

        /// <summary>
        /// Provides the type of the modelProperty
        /// </summary>
        /// <param name="type">Parameter type to be documented</param>
        /// <returns>Parameter name in the correct jsdoc notation</returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Globalization", "CA1308:NormalizeStringsToUppercase")]
        public string GetPropertyDocumentationType(IModelType type)
        {
            // todo: fix the glitch where some model types don't have their parent reference set correctly
            if (type.Parent == null && (type is CompositeTypePy))
            {
                ((CompositeTypePy)type).CodeModel = CodeModel;
            }
            if (type.Parent == null && (type is EnumTypePy))
            {
                ((EnumTypePy)type).CodeModel = CodeModel;
            }

            return (type as IExtendedModelTypePy)?.TypeDocumentation ?? PythonConstants.None;
        }

        public string TypeDocumentation =>       $":class:`{Name} <{((CodeModelPy)CodeModel)?.modelNamespace}.models.{Name}>`";
        public string ReturnTypeDocumentation => $":class:`{Name} <{((CodeModelPy)CodeModel)?.modelNamespace}.models.{Name}>`";
    }
}