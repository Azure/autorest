// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.


namespace AutoRest.Core.ClientModel
{
    /// <summary>
    /// Known primary model types.
    /// </summary>
    public enum KnownPrimaryType
    {
        None = 0,
        Object,
        Int,
        Long,
        Double,
        Decimal,
        String,
        Stream,
        ByteArray,
        Date,
        DateTime,
        DateTimeRfc1123,
        TimeSpan,
        Boolean,
        Credentials,
        Uuid,
        Base64Url,
        UnixTime
    }
}
