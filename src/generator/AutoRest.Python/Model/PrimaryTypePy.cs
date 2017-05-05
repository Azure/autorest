// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Diagnostics;
using AutoRest.Core.Model;

namespace AutoRest.Python.Model
{
    public class PrimaryTypePy : PrimaryType, IExtendedModelTypePy
    {
        public PrimaryTypePy(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v => ImplementationName;
        }

        protected PrimaryTypePy()
        {
            Name.OnGet += v => ImplementationName;
        }

        public string ReturnTypeDocumentation => TypeDocumentation;

        public string TypeDocumentation
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Stream:
                        return "Generator";
                    case KnownPrimaryType.Credentials:
                        return $":mod:`{GeneratorSettingsPy.Instance.CredentialObject}`";
                }
                return ImplementationName;
            }
        }

        public virtual string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                        return "bytes";
                    case KnownPrimaryType.ByteArray:
                        return "bytearray";

                    case KnownPrimaryType.Boolean:
                        return "bool";

                    case KnownPrimaryType.Date:
                        return "date";

                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.DateTimeRfc1123:
                    case KnownPrimaryType.UnixTime:
                        return "datetime";

                    case KnownPrimaryType.Double:
                        return "float";

                    case KnownPrimaryType.Decimal:
                        return "decimal.Decimal";

                    case KnownPrimaryType.Int:
                        return "int";

                    case KnownPrimaryType.Long:
                        return "long";

                    case KnownPrimaryType.Stream: // Revisit here
                        return "object";

                    case KnownPrimaryType.Uuid:
                    case KnownPrimaryType.String:
                        return "str";

                    case KnownPrimaryType.TimeSpan:
                        return "timedelta";

                    case KnownPrimaryType.Object:
                        return "object";
                }
                throw new NotImplementedException($"Primary type {KnownPrimaryType} is not implemented in {GetType().Name}");
            }
        }
    }
}