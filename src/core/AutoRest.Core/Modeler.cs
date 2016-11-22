// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Model;
using AutoRest.Core.Validation;
using System.Collections.Generic;
using AutoRest.Core.Extensibility;

namespace AutoRest.Core
{
    public abstract class Modeler : Transformer<object, CodeModel> // TODO: no more Modeler base class
    {
        public abstract string Name { get; }

        public Settings Settings => Settings.Instance;

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public abstract IEnumerable<ComparisonMessage> Compare();

        public abstract CodeModel Build(); // TODO: this is only for compatibility
    }
}
