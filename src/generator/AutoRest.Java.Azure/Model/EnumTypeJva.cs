// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Java.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Azure.Model
{
    public class EnumTypeJva : EnumTypeJv
    {
        [JsonIgnore]
        public override string ModelsPackage => ".models";
    }
}