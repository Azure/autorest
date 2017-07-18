using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;
using AutoRest.Core.Utilities;
using AutoRest.CSharp.Azure.Model;
using AutoRest.CSharp.Model;
using AutoRest.CSharp.Azure.Templates;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public sealed class PluginCsa : Azure.PluginCsa
    {
        public PluginCsa()
        {
            Context.Add(new Factory<AzureMethodTemplate, JsonRpcClient.Templates.AzureMethodTemplate>());
        }
    }
}
