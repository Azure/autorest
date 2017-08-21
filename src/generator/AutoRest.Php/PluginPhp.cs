using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Model;

namespace AutoRest.Php
{
    public sealed class PluginPhp : Plugin<
        IGeneratorSettings, 
        CodeModelTransformer<CodeModel>,
        CodeGeneratorPhp,
        CodeNamer,
        CodeModel>
    {
    }
}
