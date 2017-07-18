// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Core.Utilities.Collections;
using AutoRest.Swagger.Model;
using static AutoRest.Core.Utilities.DependencyInjection;
using Newtonsoft.Json.Linq;

namespace AutoRest.Swagger
{
    /// <summary>
    /// The builder for building a generic swagger object into parameters, 
    /// service types or Json serialization types.
    /// </summary>
    public class ObjectBuilder
    {
        protected SwaggerObject SwaggerObject { get; set; }
        protected SwaggerModeler Modeler { get; set; }

        public ObjectBuilder(SwaggerObject swaggerObject, SwaggerModeler modeler)
        {
            SwaggerObject = swaggerObject;
            Modeler = modeler;
        }

        public virtual IModelType ParentBuildServiceType(string serviceTypeName)
        {
            // Should not try to get parent from generic swagger object builder
            throw new InvalidOperationException();
        }

        /// <summary>
        /// The visitor method for building service types. This is called when an instance of this class is
        /// visiting a _swaggerModeler to build a service type.
        /// </summary>
        /// <param name="serviceTypeName">name for the service type</param>
        /// <returns>built service type</returns>
        public virtual IModelType BuildServiceType(string serviceTypeName)
        {
            PrimaryType type = SwaggerObject.ToType();
            Debug.Assert(type != null);

            if (type.KnownPrimaryType == KnownPrimaryType.Object && SwaggerObject.KnownFormat == KnownFormat.file )
            {
                type = New<PrimaryType>(KnownPrimaryType.Stream);
            }
            type.XmlProperties = (SwaggerObject as Schema)?.Xml;
            type.Format = SwaggerObject.Format;
            var xMsEnum = SwaggerObject.Extensions.GetValue<JToken>(Core.Model.XmsExtensions.Enum.Name);
            if ((SwaggerObject.Enum != null || xMsEnum != null) && type.KnownPrimaryType == KnownPrimaryType.String && !(IsSwaggerObjectConstant(SwaggerObject)))
            {
                var enumType = New<EnumType>();
                if (SwaggerObject.Enum != null)
                {
                    SwaggerObject.Enum.ForEach(v => enumType.Values.Add(new EnumValue { Name = v, SerializedName = v }));
                }
                if (xMsEnum != null)
                {
                    var enumObject = xMsEnum as JContainer;
                    if (enumObject != null)
                    {
                        enumType.SetName(enumObject["name"].ToString() );
                        if (enumObject["modelAsString"] != null)
                        {
                            enumType.ModelAsString = bool.Parse(enumObject["modelAsString"].ToString());
                        }
                        var valueOverrides = enumObject["values"] as JArray;
                        if (valueOverrides != null)
                        {
                            enumType.Values.Clear();
                            foreach (var valueOverride in valueOverrides)
                            {
                                var value = valueOverride["value"];
                                var description = valueOverride["description"];
                                var name = valueOverride["name"] ?? value;
                                enumType.Values.Add(new EnumValue
                                {
                                    Name = (string)name,
                                    SerializedName = (string)value,
                                    Description = (string)description
                                });
                            }
                        }
                    }
                    enumType.SerializedName = enumType.Name;
                    if (string.IsNullOrEmpty(enumType.Name))
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture, 
                                "{0} extension needs to specify an enum name.",
                                Core.Model.XmsExtensions.Enum.Name));
                    }
                    var existingEnum =
                        Modeler.CodeModel.EnumTypes.FirstOrDefault(
                            e => e.Name.RawValue.EqualsIgnoreCase(enumType.Name.RawValue));
                    if (existingEnum != null)
                    {
                        if (!existingEnum.StructurallyEquals(enumType))
                        {
                            throw new InvalidOperationException(
                                string.Format(CultureInfo.InvariantCulture,
                                    "Swagger document contains two or more {0} extensions with the same name '{1}' and different values.",
                                    Core.Model.XmsExtensions.Enum.Name,
                                    enumType.Name));
                        }
                        // Use the existing one!
                        enumType = existingEnum;
                    }
                    else
                    {
                        Modeler.CodeModel.Add(enumType);
                    }
                }
                else
                {
                    enumType.ModelAsString = true;
                    enumType.SetName( string.Empty);
                    enumType.SerializedName = string.Empty;
                }
                enumType.XmlProperties = (SwaggerObject as Schema)?.Xml;
                return enumType;
            }
            if (SwaggerObject.Type == DataType.Array)
            {
                string itemServiceTypeName;
                if (SwaggerObject.Items.Reference != null)
                {
                    itemServiceTypeName = SwaggerObject.Items.Reference.StripDefinitionPath();
                }
                else
                {
                    itemServiceTypeName = serviceTypeName + "Item";
                }

                var elementType =
                    SwaggerObject.Items.GetBuilder(Modeler).BuildServiceType(itemServiceTypeName);
                return New<SequenceType>(new 
                {
                    ElementType = elementType,
                    Extensions = SwaggerObject.Items.Extensions,
                    XmlProperties = (SwaggerObject as Schema)?.Xml,
                    ElementXmlProperties = SwaggerObject.Items?.Xml
                });
            }
            if (SwaggerObject.AdditionalProperties != null)
            {
                string dictionaryValueServiceTypeName;
                if (SwaggerObject.AdditionalProperties.Reference != null)
                {
                    dictionaryValueServiceTypeName = SwaggerObject.AdditionalProperties.Reference.StripDefinitionPath();
                }
                else
                {
                    dictionaryValueServiceTypeName = serviceTypeName + "Value";
                }
                return New<DictionaryType>(new 
                {
                    ValueType =
                        SwaggerObject.AdditionalProperties.GetBuilder(Modeler)
                            .BuildServiceType((dictionaryValueServiceTypeName)),
                    Extensions = SwaggerObject.AdditionalProperties.Extensions,
                    XmlProperties = (SwaggerObject as Schema)?.Xml
                });
            }

            return type;
        }

        public static void PopulateParameter(IVariable parameter, SwaggerObject swaggerObject)
        {
            if (swaggerObject == null)
            {
                throw new ArgumentNullException("swaggerObject");
            }
            if (parameter == null)
            {
                throw new ArgumentNullException("parameter");
            }
            parameter.IsRequired = swaggerObject.IsRequired;
            parameter.DefaultValue = swaggerObject.Default;

            if (IsSwaggerObjectConstant(swaggerObject))
            {
                parameter.DefaultValue = swaggerObject.Enum[0];
                parameter.IsConstant = true;
            }

            parameter.Documentation = swaggerObject.Description;
            parameter.CollectionFormat = swaggerObject.CollectionFormat;

            // tag the paramter with all the extensions from the swagger object
            parameter.Extensions.AddRange(swaggerObject.Extensions);

            SetConstraints(parameter.Constraints, swaggerObject);
        }

        private static bool IsSwaggerObjectConstant(SwaggerObject swaggerObject)
        {
            return (swaggerObject.Enum != null && swaggerObject.Enum.Count == 1 && swaggerObject.IsRequired);
        }

        public static void SetConstraints(Dictionary<Constraint, string> constraints, SwaggerObject swaggerObject)
        {
            if (constraints == null)
            {
                throw new ArgumentNullException("constraints");
            }
            if (swaggerObject == null)
            {
                throw new ArgumentNullException("swaggerObject");
            }

            if (!string.IsNullOrEmpty(swaggerObject.Maximum)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.Maximum))
                && !swaggerObject.ExclusiveMaximum)

            {
                constraints[Constraint.InclusiveMaximum] = swaggerObject.Maximum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Maximum)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.Maximum))
                && swaggerObject.ExclusiveMaximum
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.ExclusiveMaximum)))
            {
                constraints[Constraint.ExclusiveMaximum] = swaggerObject.Maximum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Minimum)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.Minimum))
                && !swaggerObject.ExclusiveMinimum)
            {
                constraints[Constraint.InclusiveMinimum] = swaggerObject.Minimum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Minimum)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.Minimum))
                && swaggerObject.ExclusiveMinimum
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.ExclusiveMinimum)))
            {
                constraints[Constraint.ExclusiveMinimum] = swaggerObject.Minimum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MaxLength)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.MaxLength)))
            {
                constraints[Constraint.MaxLength] = swaggerObject.MaxLength;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MinLength)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.MinLength)))
            {
                constraints[Constraint.MinLength] = swaggerObject.MinLength;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Pattern)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.Pattern)))
            {
                constraints[Constraint.Pattern] = swaggerObject.Pattern;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MaxItems)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.MaxItems)))
            {
                constraints[Constraint.MaxItems] = swaggerObject.MaxItems;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MinItems)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.MinItems)))
            {
                constraints[Constraint.MinItems] = swaggerObject.MinItems;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MultipleOf)
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.MultipleOf)))
            {
                constraints[Constraint.MultipleOf] = swaggerObject.MultipleOf;
            }
            if (swaggerObject.UniqueItems
                && swaggerObject.IsConstraintSupported(nameof(swaggerObject.UniqueItems)))
            {
                constraints[Constraint.UniqueItems] = "true";
            }
        }
    }
}