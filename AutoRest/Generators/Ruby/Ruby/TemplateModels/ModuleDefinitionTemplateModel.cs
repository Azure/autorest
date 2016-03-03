// Copyright (c) Microsoft Open Technologies, Inc. All rights reserved.
// Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
using System.Text;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Linq;
using System;

namespace Microsoft.Rest.Generator.Ruby
{
    /// <summary>
    /// The model for the service client template.
    /// </summary>
    public class ModuleDefinitionTemplateModel
    {
        /// <summary>
        /// the namespace in the following format 'Azure::ARM::Foo::Bar'
        /// </summary>
        protected string ns;
        
        /// <summary>
        /// Initializes a new instance of ModuleDefinitionTemplateModel class.
        /// </summary>
        /// <param name="ns">namespace of the module</param>
        public ModuleDefinitionTemplateModel(string ns)
        {
            this.ns = ns;
        }

        /// <summary>
        /// Get the module declarations for the entire depth of modules generated.
        /// </summary>
        public string ModuleDeclarations { 
            get 
            { 
                var modules = Regex.Split(this.ns, "::");
                var sb = new StringBuilder(modules.Length);
                for(int i = 0; i < modules.Length; i++ ){
                    var joined = string.Join("::", modules.Take(i + 1));
                    sb.Append(string.Format("module {0} end{1}", joined, Environment.NewLine));
                }
                return sb.ToString(); 
            }
        }
    }
}