using System;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using ScintillaNET;

namespace AutoRest.Preview
{
    public partial class AutoRestPreviewForm : Form
    {
        private SynchronizationContext ui;
        private Linting linting;

        public AutoRestPreviewForm()
        {
            InitializeComponent();
            ui = SynchronizationContext.Current;
            linting = new Linting(scintillaSrc);
        }

        private async Task<string> RegenerateAsync(string swagger, string language, bool shortVersion)
        {
            using (var fileSystem = AutoRestPipeline.GenerateCodeForTest(
                                            swagger, 
                                            language, 
                                            messages => ui.Post(_ => linting.ProcessMessages(swagger, messages), null)))
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
                this.progressBar.BackColor = BackColor;
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

        private bool regenerate = false;
        private bool regenerating = false;

        private void UpdatePreview()
        {
            linting.Reset();

            // immediate feedback
            panelError.Visible = false;
            panelProgress.Visible = true;

            regenerate = true;
        }

        public async void regenerateTimer_Tick(object sender, EventArgs e)
        {
            while (regenerate && !regenerating)
            {
                regenerate = false;
                regenerating = true;

                // start
                panelError.Visible = false;
                panelProgress.Visible = true;
                try
                {
                    var swaggerText = scintillaSrc.Text;
                    var generator = comboBoxTargetLang.SelectedItem as string ?? "CSharp";
                    var shortOutput = checkBoxShort.Checked;

                    string result = await Task.Run(() => RegenerateAsync(swaggerText, generator, shortOutput));

                    int scrollStart = scintillaDst.FirstVisibleLine;
                    scintillaDst.ReadOnly = false;
                    scintillaDst.Text = result;
                    scintillaDst.ReadOnly = true;
                    scintillaDst.LineScroll(scrollStart, 0);
                }
                catch (Exception ex)
                {
                    labelError.Text = $@"{ex.GetType().Name}: {ex.Message}";
                    panelError.Visible = true;
                }
                panelProgress.Visible = false;
                // end

                regenerating = false;
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

        private void scintillaSrc_TextChanged(object sender, EventArgs e)
            => UpdatePreview();

        private void comboBoxTargetLang_SelectedIndexChanged(object sender, EventArgs e)
            => UpdatePreview();

        private void checkBoxShort_CheckedChanged(object sender, EventArgs e)
            => UpdatePreview();
    }
}