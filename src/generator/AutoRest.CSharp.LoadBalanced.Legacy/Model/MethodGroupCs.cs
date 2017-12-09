using System;
using System.Collections.Generic;
using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    public partial class MethodGroupCs : Core.Model.MethodGroup
    {
        protected MethodGroupCs() : base()
        {
            InitProperties();
        }
        protected MethodGroupCs(string name) : base(name)
        {
            InitProperties();
        }

        public override Method Add(Method method)
        {
            (method as MethodCs).SyncMethods = Singleton<GeneratorSettingsCs>.Instance.SyncMethods;
            return base.Add(method);
        }
        private void InitProperties()
        {
            ExtensionTypeName.OnGet += value =>
            {
                if (IsCodeModelMethodGroup)
                {
                    return (CodeModel?.Name).Else(string.Empty);
                }
                
                return
                    CodeNamer.Instance.GetTypeName(
                        value.Else(TypeName.Else(CodeModel?.Name.Else(NameForProperty.Else(String.Empty)))));
            };
        }

        

        /// <Summary>
        /// Backing field for <code>ExtensionTypeName</code> property. 
        /// </Summary>
        /// <remarks>This field should be marked as 'readonly' as write access to it's value is controlled thru Fixable[T].</remarks>
        private readonly Fixable<string> _extensionTypeName = new Fixable<string>();

        /// <Summary>
        /// Accessor for <code>ExtensionTypeName</code>
        /// </Summary>
        /// <remarks>
        /// The Get and Set operations for this accessor may be overridden by using the 
        /// <code>ExtensionTypeName.OnGet</code> and <code>ExtensionTypeName.OnSet</code> events in this class' constructor.
        /// (ie <code> ExtensionTypeName.OnGet += extensionTypeName => extensionTypeName.ToUpper();</code> )
        /// </remarks>
        public Fixable<string> ExtensionTypeName
        {
            get { return _extensionTypeName; }
            set { _extensionTypeName.CopyFrom(value); }
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
