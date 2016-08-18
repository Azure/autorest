// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;
using System.Collections.Generic;
using System.Globalization;

using AutoRest.Core.ClientModel;

namespace AutoRest.Go
{
    /// <summary>
    /// Defines a pseudo-PrimaryType to support Go interface types.
    /// </summary>
    public class InterfaceType : IType
    {
        public string Name
        {
            get { return "interface{}"; }
        }

        public override string ToString()
        {
            return Name;
        }

        public override bool Equals(object obj)
        {
            var knownType = obj as InterfaceType;

            if (knownType != null)
            {
                return knownType.Name == Name;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return Name.GetHashCode();
        }
    }
}
