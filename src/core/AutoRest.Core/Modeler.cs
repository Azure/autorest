// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Validation;
using System.Collections.Generic;

namespace AutoRest.Core
{
    public abstract class Modeler
    {
        public abstract string Name { get; }

        public Settings Settings => Settings.Instance;

        public abstract CodeModel Build();

        public abstract CodeModel Build(out IEnumerable<ValidationMessage> messages);

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public abstract IEnumerable<ComparisonMessage> Compare();
    }
}
