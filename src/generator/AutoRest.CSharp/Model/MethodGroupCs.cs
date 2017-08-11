using System;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;
using System.Collections.Generic;

namespace AutoRest.CSharp.Model
{
    public partial class MethodGroupCs : Core.Model.MethodGroup
    {
        protected MethodGroupCs() : base()
        {
        }
        protected MethodGroupCs(string name) : base(name)
        {
        }

        public override Method Add(Method method)
        {
            (method as MethodCs).SyncMethods = Singleton<GeneratorSettingsCs>.Instance.SyncMethods;
            return base.Add(method);
        }

        /// <Summary>
        /// Accessor for <code>ExtensionTypeName</code>
        /// </Summary>
        public string ExtensionTypeName
        {
            get
            {
                if (IsCodeModelMethodGroup)
                {
                    return (CodeModel?.Name).Else(string.Empty);
                }

                return CodeNamer.Instance.GetTypeName(TypeName.Else(CodeModel?.Name.Else(NameForProperty.Else(String.Empty))));
            }
        }

        public override IEnumerable<string> Usings
        {
            get
            {
                if ((CodeModel as CodeModelCs).HaveModelNamespace)
                {
                    yield return CodeModel.ModelsName;
                }
            }
        }
    }
}
