using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Types;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.SwaggerBuilder
{
    /// <summary>
    /// https://swagger.io/specification/#schemaObject
    /// </summary>
    public sealed class Schema
    {
        public string Ref { get; }

        public string Type { get; }

        public string Format { get; }

        public bool Enum { get; }

        public IEnumerable<KeyValuePair<string, Schema>> Properties { get; }

        public Schema AdditionalProperties { get; }

        public Schema Items { get; }

        public PhpBuilder.Expressions.Array ToPhp()
            => PHP.CreateArray(ToPhpItems());

        private IEnumerable<ArrayItem> ToPhpItems()
        {
            if (Ref != null)
            {
                yield return PHP.KeyValue("$ref", Ref);
            }
            if (Type != null)
            {
                yield return PHP.KeyValue("type", Type);
            }
            if (Format != null)
            {
                yield return PHP.KeyValue("format", Format);
            }
            if (Enum)
            {
                yield return PHP.KeyValue("enum", PHP.EmptyArray);
            }
            if (Properties != null)
            {
                yield return PHP.KeyValue("properties", Properties.ToPhp());
            }
            if (AdditionalProperties != null)
            {
                yield return PHP.KeyValue("additionalProperties", AdditionalProperties.ToPhp());
            }
            if (Items != null)
            {
                yield return PHP.KeyValue("items", Items.ToPhp());
            }
        }

        public IType ToPhpType()
        {
            if (Ref != null)
            {
                return PHP.Array;
            }
            switch (Type)
            {
                case "string":
                    return PHP.String;
                case "integer":
                    return PHP.Integer;
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
