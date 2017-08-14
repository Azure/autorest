using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Types;
using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Php.JsonBuilder;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md#schemaObject
    /// </summary>
    public class SchemaObject : JsonBuilder.Object
    {
        public string Ref { get; }

        public string Type { get; }

        public string Format { get; }

        public IEnumerable<string> Enum { get; }

        public IEnumerable<Property<SchemaObject>> Properties { get; }

        public SchemaObject AdditionalProperties { get; }

        public SchemaObject Items { get; }

        public IEnumerable<string> Required { get; }

        public IType ToPhpType()
        {
            if (Ref != null)
            {
                return PHP.Array();
            }
            switch (Type)
            {
                case "string":
                    return PHP.String;
                case "integer":
                    switch (Format)
                    {
                        case "int32":
                            return PHP.Integer;
                        case "int64":
                            return PHP.String;
                        default:
                            throw new Exception("unknown integer format: " + Format);
                    }
                case "boolean":
                    return PHP.Boolean;
                case "file":
                    return PHP.String;
                case "array":
                    return PHP.Array(Items.ToPhpType());
                case "object":
                    return PHP.Array(AdditionalProperties?.ToPhpType());
                default:
                    throw new Exception("unknown swagger type: " + Type);
            }
        }

        public static SchemaObject CreateDefinition(CompositeType type)
        {
            var additionalProperties = type.Properties
                .FirstOrDefault(p => p.SerializedName == null);
            var properties = type.Properties
                .Where(p => p.SerializedName != null);
            var swaggerProperties = properties.Select(p => Json.Property(
                p.SerializedName,
                Create(p.ModelType)));
            return new SchemaObject(
                properties: swaggerProperties,
                additionalProperties: additionalProperties == null 
                    ? null 
                    : Create(additionalProperties.ModelType),
                required: properties
                    .Where(p => p.IsRequired)
                    .Select(p => p.SerializedName));
        }

        public static SchemaObject Create(IModelType type)
        {
            if (type == null)
            {
                return null;
            }
            switch (type)
            {
                case CompositeType compositeType:
                    return new SchemaObject(@ref: "#/definitions/" + compositeType.SerializedName);
                case EnumType enumType:
                    return String(@enum: enumType.Values.Select(v => v.SerializedName));
                case PrimaryType primaryType:
                    return Primary(primaryType);
                case DictionaryType dictionaryType:
                    return Object(additionalProperties: Create(dictionaryType.ValueType));
                case SequenceType sequenceType:
                    return new SchemaObject(
                        type: "array",
                        items: Create(sequenceType.ElementType));
                default:
                    throw new Exception("unknown type: " + type.Name + ", typetype: " + type.GetType());
            }
        }

        public static SchemaObject Const(IModelType type, string value)
        {
            if (type is PrimaryType primaryType 
                && primaryType.KnownPrimaryType == KnownPrimaryType.String)
            {
                return String(@enum: new[] { value });
            }
            else
            {
                throw new Exception("unknown type: " + type.Name);
            }
        }

        private static SchemaObject Primary(PrimaryType type)
        {
            if (!PrimaryTypes.TryGetValue(type.KnownPrimaryType, out var result))
            {
                throw new Exception("PHP: unknown type: " + type.KnownPrimaryType);
            }
            return result;
        }

        private static IReadOnlyDictionary<KnownPrimaryType, SchemaObject> PrimaryTypes { get; }
            = new Dictionary<KnownPrimaryType, SchemaObject>
            {
                { KnownPrimaryType.Int, Integer("int32") },
                { KnownPrimaryType.Long, Integer("int64") },
                { KnownPrimaryType.Double, Number("double") },
                { KnownPrimaryType.Decimal, Number("decimal") },
                { KnownPrimaryType.String, String() },
                { KnownPrimaryType.Boolean, new SchemaObject(type: "boolean") },
                { KnownPrimaryType.Date, String("date") },
                { KnownPrimaryType.DateTime, String("date-time") },
                { KnownPrimaryType.TimeSpan, String("duration") },
                { KnownPrimaryType.Object, Object() },
                { KnownPrimaryType.Uuid, String("uuid") },
                { KnownPrimaryType.DateTimeRfc1123, String("date-time-rfc1123") },
                { KnownPrimaryType.ByteArray, String("byte") },
                { KnownPrimaryType.Stream, new SchemaObject(type: "file") },
            };

        private static SchemaObject Integer(string format)
            => new SchemaObject(
                type: "integer",
                format: format);

        private static SchemaObject Number(string format)
            => new SchemaObject(
                type: "number",
                format: format);

        private static SchemaObject String(
            string format = null,
            IEnumerable<string> @enum = null)
            => new SchemaObject(
                type: "string",
                format: format, 
                @enum: @enum);

        private static SchemaObject Object(SchemaObject additionalProperties = null)
            => new SchemaObject(
                type: "object",
                additionalProperties: additionalProperties);

        public override IEnumerable<JsonBuilder.Property> GetProperties()
        {
            if (Ref != null)
            {
                yield return Json.Property("$ref", Ref);
            }
            if (Type != null)
            {
                yield return Json.Property("type", Type);
            }
            if (Format != null)
            {
                yield return Json.Property("format", Format);
            }
            if (Enum != null)
            {
                yield return Json.Property(
                    "enum",
                    Json.Array(Enum.Select(Json.String)));
            }
            if (Properties != null)
            {
                yield return Json.Property("properties", Json.Object(Properties));
            }

            if (AdditionalProperties != null)
            {
                yield return Json.Property("additionalProperties", AdditionalProperties);
            }
            else if (Properties != null)
            {
                yield return Json.Property("additionalProperties", false);
            }

            if (Items != null)
            {
                yield return Json.Property("items", Items);
            }
            if (Required != null)
            {
                yield return Json.Property(
                    "required",
                    Json.Array(Required.Select(Json.String)));
            }
        }

        private SchemaObject(
            string @ref = null,
            string type = null,
            string format = null,
            IEnumerable<string> @enum = null,
            IEnumerable<Property<SchemaObject>> properties = null,
            SchemaObject additionalProperties = null,
            SchemaObject items = null,
            IEnumerable<string> required = null)
        {
            Ref = @ref;
            Type = type;
            Format = format;
            Enum = @enum;
            Properties = properties;
            AdditionalProperties = additionalProperties;
            Items = items;
            Required = required;
        }
    }
}
