using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using AutoRest.Core.Logging;
using AutoRest.Core.Validation;
using ScintillaNET;
using YamlDotNet.RepresentationModel;

namespace AutoRest.Preview
{
    public class Linting
    {
        private class Highlight
        {
            public int Start;
            public int End;
            public string Message;
        }

        private readonly int INDICATOR_BASE = 8;
        private readonly Color[] INDIXATOR_COLORS = { Color.LightSkyBlue, Color.LightGreen, Color.Yellow, Color.PaleVioletRed, Color.PaleVioletRed };
        
        private List<Highlight> highlights = new List<Highlight>();
        private Scintilla scintilla;

        public Linting(Scintilla scintilla)
        {
            this.scintilla = scintilla;
            this.scintilla.DwellStart += ScintillaSrc_DwellStart;
            this.scintilla.DwellEnd += ScintillaSrc_DwellEnd;
        }

        private void ScintillaSrc_DwellStart(object sender, ScintillaNET.DwellEventArgs e)
        {
            var highlight = highlights.FirstOrDefault(h => h.Start <= e.Position && e.Position <= h.End);
            if (highlight != null)
            {
                scintilla.CallTipShow(highlight.Start, highlight.Message);
            }
        }
        private void ScintillaSrc_DwellEnd(object sender, ScintillaNET.DwellEventArgs e)
        {
            scintilla.CallTipCancel();
        }

        public void Reset()
        {
            highlights.Clear();

            var severityNames = Enum.GetNames(typeof(LogEntrySeverity));

            for (int i = 0; i < severityNames.Length; ++i)
            {
                int indicator = INDICATOR_BASE + i;

                // Remove all uses of our indicator
                scintilla.IndicatorCurrent = indicator;
                scintilla.IndicatorClearRange(0, scintilla.TextLength);

                // Update indicator appearance
                scintilla.Indicators[indicator].Style = IndicatorStyle.StraightBox;
                //scintilla.Indicators[indicator].Style = IndicatorStyle.Squiggle;
                scintilla.Indicators[indicator].Under = true;
                scintilla.Indicators[indicator].ForeColor = INDIXATOR_COLORS[i];
                scintilla.Indicators[indicator].OutlineAlpha = 80;
                scintilla.Indicators[indicator].Alpha = 50;
            }
        }

        public void ProcessMessages(string swagger, IEnumerable<ValidationMessage> messages)
        {
            if (scintilla.Text != swagger)
                return; // text was changed in the meantime

            // try parse
            var reader = new StringReader(swagger);
            YamlNode doc = null;
            try
            {
                var yamlStream = new YamlStream();
                yamlStream.Load(reader);
                doc = yamlStream.Documents[0].RootNode;
            }
            catch { }

            // process messages
            if (doc != null)
            {
                foreach (var message in messages)
                {
                    if (message.Severity > LogEntrySeverity.Debug)
                    {
                        scintilla.IndicatorCurrent = INDICATOR_BASE + (int)message.Severity;
                        var node = doc.ResolvePath(message.Path.Reverse().Skip(1));
                        var start = node.Start.Index;
                        var len = Math.Max(1, node.End.Index - start);
                        scintilla.IndicatorFillRange(start, len);
                        highlights.Add(new Highlight
                        {
                            Start = start,
                            End = start + len,
                            Message =
                                $"{message.Severity}: [{string.Join("->", message.Path.Reverse())}] {message.Message}"
                        });
                    }
                }
            }
        }
    }
}
