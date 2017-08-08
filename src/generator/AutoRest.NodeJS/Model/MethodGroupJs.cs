// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using System.Linq;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using Newtonsoft.Json;

namespace AutoRest.NodeJS.Model
{
    public class MethodGroupJs : MethodGroup
    {
        protected MethodGroupJs() : base()
        {
        }

        protected MethodGroupJs(string name): base(name)
        {
        }

        public override string NameForProperty => CodeNamer.Instance.GetPropertyName(TypeName);

        [JsonIgnore]
        public IEnumerable<MethodJs> MethodTemplateModels => Methods.Cast<MethodJs>();

        [JsonIgnore]
        public bool ContainsTimeSpan
            => MethodTemplateModels.Any(m => m.Parameters.FirstOrDefault(p =>
                    p.ModelType.IsPrimaryType(KnownPrimaryType.TimeSpan) ||
                    ((p.ModelType as SequenceType)?.ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan) ?? false) ||
                    ((p.ModelType as DictionaryType)?.ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan) ?? false) ||
                    ((p.ModelType as CompositeType)?.ContainsTimeSpan() ?? false)) != null);

        [JsonIgnore]
        public bool ContainsStream =>
            this.Methods.Any(m => m.Parameters.FirstOrDefault(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Stream)) != null ||
                        m.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream));
    }
}