// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

namespace AutoRest.Core.Model.XmsExtensions
{
    public static class ParameterLocation
    {
        public enum Location
        {
            Client,
            Method
        }

        public const string Name = "x-ms-parameter-location";
    }

    public static class Enum
    {
        public const string Name = "x-ms-enum";
    }
}