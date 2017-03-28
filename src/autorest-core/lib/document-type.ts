export enum DocumentType {
  Markdown = <any>"markdown",
  Yaml = <any>"yaml",
  Json = <any>"json",
  Unknown = <any>"unknown"
}

export const DocumentExtension = {
  "yaml": DocumentType.Yaml,
  "yml": DocumentType.Yaml,
  "json": DocumentType.Json,
  "md": DocumentType.Markdown,
  "markdown": DocumentType.Markdown
}

export const DocumentPatterns = {
  yaml: [`*.${DocumentExtension.yaml}`, `*.${DocumentExtension.yml}`],
  json: [`*.${DocumentExtension.json}`],
  markdown: [`*.${DocumentExtension.markdown}`, `*.${DocumentExtension.md}`],
  all: [""]
}
DocumentPatterns.all = [...DocumentPatterns.yaml, ...DocumentPatterns.json, ...DocumentPatterns.markdown]