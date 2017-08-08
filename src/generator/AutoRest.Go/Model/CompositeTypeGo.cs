// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Go.Model
{
    /// <summary>
    /// Defines a synthesized composite type that wraps a primary type, array, or dictionary method response.
    /// </summary>
    public class CompositeTypeGo : CompositeType
    {
        private bool _wrapper;

        // True if the type is returned by a method
        public bool IsResponseType;

        // Name of the field containing the URL used to retrieve the next result set
        // (null or empty if the model is not paged).
        public string NextLink;

        public bool PreparerNeeded = false;

        public IEnumerable<CompositeType> DerivedTypes => CodeModel.ModelTypes.Where(t => t.DerivesFrom(this));

        public CompositeTypeGo()
        {

        }

        public CompositeTypeGo(string name) : base(name)
        {

        }

        public CompositeTypeGo(IModelType wrappedType)
        {
            if (!wrappedType.ShouldBeSyntheticType())
            {
                throw new ArgumentException("{0} is not a valid type for SyntheticType", wrappedType.ToString());
            }

            // gosdk: Ensure the generated name does not collide with existing type names
            BaseType = wrappedType;

            IModelType elementType = GetElementType(wrappedType);

            if (elementType is PrimaryType)
            {
                var type = (elementType as PrimaryType).KnownPrimaryType;
                switch (type)
                {
                    case KnownPrimaryType.Object:
                        Name += "SetObject";
                        break;

                    case KnownPrimaryType.Boolean:
                        Name += "Bool";
                        break;

                    case KnownPrimaryType.Double:
                        Name += "Float64";
                        break;

                    case KnownPrimaryType.Int:
                        Name += "Int32";
                        break;

                    case KnownPrimaryType.Long:
                        Name += "Int64";
                        break;

                    case KnownPrimaryType.Stream:
                        Name += "ReadCloser";
                        break;

                    default:
                        Name += type.ToString();
                        break;
                }
            }
            else if (elementType is EnumType)
            {
                Name += "String";
            }
            else
            {
                Name += elementType.Name;
            }

            // add the wrapped type as a property named Value
            var p = new PropertyGo();
            p.Name = "Value";
            p.SerializedName = "value";
            p.ModelType = wrappedType;
            Add(p);

            _wrapper = true;
        }

        /// <summary>
        /// Add imports for composite types.
        /// </summary>
        /// <param name="imports"></param>
        public void AddImports(HashSet<string> imports)
        {
            Properties.ForEach(p => p.ModelType.AddImports(imports));
        }

        public string Fields()
        {
            var indented = new IndentedStringBuilder("    ");
            var properties = Properties.Cast<PropertyGo>().ToList();

            if (BaseModelType != null)
            {
                indented.Append(((CompositeTypeGo)BaseModelType).Fields());
            }

            // If the type is a paged model type, ensure the nextLink field exists
            // Note: Inject the field into a copy of the property list so as to not pollute the original list
            if (!string.IsNullOrEmpty(NextLink))
            {
                var nextLinkField = NextLink;
                foreach (Property p in properties)
                {
                    p.Name = CodeNamerGo.PascalCaseWithoutChar(p.Name, '.');
                    if (p.Name.EqualsIgnoreCase(nextLinkField))
                    {
                        p.Name = nextLinkField;
                    }
                }

                var baseHasNextLink = false;
                if (BaseModelType != null)
                {
                    baseHasNextLink = BaseModelType.Properties.Any(p => p.Name.EqualsIgnoreCase(nextLinkField));
                }

                if (!baseHasNextLink && !properties.Any(p => p.Name.EqualsIgnoreCase(nextLinkField)))
                {
                    var property = new PropertyGo();
                    property.Name = nextLinkField;
                    property.ModelType = new PrimaryTypeGo(KnownPrimaryType.String);
                    properties.Add(property);
                }
            }

            // Emit each property, except for named Enumerated types, as a pointer to the type
            foreach (var property in properties)
            {
                var enumType = property.ModelType as EnumTypeGo;
                if (enumType != null && enumType.IsNamed)
                {
                    indented.AppendFormat("{0} {1} {2}\n",
                                    property.Name,
                                    enumType.Name,
                                    property.JsonTag());

                }
                else if (property.ModelType is DictionaryType)
                {
                    indented.AppendFormat("{0} *{1} {2}\n", property.Name, (property.ModelType as DictionaryTypeGo).Name, property.JsonTag());
                }
                else if (property.ModelType.PrimaryType(KnownPrimaryType.Object))
                {
                    // TODO: I don't think this is the best way to handle object types
                    indented.AppendFormat("{0} *{1} {2}\n", property.Name, property.ModelType.Name, property.JsonTag());
                }
                else if (property.ShouldBeFlattened())
                {
                    // embed as an anonymous struct.  note that the ordering of this clause is
                    // important, i.e. we don't want to flatten primary types like dictionaries.
                    indented.AppendFormat("*{0} {1}\n", property.ModelType.Name, property.JsonTag());
                    property.Extensions[SwaggerExtensions.FlattenOriginalTypeName] = Name;
                }
                else
                {
                    indented.AppendFormat("{0} *{1} {2}\n", property.Name, property.ModelType.Name, property.JsonTag());
                }
            }

            return indented.ToString();
        }

        public bool IsWrapperType => _wrapper;

        public IModelType BaseType { get; private set; }

        public IModelType GetElementType(IModelType type)
        {
            if (type is SequenceTypeGo)
            {
                Name += "List";
                return GetElementType((type as SequenceType).ElementType);
            }
            else if (type is DictionaryTypeGo)
            {
                Name += "Set";
                return GetElementType(((type as DictionaryTypeGo).ValueType));
            }
            else
            {
                return type;
            }
        }

        public string PreparerMethodName => $"{Name}Preparer";

        public void SetName(string name)
        {
            Name = name;
        }
    }
}
