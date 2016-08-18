// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.ClientModel;

namespace AutoRest.Go
{
    /// <summary>
    /// Defines a synthesized composite type that wraps a primary type, array, or dictionary method response.
    /// </summary>
    public class SyntheticType : CompositeType
    {
        public SyntheticType(IType baseType)
        {
            if (!ShouldBeSyntheticType(baseType))
            {
                throw new ArgumentException("{0} is not a valid type for SyntheticType", baseType.ToString());
            }

            // gosdk: Ensure the generated name does not collide with existing type names
            BaseType = baseType;

            IType elementType = getElementType(baseType);

            if (elementType is PrimaryType)
            {
                var type = (elementType as PrimaryType).Type;
                if (type == KnownPrimaryType.Boolean)
                {
                    Name += "Bool";
                }
                else if (type == KnownPrimaryType.ByteArray)
                {
                    Name += "ByteArray";
                }
                else if (type == KnownPrimaryType.Double)
                {
                    Name += "Float64";
                }
                else if (type == KnownPrimaryType.Int)
                {
                    Name += "Int32";
                }
                else if (type == KnownPrimaryType.Long)
                {
                    Name += "Int64";
                }
                else if (type == KnownPrimaryType.Stream)
                {
                    Name += "ReadCloser";
                }
                else if (type == KnownPrimaryType.String)
                {
                    Name += "String";
                }
                else if (type == KnownPrimaryType.TimeSpan)
                {
                    Name += "TimeSpan";
                }
                else if (type == KnownPrimaryType.Base64Url)
                {
                    Name += "Base64Url";
                }
                else if (type == KnownPrimaryType.UnixTime)
                {
                    Name += "UnixTime";
                }
            }
            else if (elementType is InterfaceType)
            {
                Name += "Object";
            }
            else if (elementType is PackageType)
            {
                Name += (elementType as PackageType).Member;
            }
            else if (elementType is EnumType)
            {
                Name += "String";
            }
            else
            {
                Name += elementType.Name;
            }

            Property p = new Property();
            p.SerializedName = "value";
            p.Name = "Value";
            p.Type = baseType;
            Properties.Add(p);
        }

        public IType BaseType { get; set; }
        
        public static bool ShouldBeSyntheticType(IType type)
        {
            return (type is PrimaryType || type is PackageType || type is SequenceType || type is DictionaryType || type is EnumType);
        }

        public static bool IsAllowedPrimitiveType(IType type)
        {
            return !(type is DictionaryType || type is SequenceType || type.IsPrimaryType(KnownPrimaryType.Stream));
        }

        public IType getElementType(IType type)
        {
            if (type is SequenceType)
            {
                Name += "List";
                return getElementType((type as SequenceType).ElementType);
            }
            else if (type is MapType)
            {
                Name += "Set";
                return getElementType(((type as MapType).ValueType));
            }
            else
            {
                return type;
            }
        }
    }
}
