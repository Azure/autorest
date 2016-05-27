// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Globalization;
using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Model;
using Microsoft.Rest.Modeler.Swagger.Properties;

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
            if (_schema.Type != null && _schema.Type != DataType.Object )
            {
                // removed or condition: `|| _schema.AdditionalProperties != null`
                // Notes: 
                //      why would having AdditionalProperties on a type mean that it's primitive?
                //      this has the side effect of never emitting types that have additionalProperties 
                //      specified, and that's not correct wrt swagger.

                return _schema.GetBuilder(Modeler).ParentBuildServiceType(serviceTypeName);
            }


            if (_schema.Type == DataType.Object && _schema.AdditionalProperties ) 

            // If object with file format treat as stream
                if (_schema.Type != null 
                && _schema.Type == DataType.Object 
                && "file".Equals(SwaggerObject.Format, StringComparison.OrdinalIgnoreCase))
            {
                return new PrimaryType(KnownPrimaryType.Stream);
            }

            // If the object does not have any properties, treat it as raw json (i.e. object)
            if (_schema.Properties.IsNullOrEmpty() && string.IsNullOrEmpty(_schema.Extends))
            {
                return new PrimaryType(KnownPrimaryType.Object);
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

            // what do do with things that are not declared.
            // see ( Autorest #1057)
            if (_schema.AdditionalProperties != null)
            {
                // generate a catch-all property for everything else.
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
                        if (property.Value.ReadOnly && property.Value.IsRequired)
                        {
                            throw new InvalidOperationException(string.Format(CultureInfo.InvariantCulture,
                           Resources.ReadOnlyNotRequired, name, serviceTypeName));
                        }

                        var propertyObj = new Property
                        {
                            Name = name,
                            SerializedName = name,
                            Type = propertyType,
                            IsReadOnly = property.Value.ReadOnly
                        };
                        PopulateParameter(propertyObj, property.Value);
                        var propertyCompositeType = propertyType as CompositeType;
                        if (propertyObj.IsConstant || 
                            (propertyCompositeType != null 
                                && propertyCompositeType.ContainsConstantProperties))
                        {
                            objectType.ContainsConstantProperties = true;
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