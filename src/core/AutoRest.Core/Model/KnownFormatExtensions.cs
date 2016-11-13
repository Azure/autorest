// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;

namespace AutoRest.Core.Model
{
    public static class KnownFormatExtensions
    {
        public static KnownFormat Parse(string formatValue)
        {
            if (string.IsNullOrWhiteSpace(formatValue))
            {
                return KnownFormat.none;
            }

            KnownFormat result;
            return Enum.TryParse(formatValue.Replace('-', '_'), true, out result) ? result : KnownFormat.unknown;
        }
    }
}