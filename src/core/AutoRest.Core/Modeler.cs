// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;

namespace AutoRest.Core
{
    public abstract class Modeler
    {
        public abstract string Name { get; }

        public Settings Settings => Settings.Instance;

        public abstract CodeModel Build();
    }
}
