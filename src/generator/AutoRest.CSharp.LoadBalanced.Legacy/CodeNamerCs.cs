// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities.Collections;

namespace AutoRest.CSharp.LoadBalanced.Legacy
{
    public class CodeNamerCs : CodeNamer
    {
        /// <summary>
        ///     Initializes a new instance of CSharpCodeNamingFramework.
        /// </summary>
        public CodeNamerCs()
        {
            ReservedWords.AddRange(
                new[]
                {
                    "abstract", "as", "async", "await", "base",
                    "bool", "break", "byte", "case", "catch",
                    "char", "checked", "class", "const", "continue",
                    "decimal", "default", "delegate", "do", "double",
                    "dynamic", "else", "enum", "event", "explicit",
                    "extern", "false", "finally", "fixed", "float",
                    "for", "foreach", "from", "global", "goto",
                    "if", "implicit", "in", "int", "interface",
                    "internal", "is", "lock", "long", "namespace",
                    "new", "null", "object", "operator", "out",
                    "override", "params", "private", "protected", "public",
                    "readonly", "ref", "return", "sbyte", "sealed",
                    "short", "sizeof", "stackalloc", "static", "string",
                    "struct", "switch", "this", "throw", "true",
                    "try", "typeof", "uint", "ulong", "unchecked",
                    "unsafe", "ushort", "using", "virtual", "void",
                    "volatile", "while", "yield", "var"
                });
        }

        /// <summary>
        /// Returns true when the name comparison is a special case and should not 
        /// be used to determine name conflicts.
        ///  </summary>
        /// <param name="whoIsAsking">the identifier that is checking to see if there is a conflict</param>
        /// <param name="reservedName">the identifier that would normally be reserved.</param>
        /// <returns></returns>
        public override bool IsSpecialCase(IIdentifier whoIsAsking, IIdentifier reservedName)
        {
            if (whoIsAsking is Property && reservedName is CompositeType)
            {
                var parent = (whoIsAsking as IChild)?.Parent as IIdentifier;
                if (ReferenceEquals(parent, reservedName))
                {
                    return false;
                }
                // special case: properties can have the same name as a compositetype
                // unless it is the same name as a parent.
                return true;
            }
            return false;
        }

        public override string EscapeDefaultValue(string defaultValue, IModelType type)
        {
            if (type == null)
            {
                throw new ArgumentNullException("type");
            }

            var primaryType = type as PrimaryType;
            if (defaultValue != null)
            {
                if (type is CompositeType)
                {
                    return "new " + type.Name + "()";
                }
                if (type is EnumType && (type as EnumType).ModelAsString)
                {
                    return Instance.QuoteValue(defaultValue);
                }
                if (primaryType != null)
                {
                    if (primaryType.KnownPrimaryType == KnownPrimaryType.String)
                    {
                        return Instance.QuoteValue(defaultValue);
                    }
                    if (primaryType.KnownPrimaryType == KnownPrimaryType.Boolean)
                    {
                        return defaultValue.ToLowerInvariant();
                    }
                    if ((primaryType.KnownPrimaryType == KnownPrimaryType.Date) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.DateTime) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.DateTimeRfc1123) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.TimeSpan) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.ByteArray) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.Base64Url) ||
                        (primaryType.KnownPrimaryType == KnownPrimaryType.UnixTime))
                    {
                        return
                            $"Microsoft.Rest.Serialization.SafeJsonConvert.DeserializeObject<{primaryType.Name}>"+
                            $"({Instance.QuoteValue($"\"{defaultValue}\"")}, this.Client.SerializationSettings)";
                    }
                }
            }
            return defaultValue;
        }
    }
}
