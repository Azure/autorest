// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Java.Model;

namespace AutoRest.Java.Azure.Model
{
    public class MethodGroupJva : MethodGroupJv
    {
        public const string ExternalExtension = "x-ms-external";

        public MethodGroupJva()
        {
        }
        public MethodGroupJva(string name) : base(name)
        {
        }
    }
}