// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Model;

namespace Microsoft.Rest.Modeler.Swagger
{
    /// <summary>
    /// The builder for building swagger schema into client model parameters, 
    /// service types or Json serialization types.
    /// </summary>
    public class SchemaBuilder : ObjectBuilder
    {
        private const string DiscriminatorValueExtension = "x-ms-discriminator-value";

        private Schema _schema;

        public SchemaBuilder(Schema schema, SwaggerModeler modeler)
            : base(schema, modeler)
        {
            _schema = schema;
        }

        public override IType BuildServiceType(string serviceTypeName)
        {
            // Check if already generated
            if (serviceTypeName != null && Modeler.GeneratedTypes.ContainsKey(serviceTypeName))
            {
                return Modeler.GeneratedTypes[serviceTypeName];
            }

            _schema = Modeler.Resolver.Unwrap(_schema);

            // If primitive type
            if ((_schema.Type != null && _schema.Type != DataType.Object) ||
                _schema.AdditionalProperties != null)
            {
                return _schema.GetBuilder(Modeler).ParentBuildServiceType(serviceTypeName);
            }

            // If object with file format treat as stream
            if (_schema.Type != null 
                && _schema.Type == DataType.Object 
                && "file".Equals(SwaggerObject.Format, StringComparison.OrdinalIgnoreCase))
            {
                return PrimaryType.Stream;
            }

            // If the object does not have any properties, treat it as raw json (i.e. object)
            if (_schema.Properties.IsNullOrEmpty() && string.IsNullOrEmpty(_schema.Extends))
            {
                return PrimaryType.Object;
            }

            // Otherwise create new object type
            var objectType = new CompositeType 
                            { 
                                Name = serviceTypeName, 
                                SerializedName = serviceTypeName, 
                                Documentation = _schema.Description 
                            };
            // Put this in already generated types serializationProperty
            Modeler.GeneratedTypes[serviceTypeName] = objectType;

            if (_schema.Properties != null)
            {
                // Visit each property and recursively build service types
                foreach (var property in _schema.Properties)
                {
                    string name = property.Key;
                    if (name != _schema.Discriminator)
                    {
                        string propertyServiceTypeName;
                        if (property.Value.Reference != null)
                        {
                            propertyServiceTypeName = property.Value.Reference.StripDefinitionPath();
                        }
                        else
                        {
                            propertyServiceTypeName = serviceTypeName + "_" + property.Key;
                        }
                        var propertyType =
                            property.Value.GetBuilder(Modeler).BuildServiceType(propertyServiceTypeName);

                        var propertyObj = new Property
                        {
                            Name = name,
                            SerializedName = name,
                            Type = propertyType,
                            IsRequired = property.Value.IsRequired,
                            IsReadOnly = property.Value.ReadOnly,
                            DefaultValue = property.Value.Default
                        };
                        SetConstraints(propertyObj.Constraints, property.Value);

                        //propertyObj.Type = objectType;
                        propertyObj.Documentation = property.Value.Description;
                        var enumType = propertyType as EnumType;
                        if (enumType != null)
                        {
                            if (propertyObj.Documentation == null)
                            {
                                propertyObj.Documentation = string.Empty;
                            }
                            else
                            {
                                propertyObj.Documentation = propertyObj.Documentation.TrimEnd('.') + ". ";
                            }
                            propertyObj.Documentation += "Possible values for this property include: " +
                                                       string.Join(", ", enumType.Values.Select(v =>
                                                           string.Format(CultureInfo.InvariantCulture, 
                                                           "'{0}'", v.Name))) + ".";
                        }
                        objectType.Properties.Add(propertyObj);
                    }
                    else
                    {
                        objectType.PolymorphicDiscriminator = name;
                    }
                }
            }

            // Copy over extensions
            _schema.Extensions.ForEach(e => objectType.Extensions[e.Key] = e.Value);

            if (_schema.Extends != null)
            {
                // Optionally override the discriminator value for polymorphic types. We expect this concept to be
                // added to Swagger at some point, but until it is, we use an extension.
                object discriminatorValueExtension;
                if (objectType.Extensions.TryGetValue(DiscriminatorValueExtension, out discriminatorValueExtension))
                {
                    string discriminatorValue = discriminatorValueExtension as string;
                    if (discriminatorValue != null)
                    {
                        objectType.SerializedName = discriminatorValue;
                    }
                }

                // Put this in the extended type serializationProperty for building method return type in the end
                Modeler.ExtendedTypes[serviceTypeName] = _schema.Extends.StripDefinitionPath();
            }

            return objectType;
        }

        public override IType ParentBuildServiceType(string serviceTypeName)
        {
            return base.BuildServiceType(serviceTypeName);
        }
    }
}