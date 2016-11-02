// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using AutoRest.Core.Model;

namespace AutoRest.Ruby.Model
{
    public class DictionaryTypeRb : DictionaryType
    {
        public DictionaryTypeRb()
        {
            Name.OnGet += v => $"Hash";
        }
    }
}