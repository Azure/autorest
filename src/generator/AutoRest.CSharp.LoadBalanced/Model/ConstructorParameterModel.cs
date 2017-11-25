using System;
using System.Collections.Generic;
using AutoRest.Core;
using AutoRest.Core.Model;

namespace AutoRest.CSharp.LoadBalanced.Model
{
    internal class ConstructorParameterModel
    {
        public ConstructorParameterModel(Property underlyingProperty)
        {
            UnderlyingProperty = underlyingProperty;
        }

        public Property UnderlyingProperty { get; private set; }

        public string Name => CodeNamer.Instance.CamelCase(UnderlyingProperty.Name);
    }
}
