using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRest.Python.Azure
{
    public class GeneratorSettingsPya : GeneratorSettingsPy
    {
        /// <summary>
        ///     Gets the name of code generator.
        /// </summary>
        public override string Name => "Azure.Python";

        /// <summary>
        ///     Gets the description of code generator.
        /// </summary>
        public override string Description => "Azure specific Python code generator.";

        public override string CredentialObject
            => "A msrestazure Credentials object<msrestazure.azure_active_directory>";
    }
}