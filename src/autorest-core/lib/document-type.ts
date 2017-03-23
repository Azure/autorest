export type DocumentType = {
  readonly unknown: "unknown",
  readonly yaml: "yaml",
  readonly markdown: "markdown",
  readonly json: "json"
};

export const DocumentType: DocumentType = {
  unknown: "unknown",
  yaml: "yaml",
  markdown: "markdown",
  json: "json"
}

export const DocumentExtension = {
  "yaml": DocumentType.yaml,
  "yml": DocumentType.yaml,
  "json": DocumentType.json,
  "md": DocumentType.markdown,
  "markdown": DocumentType.markdown
}

export const DocumentPatterns = {
  yaml: [`*.${DocumentExtension.yaml}`, `*.${DocumentExtension.yml}`],
  json: [`*.${DocumentExtension.json}`],
  markdown: [`*.${DocumentExtension.markdown}`, `*.${DocumentExtension.md}`],
  all: [""]
}
DocumentPatterns.all = [...DocumentPatterns.yaml, ...DocumentPatterns.json, ...DocumentPatterns.markdown]