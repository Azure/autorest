// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using AutoRest.Core.Model;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.LoadBalanced.Model
{
    public interface IExtendedModelType
    {
        bool IsValueType { get; }
    }

    public class PrimaryTypeCs : PrimaryType, IExtendedModelType
    {
        public PrimaryTypeCs(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v =>
            {
                return ImplementationName;
            };
        }

        protected PrimaryTypeCs() : base()
        {
            Name.OnGet += v =>
            {
                return ImplementationName;
            };
        }

        public virtual string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                    case KnownPrimaryType.ByteArray:
                        return "byte[]";

                    case KnownPrimaryType.Boolean:
                        return "bool";

                    case KnownPrimaryType.Date:
                        return "System.DateTime";
                    
                    case KnownPrimaryType.DateTime:
                        return Singleton<GeneratorSettingsCs>.Instance.UseDateTimeOffset ? "System.DateTimeOffset" : "System.DateTime";

                    case KnownPrimaryType.DateTimeRfc1123:
                        return "System.DateTime";

                    case KnownPrimaryType.Double:
                        return "double";

                    case KnownPrimaryType.Decimal:
                        return "decimal";

                    case KnownPrimaryType.Int:
                        return "int";

                    case KnownPrimaryType.Long:
                        return "long";

                    case KnownPrimaryType.Stream:
                        return "System.IO.Stream";

                    case KnownPrimaryType.String:
                        switch (KnownFormat)
                        {
                            case KnownFormat.@char:
                                return  "char";

                            default:
                                return "string";
                        }

                    case KnownPrimaryType.TimeSpan:
                        return "System.TimeSpan";

                    case KnownPrimaryType.Object:
                        return "object";

                    case KnownPrimaryType.Credentials:
                        return "Microsoft.Rest.ServiceClientCredentials";

                    case KnownPrimaryType.UnixTime:
                        return "System.DateTime";

                    case KnownPrimaryType.Uuid:
                        return "System.Guid";

                }
                throw new NotImplementedException($"Primary type {KnownPrimaryType} is not implemented in {GetType().Name}");
            }
        }

        public virtual bool IsValueType
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Boolean:
                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.Date:
                    case KnownPrimaryType.Decimal:
                    case KnownPrimaryType.Double:
                    case KnownPrimaryType.Int:
                    case KnownPrimaryType.Long:
                    case KnownPrimaryType.TimeSpan:
                    case KnownPrimaryType.DateTimeRfc1123:
                    case KnownPrimaryType.UnixTime:
                    case KnownPrimaryType.Uuid:
                        return true;

                    case KnownPrimaryType.String:
                        return KnownFormat == KnownFormat.@char;

                    default:
                        return false;
                }
            }
        }
    }
}