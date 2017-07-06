using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python.Azure
{
    public class GeneratorSettingsPya : GeneratorSettingsPy
    {
        public override string CredentialObject
            => "A msrestazure Credentials object<msrestazure.azure_active_directory>";
    }
}