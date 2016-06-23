// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

namespace Microsoft.Rest.Generator.ClientModel
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
            return System.Enum.TryParse(formatValue.Replace('-', '_'), true, out result) ? result : KnownFormat.unknown;
        }
    }
}
