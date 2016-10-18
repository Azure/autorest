using System;
using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Logging;
using AutoRest.Core.Properties;
using AutoRest.Core.Validation;
using AutoRest.Swagger.Model;
using System.Text.RegularExpressions;

namespace AutoRest.Swagger.Validation
{
    public class NetworkInterfacesApiWarning : TypedRule<Dictionary<string, Dictionary<string, Operation>>>
    {
        private const string MicrosoftComputeApi = "Microsoft.Compute";
        private const string MicrosoftNetworkApi = "Microsoft.Network";
        /// <summary>
        /// This rule passes if the paths contain reference to either Microsoft.Network Apis or 
        /// Microsoft.Compute Apis but not both
        /// </summary>
        /// <param name="paths"></param>
        /// <returns></returns>
        public override bool IsValid(Dictionary<string, Dictionary<string, Operation>> paths)
        {
            Regex ApiRegExp = new Regex(@"(/.+)+/((?i)microsoft.compute|microsoft.network(?-i))/.+");
            var ApiQuery = paths.Keys.Where(Path => ApiRegExp.Match(Path).Success);
            if (!ApiQuery.Any())
                return true;
            
            Regex NetworkApiRegExp = new Regex(@"(/.+)+/((?i)microsoft.network(?-i))/.+");
            Regex ComputeApiRegExp = new Regex(@"(/.+)+/((?i)microsoft.compute(?-i))/.+");
            var NetworkApiQuery = ApiQuery.Where(Path => NetworkApiRegExp.Match(Path).Success);
            var ComputeApiQuery = ApiQuery.Where(Path => ComputeApiRegExp.Match(Path).Success);

            if (NetworkApiQuery.Any() && ComputeApiQuery.Any())
                return false;

            return true;
        }

        /// <summary>
        /// The template message for this Rule. 
        /// </summary>
        /// <remarks>
        /// This may contain placeholders '{0}' for parameterized messages.
        /// </remarks>
        public override string MessageTemplate => Resources.NetworkInterfacesApiWarningMessage;

        /// <summary>
        /// The severity of this message (ie, debug/info/warning/error/fatal, etc)
        /// </summary>
        public override LogEntrySeverity Severity => LogEntrySeverity.Warning;

    }
}
