// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using AutoRest.Core.Model;

namespace AutoRest.Ruby.Model
{
    public class PrimaryTypeRb : PrimaryType
    {
        public PrimaryTypeRb(KnownPrimaryType primaryType) : base(primaryType)
        {
            Name.OnGet += v => ImplementationName;
        }

        protected PrimaryTypeRb()
        {
            Name.OnGet += v => ImplementationName;
        }


        public virtual string ImplementationName
        {
            get
            {
                switch (KnownPrimaryType)
                {
                    case KnownPrimaryType.Base64Url:
                        return "String";
                    case KnownPrimaryType.ByteArray:
                        return "Array";

                    case KnownPrimaryType.Boolean:
                        return "Boolean";

                    case KnownPrimaryType.Date:
                        return "Date";

                    case KnownPrimaryType.DateTime:
                    case KnownPrimaryType.DateTimeRfc1123:
                    case KnownPrimaryType.UnixTime:
                        return "DateTime";

                    case KnownPrimaryType.Double:
                    case KnownPrimaryType.Decimal:
                        return "Float";

                    case KnownPrimaryType.Int:
                        return "Number";

                    case KnownPrimaryType.Long:
                        return "Bignum";

                    case KnownPrimaryType.Stream:
                        // TODO: Ruby doesn't supports streams.
                        return "NOT_IMPLEMENTED";

                    case KnownPrimaryType.String:
                        return "String";

                    case KnownPrimaryType.TimeSpan:
                        return "Duration";

                    case KnownPrimaryType.Object:
                        return "Object";

                    case KnownPrimaryType.Credentials:
                        // TODO: Ruby doesn't supports Credentials.
                        return "NOT_IMPLEMENTED";

                    case KnownPrimaryType.Uuid:
                        return "Uuid";
                }
                throw new NotImplementedException($"Primary type {KnownPrimaryType} is not implemented in {GetType().Name}");
            }
        }
    }
}

