// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Linq;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;
using Microsoft.Rest.Modeler.Swagger.Model;
using System.Globalization;

namespace Microsoft.Rest.Modeler.Swagger
{
    /// <summary>
    /// The builder for building swagger schema into client model parameters, 
    /// service types or Json serialization types.
    /// </summary>
    public class SchemaBuilder : ObjectBuilder
    {
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
                            IsRequired = property.Value.IsRequired
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
                        propertyObj.IsReadOnly = property.Value.ReadOnly;
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

            // Put this in the extended type serializationProperty for building method return type in the end
            if (_schema.Extends != null)
            {
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