﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace AutoRest.Core.Properties {
    using System;
    using System.Reflection;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    public class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("AutoRest.Core.Properties.Resources", typeof(Resources).GetTypeInfo().Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to AutoRest Core {0}.
        /// </summary>
        public static string AutoRestCore {
            get {
                return ResourceManager.GetString("AutoRestCore", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Plugins:
        ///  CSharp:
        ///    TypeName: PluginCs, AutoRest.CSharp
        ///  Azure.CSharp:
        ///    TypeName: PluginCsa, AutoRest.CSharp.Azure
        ///  Azure.CSharp.Fluent:
        ///    TypeName: PluginCsaf, AutoRest.CSharp.Azure.Fluent
        ///  Azure.JsonRpcClient:
        ///    TypeName: PluginCsa, AutoRest.CSharp.Azure.JsonRpcClient
        ///  Ruby:
        ///    TypeName: PluginRb, AutoRest.Ruby
        ///  Azure.Ruby:
        ///    TypeName: PluginRba, AutoRest.Ruby.Azure
        ///  NodeJS:
        ///    TypeName: PluginJs, AutoRest.NodeJS
        ///  Azure.NodeJS:
        ///    TypeName: PluginJsa, AutoRest.NodeJS. [rest of string was truncated]&quot;;.
        /// </summary>
        public static string ConfigurationKnownPlugins {
            get {
                return ResourceManager.GetString("ConfigurationKnownPlugins", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Error loading {0} assembly: {1}.
        /// </summary>
        public static string ErrorLoadingAssembly {
            get {
                return ResourceManager.GetString("ErrorLoadingAssembly", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Plugin {0} not found.
        /// </summary>
        public static string ExtensionNotFound {
            get {
                return ResourceManager.GetString("ExtensionNotFound", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Successfully initialized {0} Code Generator {1}.
        /// </summary>
        public static string GeneratorInitialized {
            get {
                return ResourceManager.GetString("GeneratorInitialized", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Initializing code generator..
        /// </summary>
        public static string InitializingCodeGenerator {
            get {
                return ResourceManager.GetString("InitializingCodeGenerator", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Property name {0} cannot be used as an Identifier, as it contains only invalid characters..
        /// </summary>
        public static string InvalidIdentifierName {
            get {
                return ResourceManager.GetString("InvalidIdentifierName", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; code generator does not support code generation to a single file..
        /// </summary>
        public static string LanguageDoesNotSupportSingleFileGeneration {
            get {
                return ResourceManager.GetString("LanguageDoesNotSupportSingleFileGeneration", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &apos;{0}&apos; is required..
        /// </summary>
        public static string ParameterValueIsMissing {
            get {
                return ResourceManager.GetString("ParameterValueIsMissing", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Parameter &apos;{0}&apos; value is not valid. Expect &apos;{1}&apos;.
        /// </summary>
        public static string ParameterValueIsNotValid {
            get {
                return ResourceManager.GetString("ParameterValueIsNotValid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to path cannot be null or an empty string or a string with white spaces while getting the parent directory.
        /// </summary>
        public static string PathCannotBeNullOrEmpty {
            get {
                return ResourceManager.GetString("PathCannotBeNullOrEmpty", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Type &apos;{0}&apos; name should be assembly qualified. For example &apos;ClassName, AssemblyName&apos;.
        /// </summary>
        public static string TypeShouldBeAssemblyQualified {
            get {
                return ResourceManager.GetString("TypeShouldBeAssemblyQualified", resourceCulture);
            }
        }
    }
}
