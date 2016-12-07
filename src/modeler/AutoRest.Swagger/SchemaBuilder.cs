// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Swagger.Model;
using AutoRest.Swagger.Properties;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Swagger
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

        public override IModelType BuildServiceType(string serviceTypeName)
        {
            _schema = Modeler.Resolver.Unwrap(_schema);

            // If it's a primitive type, let the parent build service handle it
            if (_schema.IsPrimitiveType())
            {
                return _schema.GetBuilder(Modeler).ParentBuildServiceType(serviceTypeName);
            }

            // If it's known primary type, return that type
            var primaryType = _schema.GetSimplePrimaryType();
            if (primaryType != KnownPrimaryType.None)
            {
                return New<PrimaryType>(primaryType);
            }

            // Otherwise create new object type
            var objectType = New<CompositeType>(serviceTypeName,new 
            {
                SerializedName = serviceTypeName,
                Documentation = _schema.Description,
                ExternalDocsUrl = _schema.ExternalDocs?.Url,
                Summary = _schema.Title
            });

            // associate this type with its schema (by reference) in order to allow recursive models to terminate
            // (e.g. if `objectType` type has property of type `objectType[]`)
            if (Modeler.GeneratingTypes.ContainsKey(_schema))
            {
                return Modeler.GeneratingTypes[_schema];
            }
            Modeler.GeneratingTypes[_schema] = objectType;

            if (_schema.Type == DataType.Object && _schema.AdditionalProperties != null)
            {
                // this schema is defining 'additionalProperties' which expects to create an extra
                // property that will catch all the unbound properties during deserialization.
                var name = "additionalProperties";
                var propertyType = New<DictionaryType>(new
                {
                    ValueType = _schema.AdditionalProperties.GetBuilder(Modeler).BuildServiceType(
                               _schema.AdditionalProperties.Reference != null
                               ? _schema.AdditionalProperties.Reference.StripDefinitionPath()
                               : serviceTypeName + "Value"),
                    Extensions = _schema.AdditionalProperties.Extensions,
                    SupportsAdditionalProperties = true
                });

                // now add the extra property to the type.
                objectType.Add(New<Property>(new
                {
                    Name = name,
                    ModelType = propertyType,
                    Documentation = "Unmatched properties from the message are deserialized this collection"
                }));
            }

            if (_schema.Properties != null)
            {
                // Visit each property and recursively build service types
                foreach (var property in _schema.Properties)
                {
                    string name = property.Key;
                    if (name != _schema.Discriminator)
                    {
                        string propertyServiceTypeName;
                        Schema refSchema = null;

                        if (property.Value.ReadOnly && property.Value.IsRequired)
                        {
                            throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
                           Resources.ReadOnlyNotRequired, name, serviceTypeName));
                        }

                        if (property.Value.Reference != null)
                        {
                            propertyServiceTypeName = property.Value.Reference.StripDefinitionPath();
                            var unwrappedSchema = Modeler.Resolver.Unwrap(property.Value);

                            // For Enums use the referenced schema in order to set the correct property Type and Enum values
                            if (unwrappedSchema.Enum != null)
                            {
                                refSchema = new Schema().LoadFrom(unwrappedSchema);
                                if (property.Value.IsRequired)
                                {
                                    refSchema.IsRequired = property.Value.IsRequired;
                                }
                                //Todo: Remove the following when referenced descriptions are correctly ignored (Issue https://github.com/Azure/autorest/issues/1283)
                                refSchema.Description = property.Value.Description;
                            }
                        }
                        else
                        {
                            propertyServiceTypeName = serviceTypeName + "_" + property.Key;
                        }

                        var propertyType = refSchema != null
                                           ? refSchema.GetBuilder(Modeler).BuildServiceType(propertyServiceTypeName)
                                           : property.Value.GetBuilder(Modeler).BuildServiceType(propertyServiceTypeName);

                        var propertyObj = New<Property>(new
                        {
                            Name = name,
                            SerializedName = name,
                            ModelType = propertyType,
                            IsReadOnly = property.Value.ReadOnly,
                            Summary = property.Value.Title
                        });
                        PopulateParameter(propertyObj, refSchema != null ? refSchema : property.Value);
                        var propertyCompositeType = propertyType as CompositeType;
                        if (propertyObj.IsConstant ||
                            (propertyCompositeType != null
                                && propertyCompositeType.ContainsConstantProperties))
                        {
                            objectType.ContainsConstantProperties = true;
                        }

                        objectType.Add(propertyObj);
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
            
            // Put this in already generated types serializationProperty
            string localName = serviceTypeName;
            while (Modeler.GeneratedTypes.ContainsKey(localName))
            {
                var existing = Modeler.GeneratedTypes[localName];
                if (objectType.StructurallyEquals(existing))
                {
                    objectType = existing;
                    break;
                }
                localName = localName + "_";
            }
            Modeler.GeneratedTypes[localName] = objectType;

            return objectType;
        }

        public override IModelType ParentBuildServiceType(string serviceTypeName)
        {
            return base.BuildServiceType(serviceTypeName);
        }
    }
}