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
    /// https://swagger.io/specification/#schemaObject
    /// </summary>
    public class Schema : JsonBuilder.Object
    {
        public string Ref { get; }

        public string Type { get; }

        public string Format { get; }

        public bool Enum { get; }

        public IEnumerable<KeyValuePair<string, Schema>> Properties { get; }

        public Schema AdditionalProperties { get; }

        public Schema Items { get; }

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
                default:
                    throw new Exception("unknown type: " + Type);
            }
        }

        public static Schema CreateDefinition(CompositeType type)
            => new Schema(properties: type
                .Properties
                .Select(p => Extensions.KeyValue(
                    p.SerializedName.FixedValue,
                    Create(p.ModelType))));

        public static Schema Create(IModelType type)
        {
            if (type == null)
            {
                return null;
            }
            switch (type)
            {
                case CompositeType compositeType:
                    return new Schema(@ref: "#/definitions/" + compositeType.SerializedName);
                case EnumType enumType:
                    return String(@enum: true);
                case PrimaryType primaryType:
                    return Primary(primaryType);
                case DictionaryType dictionaryType:
                    return Object(additionalProperties: Create(dictionaryType.ValueType));
                case SequenceType sequenceType:
                    return new Schema(
                        type: "array",
                        items: Create(sequenceType.ElementType));
                default:
                    throw new System.Exception("unknown type: " + type.Name);
            }
        }

        private static Schema Primary(PrimaryType type)
            => PrimaryTypes[type.KnownPrimaryType];

        private static IReadOnlyDictionary<KnownPrimaryType, Schema> PrimaryTypes { get; }
            = new Dictionary<KnownPrimaryType, Schema>
            {
                { KnownPrimaryType.Int, Integer("int32") },
                { KnownPrimaryType.Long, Integer("int64") },
                { KnownPrimaryType.Double, Number("double") },
                { KnownPrimaryType.Decimal, Number("decimal") },
                { KnownPrimaryType.String, String() },
                { KnownPrimaryType.Boolean, new Schema(type: "boolean") },
                { KnownPrimaryType.Date, String("date") },
                { KnownPrimaryType.DateTime, String("date-time") },
                { KnownPrimaryType.TimeSpan, String("duration") },
                { KnownPrimaryType.Object, Object() },
                { KnownPrimaryType.Uuid, String("uuid") },
                { KnownPrimaryType.DateTimeRfc1123, String("date-time-rfc1123") },
                { KnownPrimaryType.ByteArray, String("byte") }
            };

        private static Schema Integer(string format)
            => new Schema(
                type: "integer",
                format: format);

        private static Schema Number(string format)
            => new Schema(
                type: "number",
                format: format);

        private static Schema String(string format = null, bool @enum = false)
            => new Schema(
                type: "string",
                format: format, 
                @enum: @enum);

        private static Schema Object(Schema additionalProperties = null)
            => new Schema(
                type: "object",
                additionalProperties: additionalProperties);

        public override IEnumerable<KeyValuePair<string, Token>> GetProperties()
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
            if (Enum)
            {
                yield return Json.Property("enum", Json.Array<JsonBuilder.String>());
            }
            if (Properties != null)
            {
                yield return Json.Property("properties", Json.Object(Properties));
            }
            if (AdditionalProperties != null)
            {
                yield return Json.Property("additionalProperties", AdditionalProperties);
            }
            if (Items != null)
            {
                yield return Json.Property("items", Items);
            }
        }

        private Schema(
            string @ref = null,
            string type = null,
            string format = null,
            bool @enum =  false,
            IEnumerable<KeyValuePair<string, Schema>> properties = null,
            Schema additionalProperties = null,
            Schema items = null)
        {
            Ref = @ref;
            Type = type;
            Format = format;
            Enum = @enum;
            Properties = properties;
            AdditionalProperties = additionalProperties;
            Items = items;
        }
    }
}
