using System;
using System.CodeDom;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoRest.Core;
using AutoRest.Core.Extensibility;
using AutoRest.Core.Utilities;
using Microsoft.CodeAnalysis;
using Microsoft.CSharp;
using Microsoft.Rest.CSharp.Compiler.Compilation;
using ScintillaNET;
using OutputKind = Microsoft.Rest.CSharp.Compiler.Compilation.OutputKind;
using static AutoRest.Core.Utilities.DependencyInjection;

namespace AutoRestPreview
{
    public partial class AutoRestPreviewForm : Form
    {
        private readonly string autoRestJson;

        public AutoRestPreviewForm()
        {
            InitializeComponent();

            autoRestJson = File.ReadAllText("AutoRest.json");
        }

        protected async Task<CompilationResult> Compile(IFileSystem fileSystem)
        {
            var compiler = new CSharpCompiler(
                fileSystem.GetFiles("GeneratedCode", "*.cs", SearchOption.AllDirectories)
                    .Select(each => new KeyValuePair<string, string>(each, fileSystem.ReadFileAsText(each))).ToArray(),
                ManagedAssets.FrameworkAssemblies.Concat(
                    AppDomain.CurrentDomain.GetAssemblies()
                        .Where(each => !each.IsDynamic && !string.IsNullOrEmpty(each.Location))
                        .Select(each => each.Location)
                        .Concat(new[]
                        {
                            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                                "Microsoft.Rest.ClientRuntime.dll"),
                            Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location),
                                "Microsoft.Rest.ClientRuntime.Azure.dll")
                        })
                ));

            return await compiler.Compile(OutputKind.DynamicallyLinkedLibrary);
        }

        private MemoryFileSystem GenerateCodeForTest(string json, string codeGenerator)
        {
            using (NewContext)
            {
                var fs = new MemoryFileSystem();
                var settings = new Settings
                {
                    Modeler = "Swagger",
                    CodeGenerator = codeGenerator,
                    FileSystem = fs,
                    OutputDirectory = "GeneratedCode",
                    Namespace = "Test",
                    Input = "input.json"
                };

                fs.WriteFile(settings.Input, json);
                fs.WriteFile("AutoRest.json", autoRestJson);

                return GenerateCodeInto(fs, settings);
            }
        }

        private static MemoryFileSystem GenerateCodeInto(MemoryFileSystem fileSystem, Settings settings)
        {
            var plugin = ExtensionsLoader.GetPlugin();
            var modeler = ExtensionsLoader.GetModeler();
            var codeModel = modeler.Build();

            // After swagger Parser
            codeModel = AutoRestController.RunExtensions(Trigger.AfterModelCreation, codeModel);

            // After swagger Parser
            codeModel = AutoRestController.RunExtensions(Trigger.BeforeLoadingLanguageSpecificModel, codeModel);

            using (plugin.Activate())
            {
                // load model into language-specific code model
                codeModel = plugin.Serializer.Load(codeModel);

                // we've loaded the model, run the extensions for after it's loaded
                codeModel = AutoRestController.RunExtensions(Trigger.AfterLoadingLanguageSpecificModel, codeModel);

                // apply language-specific tranformation (more than just language-specific types)
                // used to be called "NormalizeClientModel" . 
                codeModel = plugin.Transformer.TransformCodeModel(codeModel);

                // next set of extensions
                codeModel = AutoRestController.RunExtensions(Trigger.AfterLanguageSpecificTransform, codeModel);

                // next set of extensions
                codeModel = AutoRestController.RunExtensions(Trigger.BeforeGeneratingCode, codeModel);

                // Generate code from CodeModel.
                plugin.CodeGenerator.Generate(codeModel).GetAwaiter().GetResult();
            }

            return fileSystem;
        }

        internal static string[] SuppressWarnings = {"CS1701", "CS1591"};

        private async Task<string> Regenerate(string swagger, string language = "CSharp", bool shortVersion = true)
        {
            using (var fileSystem = GenerateCodeForTest(swagger, language))
            {
                // concat all source
                var allSources = string.Join("\n\n\n",
                    fileSystem
                        .VirtualStore
                        .Where(file => file.Key.Contains(".") && !file.Key.EndsWith(".json"))
                        .Select(file => $"//\n// {file.Key}\n//\n\n{file.Value.ToString()}"));

                if (!shortVersion)
                {
                    return allSources;
                }

                switch (language)
                {
                    case "CSharp":
                    case "Azure.CSharp":
                        // compile
                        var result = await Compile(fileSystem);

                        // filter the warnings
                        var warnings = result.Messages.Where(
                            each => each.Severity == DiagnosticSeverity.Warning
                                    && !SuppressWarnings.Contains(each.Id)).ToArray();

                        // filter the errors
                        var errors = result.Messages.Where(each => each.Severity == DiagnosticSeverity.Error).ToArray();
                        
                        if (!result.Succeeded)
                        {
                            throw new Exception("compilation failed: " + string.Join(", ", errors.Concat(warnings)));
                        }

                        // try to load the assembly
                        var asm = Assembly.Load(result.Output.GetBuffer());
                        if (asm == null)
                        {
                            throw new Exception("could not load assembly");
                        }

                        var types = asm.ExportedTypes;
                        return string.Join("\n\n", types.Select(CreateTypeSummary));
                        
                    default:
                        return allSources;
                }
            }
        }

        private string GetSimpleName(Type type)
        {
            var compiler = new CSharpCodeProvider();
            var result = compiler.GetTypeOutput(new CodeTypeReference(type));
            result = Regex.Replace(result, @"[_A-Za-z0-9]+\.", "");
            result = Regex.Replace(result, @"Nullable<(.+?)>", @"$1?");
            return result;
        }

        private string CreateTypeSummary(Type type)
        {
            int indentLevel = scintillaDst.TabWidth;

            var sb = new StringBuilder();
            sb.Append("class ");
            sb.Append(type.Name);
            sb.AppendLine();
            sb.AppendLine("{");
            foreach (var member in type.GetProperties())
            {
                sb.Append(' ', indentLevel);
                sb.Append(GetSimpleName(member.PropertyType));
                sb.Append(' ');
                sb.Append(member.Name);
                sb.AppendLine(";");
            }
            sb.AppendLine("}");

            return sb.ToString();
        }

        private void SetupCintilla(Scintilla scintilla)
        {
            scintilla.StyleResetDefault();
            scintilla.Styles[Style.Default].Font = "Consolas";
            scintilla.Styles[Style.Default].Size = 10;
            scintilla.StyleClearAll();

            // Configure the CPP (C#) lexer styles
            scintilla.Styles[Style.Cpp.Default].ForeColor = Color.Silver;
            scintilla.Styles[Style.Cpp.Comment].ForeColor = Color.FromArgb(0, 128, 0); // Green
            scintilla.Styles[Style.Cpp.CommentLine].ForeColor = Color.FromArgb(0, 128, 0); // Green
            scintilla.Styles[Style.Cpp.CommentLineDoc].ForeColor = Color.FromArgb(128, 128, 128); // Gray
            scintilla.Styles[Style.Cpp.Number].ForeColor = Color.Olive;
            scintilla.Styles[Style.Cpp.Word].ForeColor = Color.Blue;
            scintilla.Styles[Style.Cpp.Word2].ForeColor = Color.Blue;
            scintilla.Styles[Style.Cpp.String].ForeColor = Color.FromArgb(163, 21, 21); // Red
            scintilla.Styles[Style.Cpp.Character].ForeColor = Color.FromArgb(163, 21, 21); // Red
            scintilla.Styles[Style.Cpp.Verbatim].ForeColor = Color.FromArgb(163, 21, 21); // Red
            scintilla.Styles[Style.Cpp.StringEol].BackColor = Color.Pink;
            scintilla.Styles[Style.Cpp.Operator].ForeColor = Color.Purple;
            scintilla.Styles[Style.Cpp.Preprocessor].ForeColor = Color.Maroon;
            scintilla.Lexer = Lexer.Cpp;

            if (true)
            {
                BackColor = Color.FromArgb(0, 0, 0);
                scintilla.Styles[Style.Default].ForeColor = Color.Silver;
                scintilla.Styles[Style.Default].BackColor = Color.FromArgb(30, 30, 30);
                scintilla.CaretForeColor = Color.Silver;
                scintilla.SetSelectionBackColor(true, Color.FromArgb(50, 80, 140));

                scintilla.StyleClearAll();
                scintilla.Styles[Style.IndentGuide].BackColor = Color.FromArgb(50, 50, 50);
                scintilla.Styles[Style.IndentGuide].ForeColor = Color.FromArgb(50, 50, 50);

                // Configure the CPP (C#) lexer styles
                scintilla.Styles[Style.Cpp.Default].ForeColor = Color.Silver;
                scintilla.Styles[Style.Cpp.Comment].ForeColor = Color.FromArgb(0, 128, 0); // Green
                scintilla.Styles[Style.Cpp.CommentLine].ForeColor = Color.FromArgb(0, 128, 0); // Green
                scintilla.Styles[Style.Cpp.CommentLineDoc].ForeColor = Color.FromArgb(128, 128, 128); // Gray
                scintilla.Styles[Style.Cpp.Number].ForeColor = Color.Olive;
                scintilla.Styles[Style.Cpp.Word].ForeColor = Color.CornflowerBlue;
                scintilla.Styles[Style.Cpp.Word2].ForeColor = Color.CornflowerBlue;
                scintilla.Styles[Style.Cpp.String].ForeColor = Color.FromArgb(163, 21, 21); // Red
                scintilla.Styles[Style.Cpp.Character].ForeColor = Color.FromArgb(163, 21, 21); // Red
                scintilla.Styles[Style.Cpp.Verbatim].ForeColor = Color.FromArgb(163, 21, 21); // Red
                scintilla.Styles[Style.Cpp.StringEol].BackColor = Color.Pink;
                scintilla.Styles[Style.Cpp.Operator].ForeColor = Color.Purple;
                scintilla.Styles[Style.Cpp.Preprocessor].ForeColor = Color.Maroon;
                scintilla.Lexer = Lexer.Cpp;
            }

            //scintilla.Margins[1].Width = 0;
            scintilla.Margins[1].Type = MarginType.BackColor;
            //scintilla.Margins[0].Width = 16;
        }

        private async Task UpdatePreview()
        {
            try
            {
                string result = await Regenerate(scintillaSrc.Text, comboBoxTargetLang.SelectedItem as string ?? "CSharp", checkBoxShort.Checked);
                int scrollStart = scintillaDst.FirstVisibleLine;
                scintillaDst.ReadOnly = false;
                scintillaDst.Text = result;
                scintillaDst.ReadOnly = true;
                scintillaDst.LineScroll(scrollStart, 0);

                panelError.Visible = false;
            }
            catch (Exception ex)
            {
                labelError.Text = $@"{ex.GetType().Name}: {ex.Message}";
                panelError.Visible = true;
            }
        }

        private void AutoRestPreviewForm_Load(object sender, EventArgs ea)
        {
            SetupCintilla(scintillaSrc);
            SetupCintilla(scintillaDst);

            scintillaSrc.InsertCheck += (o, e) =>
            {
                if ((e.Text.EndsWith("\r") || e.Text.EndsWith("\n")))
                {
                    var curLine = scintillaSrc.LineFromPosition(e.Position);
                    var curLineText = scintillaSrc.Lines[curLine].Text;

                    var indent = Regex.Match(curLineText, @"^\s*");
                    e.Text += indent.Value;
                }
            };

            scintillaDst.SetKeywords(0,
                "abstract as base break case catch checked continue default delegate do else event explicit extern false finally fixed for foreach goto if implicit in interface internal is lock namespace new null object operator out override params partial private protected public readonly ref return sealed sizeof stackalloc switch this throw true try typeof unchecked unsafe using virtual while");
            scintillaDst.SetKeywords(1,
                "bool byte char class const decimal double enum float int long sbyte short static string struct uint ulong ushort void");
            scintillaSrc.SetKeywords(0, "false true");

            comboBoxTargetLang.SelectedItem = comboBoxTargetLang.Items[0];
        }

        private async void scintillaSrc_TextChanged(object sender, EventArgs e)
        {
            await UpdatePreview();
        }

        private async void comboBoxTargetLang_SelectedIndexChanged(object sender, EventArgs e)
        {
            await UpdatePreview();
        }

        private async void checkBoxShort_CheckedChanged(object sender, EventArgs e)
        {
            await UpdatePreview();
        }
    }
}