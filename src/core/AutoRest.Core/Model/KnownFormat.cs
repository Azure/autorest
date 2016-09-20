// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Diagnostics.CodeAnalysis;

namespace AutoRest.Core.ClientModel
{
    [SuppressMessage("ReSharper", "InconsistentNaming")]
    public enum KnownFormat
    {
        none,
        unknown,

        @char,
        int32,
        int64,
        @float,
        @double,
        @byte,
        binary,
        date,
        date_time,
        password,
        date_time_rfc1123,
        duration,
        uuid,
        base64url,
        @decimal,
        unixtime
    }
}