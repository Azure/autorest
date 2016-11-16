using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;

namespace AutoRest.Preview
{
    partial class AutoRestPreviewForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AutoRestPreviewForm));
            this.tableLayoutPanel = new System.Windows.Forms.TableLayoutPanel();
            this.panelDst = new System.Windows.Forms.Panel();
            this.scintillaDst = new ScintillaNET.Scintilla();
            this.panel1 = new System.Windows.Forms.Panel();
            this.labelTargetLang = new System.Windows.Forms.Label();
            this.comboBoxTargetLang = new System.Windows.Forms.ComboBox();
            this.panelError = new System.Windows.Forms.Panel();
            this.panelProgress = new System.Windows.Forms.Panel();
            this.labelError = new System.Windows.Forms.Label();
            this.panelSrc = new System.Windows.Forms.Panel();
            this.scintillaSrc = new ScintillaNET.Scintilla();
            this.checkBoxShort = new System.Windows.Forms.CheckBox();
            this.regenerateTimer = new System.Windows.Forms.Timer();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.tableLayoutPanel.SuspendLayout();
            this.panelDst.SuspendLayout();
            this.panel1.SuspendLayout();
            this.panelError.SuspendLayout();
            this.panelSrc.SuspendLayout();
            this.SuspendLayout();
            // 
            // tableLayoutPanel
            // 
            this.tableLayoutPanel.ColumnCount = 2;
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50F));
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel.Controls.Add(this.panelDst, 1, 0);
            this.tableLayoutPanel.Controls.Add(this.panelSrc, 0, 0);
            this.tableLayoutPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel.Name = "tableLayoutPanel";
            this.tableLayoutPanel.Padding = new System.Windows.Forms.Padding(4);
            this.tableLayoutPanel.RowCount = 1;
            this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel.Size = new System.Drawing.Size(1011, 738);
            this.tableLayoutPanel.TabIndex = 3;
            // 
            // panelDst
            // 
            this.panelDst.Controls.Add(this.scintillaDst);
            this.panelDst.Controls.Add(this.panel1);
            this.panelDst.Controls.Add(this.panelError);
            this.panelDst.Controls.Add(this.panelProgress);
            this.panelDst.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelDst.Location = new System.Drawing.Point(508, 7);
            this.panelDst.Name = "panelDst";
            this.panelDst.Size = new System.Drawing.Size(496, 724);
            this.panelDst.TabIndex = 4;
            // 
            // scintillaDst
            // 
            this.scintillaDst.AdditionalSelectionTyping = true;
            this.scintillaDst.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.scintillaDst.Dock = System.Windows.Forms.DockStyle.Fill;
            this.scintillaDst.IndentationGuides = ScintillaNET.IndentView.Real;
            this.scintillaDst.Location = new System.Drawing.Point(0, 36);
            this.scintillaDst.MouseSelectionRectangularSwitch = true;
            this.scintillaDst.MultipleSelection = true;
            this.scintillaDst.Name = "scintillaDst";
            this.scintillaDst.ScrollWidth = 160;
            this.scintillaDst.Size = new System.Drawing.Size(496, 550);
            this.scintillaDst.TabIndex = 6;
            this.scintillaDst.WrapIndentMode = ScintillaNET.WrapIndentMode.Indent;
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.Transparent;
            this.panel1.Controls.Add(this.checkBoxShort);
            this.panel1.Controls.Add(this.labelTargetLang);
            this.panel1.Controls.Add(this.comboBoxTargetLang);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(496, 36);
            this.panel1.TabIndex = 8;
            // 
            // labelTargetLang
            // 
            this.labelTargetLang.ForeColor = System.Drawing.Color.Silver;
            this.labelTargetLang.Location = new System.Drawing.Point(3, 2);
            this.labelTargetLang.Name = "labelTargetLang";
            this.labelTargetLang.Padding = new System.Windows.Forms.Padding(8);
            this.labelTargetLang.Size = new System.Drawing.Size(108, 31);
            this.labelTargetLang.TabIndex = 2;
            this.labelTargetLang.Text = "Target Language";
            this.labelTargetLang.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // comboBoxTargetLang
            // 
            this.comboBoxTargetLang.FormattingEnabled = true;
            this.comboBoxTargetLang.Items.AddRange(new object[] {
            "CSharp",
            "Azure.CSharp",
            "Ruby",
            "Azure.Ruby",
            "NodeJS",
            "Azure.NodeJS",
            "Python",
            "Azure.Python"});
            this.comboBoxTargetLang.Location = new System.Drawing.Point(117, 8);
            this.comboBoxTargetLang.Name = "comboBoxTargetLang";
            this.comboBoxTargetLang.Size = new System.Drawing.Size(153, 21);
            this.comboBoxTargetLang.TabIndex = 0;
            this.comboBoxTargetLang.SelectedIndexChanged += new System.EventHandler(this.comboBoxTargetLang_SelectedIndexChanged);
            // 
            // panelError
            // 
            this.panelError.BackColor = System.Drawing.Color.Transparent;
            this.panelError.Controls.Add(this.labelError);
            this.panelError.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelError.Location = new System.Drawing.Point(0, 586);
            this.panelError.Name = "panelError";
            this.panelError.Size = new System.Drawing.Size(496, 138);
            this.panelError.TabIndex = 7;
            // 
            // panelProgress
            // 
            this.panelProgress.BackColor = System.Drawing.Color.Transparent;
            this.panelProgress.Controls.Add(this.progressBar);
            this.panelProgress.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.panelProgress.Location = new System.Drawing.Point(0, 586);
            this.panelProgress.Name = "panelProgress";
            this.panelProgress.Size = new System.Drawing.Size(496, 50);
            this.panelProgress.TabIndex = 7;
            // 
            // labelError
            // 
            this.labelError.Dock = System.Windows.Forms.DockStyle.Fill;
            this.labelError.ForeColor = System.Drawing.Color.DarkRed;
            this.labelError.Location = new System.Drawing.Point(0, 0);
            this.labelError.Name = "labelError";
            this.labelError.Padding = new System.Windows.Forms.Padding(8);
            this.labelError.Size = new System.Drawing.Size(496, 138);
            this.labelError.TabIndex = 0;
            this.labelError.Text = "labelError";
            // 
            // panelSrc
            // 
            this.panelSrc.Controls.Add(this.scintillaSrc);
            this.panelSrc.Dock = System.Windows.Forms.DockStyle.Fill;
            this.panelSrc.Location = new System.Drawing.Point(7, 7);
            this.panelSrc.Name = "panelSrc";
            this.panelSrc.Size = new System.Drawing.Size(495, 724);
            this.panelSrc.TabIndex = 4;
            // 
            // scintillaSrc
            // 
            this.scintillaSrc.AdditionalSelectionTyping = true;
            this.scintillaSrc.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.scintillaSrc.Dock = System.Windows.Forms.DockStyle.Fill;
            this.scintillaSrc.IndentationGuides = ScintillaNET.IndentView.Real;
            this.scintillaSrc.Lexer = ScintillaNET.Lexer.Python;
            this.scintillaSrc.Location = new System.Drawing.Point(0, 0);
            this.scintillaSrc.MouseDwellTime = 200;
            this.scintillaSrc.MouseSelectionRectangularSwitch = true;
            this.scintillaSrc.MultipleSelection = true;
            this.scintillaSrc.Name = "scintillaSrc";
            this.scintillaSrc.ScrollWidth = 255;
            this.scintillaSrc.Size = new System.Drawing.Size(495, 724);
            this.scintillaSrc.TabIndex = 5;
            this.scintillaSrc.TabWidth = 2;
            this.scintillaSrc.Text = File.ReadAllText("default.yaml");
            this.scintillaSrc.WrapIndentMode = ScintillaNET.WrapIndentMode.Indent;
            this.scintillaSrc.TextChanged += new System.EventHandler(this.scintillaSrc_TextChanged);
            // 
            // checkBoxShort
            // 
            this.checkBoxShort.AutoSize = true;
            this.checkBoxShort.ForeColor = System.Drawing.Color.Silver;
            this.checkBoxShort.Location = new System.Drawing.Point(290, 10);
            this.checkBoxShort.Name = "checkBoxShort";
            this.checkBoxShort.Size = new System.Drawing.Size(82, 17);
            this.checkBoxShort.TabIndex = 3;
            this.checkBoxShort.Text = "short output";
            this.checkBoxShort.UseVisualStyleBackColor = true;
            this.checkBoxShort.CheckedChanged += new System.EventHandler(this.checkBoxShort_CheckedChanged);
            //
            // regenerateTimer
            //
            this.regenerateTimer.Enabled = true;
            this.regenerateTimer.Interval = 200;
            this.regenerateTimer.Tick += new System.EventHandler(this.regenerateTimer_Tick);
            //
            // progressBar
            //
            this.progressBar.Value = 0;
            this.progressBar.Minimum = 0;
            this.progressBar.Maximum = 100;
            this.progressBar.Style = ProgressBarStyle.Marquee;
            this.progressBar.Dock = DockStyle.Fill;
            // 
            // AutoRestPreviewForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1011, 738);
            this.Controls.Add(this.tableLayoutPanel);
            //this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "AutoRestPreviewForm";
            this.Text = "AutoRest Preview";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.AutoRestPreviewForm_Load);
            this.tableLayoutPanel.ResumeLayout(false);
            this.panelDst.ResumeLayout(false);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            this.panelError.ResumeLayout(false);
            this.panelProgress.ResumeLayout(false);
            this.panelSrc.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel;
        private System.Windows.Forms.Panel panelDst;
        private System.Windows.Forms.Panel panelError;
        private System.Windows.Forms.Panel panelProgress;
        private ScintillaNET.Scintilla scintillaDst;
        private System.Windows.Forms.Panel panelSrc;
        private ScintillaNET.Scintilla scintillaSrc;
        private System.Windows.Forms.Label labelError;
        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Label labelTargetLang;
        private System.Windows.Forms.ComboBox comboBoxTargetLang;
        private System.Windows.Forms.CheckBox checkBoxShort;
        private System.Windows.Forms.Timer regenerateTimer;
        private System.Windows.Forms.ProgressBar progressBar;
    }
}

