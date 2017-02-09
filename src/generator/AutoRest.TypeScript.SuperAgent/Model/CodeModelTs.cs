using System;
using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent.Model
{
    public class CodeModelTs : CodeModel
    {
        public string GeneratedBy => System.Security.Principal.WindowsIdentity.GetCurrent().Name;

        public string GeneratedAt => DateTime.Now.ToString();

        public string GeneratorVersion => "1.0.0"; // TODO: get this from the version text
    }
}
