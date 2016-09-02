// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.ClientModel;
using AutoRest.Core.Validation;
using System.Collections.Generic;

namespace AutoRest.Core
{
    public abstract class Modeler
    {
        public abstract string Name { get; }

        public Settings Settings { get; private set; }

        protected Modeler(Settings settings)
        {
            Settings = settings;
        }

        public abstract ServiceClient Build();

        public abstract ServiceClient Build(out IEnumerable<ValidationMessage> messages);

        /// <summary>
        /// Copares two versions of the same service specification.
        /// </summary>
        /// <returns></returns>
        public abstract IEnumerable<ComparisonMessage> Compare();
    }
}
