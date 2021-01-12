# Markdown definition authoring

## Templating support

Content provided in the response can use some templating. This is done using the [Mustache](https://mustache.github.io/) library.

- `{{context.value}}`: Format
- `{{{context.value}}}`: Format

Context available to use can be seen in [TemplateContext](../src/models/template-context.ts)

**Example:**

```yaml
status: 202
headers:
  MyCustomHeader: "{{request.headers['mycustomheader']}}"
  Azure-AsyncOperation: "{{{request.baseUrl}}}/lro/LROPostDoubleHeadersFinalLocationGet/asyncOperationUrl"
  Location: "{{{request.baseUrl}}}/lro/LROPostDoubleHeadersFinalLocationGet/location"
```

Note: 
- Headers are all lowercase.