using System;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class HeaderModel
    {
        public string GeneratedBy => System.Security.Principal.WindowsIdentity.GetCurrent().Name;

        public string GeneratedAt => DateTime.Now.ToString();

        public string GeneratorVersion => "1.0.0";
        public string ApiVersion { get; set; }

// TODO: get this from the version text
    }
}
