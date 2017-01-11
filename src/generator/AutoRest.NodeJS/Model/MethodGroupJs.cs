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
            InitializeProperties();
        }

        protected MethodGroupJs(string name): base(name)
        {
            InitializeProperties();
        }

        protected void InitializeProperties()
        {
            NameForProperty.OnGet += value => CodeNamer.Instance.GetPropertyName(TypeName);
        }
        [JsonIgnore]
        public IEnumerable<MethodJs> MethodTemplateModels => Methods.Cast<MethodJs>();

        [JsonIgnore]
        public bool ContainsTimeSpan
        {
            get
            {
                Method method = this.MethodTemplateModels.FirstOrDefault(m => m.Parameters.FirstOrDefault(p =>
                    p.ModelType.IsPrimaryType(KnownPrimaryType.TimeSpan) ||
                    (p.ModelType is Core.Model.SequenceType && (p.ModelType as Core.Model.SequenceType).ElementType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                    (p.ModelType is Core.Model.DictionaryType && (p.ModelType as Core.Model.DictionaryType).ValueType.IsPrimaryType(KnownPrimaryType.TimeSpan)) ||
                    (p.ModelType is CompositeType && (p.ModelType as CompositeType).ContainsTimeSpan())) != null);
                
                return  method != null;
            }
        }

        [JsonIgnore]
        public bool ContainsStream
        {
            get {
                return this.Methods.Any(m => m.Parameters.FirstOrDefault(p => p.ModelType.IsPrimaryType(KnownPrimaryType.Stream)) != null ||
                        m.ReturnType.Body.IsPrimaryType(KnownPrimaryType.Stream)); }
        }
    }
}