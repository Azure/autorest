using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;
using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using ScintillaNET;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Preview
{
    public partial class AutoRestPreviewForm : Form
    {
        public AutoRestPreviewForm()
        {
            InitializeComponent();
        }

        class Highlight
        {
            public int Start;
            public int End;
            public string Message;
        }
        List<Highlight> highlights = new List<Highlight>();

        private void ScintillaSrc_DwellStart(object sender, ScintillaNET.DwellEventArgs e)
        {
            var highlight = highlights.FirstOrDefault(h => h.Start <= e.Position && e.Position <= h.End);
            if (highlight != null)
            {
                scintillaSrc.CallTipShow(highlight.Start, highlight.Message);
            }
        }
        private void ScintillaSrc_DwellEnd(object sender, ScintillaNET.DwellEventArgs e)
        {
            scintillaSrc.CallTipCancel();
        }

        private readonly int INDICATOR_BASE = 8;
        private readonly Color[] INDIXATOR_COLORS = { Color.CornflowerBlue, Color.Green, Color.Yellow, Color.Red, Color.Red };

        private void ResetLinter()
        {
            highlights.Clear();

            var severityNames = Enum.GetNames(typeof(LogEntrySeverity));

            for (int i = 0; i < severityNames.Length; ++i)
            {
                int indicator = INDICATOR_BASE + i;

                // Remove all uses of our indicator
                scintillaSrc.IndicatorCurrent = indicator;
                scintillaSrc.IndicatorClearRange(0, scintillaSrc.TextLength);

                // Update indicator appearance
                scintillaSrc.Indicators[indicator].Style = IndicatorStyle.StraightBox;
                //scintillaSrc.Indicators[indicator].Style = IndicatorStyle.Squiggle;
                scintillaSrc.Indicators[indicator].Under = true;
                scintillaSrc.Indicators[indicator].ForeColor = INDIXATOR_COLORS[i];
                scintillaSrc.Indicators[indicator].OutlineAlpha = 80;
                scintillaSrc.Indicators[indicator].Alpha = 50;
            }
        }

        private void ProcessLinterMessages(string swagger, IEnumerable<ValidationMessage> messages)
        {
            // parse
            var reader = new StringReader(swagger);
            var yamlStream = new YamlStream();
            yamlStream.Load(reader);
            var doc = yamlStream.Documents[0].RootNode;

            // process messages
            foreach (var message in messages)
            {
                scintillaSrc.IndicatorCurrent = INDICATOR_BASE + (int)message.Severity;
                var node = doc.ResolvePath(message.Path.Reverse().Skip(1));
                scintillaSrc.IndicatorFillRange(node.Start.Index, node.End.Index - node.Start.Index);
                highlights.Add(new Highlight
                {
                    Start = node.Start.Index,
                    End = node.End.Index,
                    Message = $"{message.Severity}: {message.Message}"
                });
            }
        }

        private async Task<string> Regenerate(string swagger, string language = "CSharp", bool shortVersion = true)
        {
            ResetLinter();
            IEnumerable<ValidationMessage> messages;
            using (var fileSystem = AutoRestPipeline.GenerateCodeForTest(swagger, language, out messages))
            {
                ProcessLinterMessages(swagger, messages);

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
                        var types = await CSharpCompilerHelper.CompileTypes(fileSystem);
                        return string.Join("\n\n", types.Select(type => type.CreateSummary(scintillaDst.TabWidth)));

                    default:
                        return allSources;
                }
            }
        }

        private void SetupScintilla(Scintilla scintilla)
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
            SetupScintilla(scintillaSrc);
            SetupScintilla(scintillaDst);

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