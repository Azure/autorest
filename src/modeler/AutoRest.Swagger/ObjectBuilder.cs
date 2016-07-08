// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.ClientModel;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Model;

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

        public virtual IType ParentBuildServiceType(string serviceTypeName)
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
        public virtual IType BuildServiceType(string serviceTypeName)
        {
            PrimaryType type = SwaggerObject.ToType();
            Debug.Assert(type != null);

            if (type.Type == KnownPrimaryType.Object && "file".Equals(SwaggerObject.Format, StringComparison.OrdinalIgnoreCase))
            {
                type = new PrimaryType(KnownPrimaryType.Stream);
            }
            type.Format = SwaggerObject.Format;
            if (SwaggerObject.Enum != null && type.Type == KnownPrimaryType.String && !(IsSwaggerObjectConstant(SwaggerObject)))
            {
                var enumType = new EnumType();
                SwaggerObject.Enum.ForEach(v => enumType.Values.Add(new EnumValue { Name = v, SerializedName = v }));
                if (SwaggerObject.Extensions.ContainsKey(CodeGenerator.EnumObject))
                {
                    var enumObject = SwaggerObject.Extensions[CodeGenerator.EnumObject] as Newtonsoft.Json.Linq.JContainer;
                    if (enumObject != null)
                    {
                        enumType.Name= enumObject["name"].ToString();
                        if (enumObject["modelAsString"] != null)
                        {
                            enumType.ModelAsString = bool.Parse(enumObject["modelAsString"].ToString());
                        }
                    }
                    enumType.SerializedName = enumType.Name;
                    if (string.IsNullOrEmpty(enumType.Name))
                    {
                        throw new InvalidOperationException(
                            string.Format(CultureInfo.InvariantCulture, 
                                "{0} extension needs to specify an enum name.", 
                                CodeGenerator.EnumObject));
                    }
                    var existingEnum =
                        Modeler.ServiceClient.EnumTypes.FirstOrDefault(
                            e => e.Name.Equals(enumType.Name, StringComparison.OrdinalIgnoreCase));
                    if (existingEnum != null)
                    {
                        if (!existingEnum.Equals(enumType))
                        {
                            throw new InvalidOperationException(
                                string.Format(CultureInfo.InvariantCulture,
                                    "Swagger document contains two or more {0} extensions with the same name '{1}' and different values.",
                                    CodeGenerator.EnumObject,
                                    enumType.Name));
                        }
                    }
                    else
                    {
                        Modeler.ServiceClient.EnumTypes.Add(enumType);
                    }
                }
                else
                {
                    enumType.ModelAsString = true;
                    enumType.Name = string.Empty;
                    enumType.SerializedName = string.Empty;
                }
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
                return new SequenceType
                {
                    ElementType = elementType
                };
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
                return new DictionaryType
                {
                    ValueType =
                        SwaggerObject.AdditionalProperties.GetBuilder(Modeler)
                            .BuildServiceType((dictionaryValueServiceTypeName))
                };
            }

            return type;
        }

        public static void PopulateParameter(IParameter parameter, SwaggerObject swaggerObject)
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

            var compositeType = parameter.Type as CompositeType;
            if (compositeType != null && compositeType.ComposedProperties.Any())
            {
                if (compositeType.ComposedProperties.All(p => p.IsConstant))
                {
                    parameter.DefaultValue = "{}";
                    parameter.IsConstant = true;
                }
            }


            parameter.Documentation = swaggerObject.Description;
            parameter.CollectionFormat = swaggerObject.CollectionFormat;
            var enumType = parameter.Type as EnumType;
            if (enumType != null)
            {
                if (parameter.Documentation == null)
                {
                    parameter.Documentation = string.Empty;
                }
                else
                {
                    parameter.Documentation = parameter.Documentation.TrimEnd('.') + ". ";
                }
                parameter.Documentation += "Possible values include: " +
                                           string.Join(", ", enumType.Values.Select(v =>
                                               string.Format(CultureInfo.InvariantCulture,
                                               "'{0}'", v.Name)));
            }
            swaggerObject.Extensions.ForEach(e => parameter.Extensions[e.Key] = e.Value);

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

            if (!string.IsNullOrEmpty(swaggerObject.Maximum) && !swaggerObject.ExclusiveMaximum)
            {
                constraints[Constraint.InclusiveMaximum] = swaggerObject.Maximum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Maximum) && swaggerObject.ExclusiveMaximum)
            {
                constraints[Constraint.ExclusiveMaximum] = swaggerObject.Maximum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Minimum) && !swaggerObject.ExclusiveMinimum)
            {
                constraints[Constraint.InclusiveMinimum] = swaggerObject.Minimum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Minimum) && swaggerObject.ExclusiveMinimum)
            {
                constraints[Constraint.ExclusiveMinimum] = swaggerObject.Minimum;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MaxLength))
            {
                constraints[Constraint.MaxLength] = swaggerObject.MaxLength;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MinLength))
            {
                constraints[Constraint.MinLength] = swaggerObject.MinLength;
            }
            if (!string.IsNullOrEmpty(swaggerObject.Pattern))
            {
                constraints[Constraint.Pattern] = swaggerObject.Pattern;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MaxItems))
            {
                constraints[Constraint.MaxItems] = swaggerObject.MaxItems;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MinItems))
            {
                constraints[Constraint.MinItems] = swaggerObject.MinItems;
            }
            if (!string.IsNullOrEmpty(swaggerObject.MultipleOf))
            {
                constraints[Constraint.MultipleOf] = swaggerObject.MultipleOf;
            }
            if (swaggerObject.UniqueItems)
            {
                constraints[Constraint.UniqueItems] = "true";
            }
        }
    }
}