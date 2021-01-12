# Markdown definition authoring

## Basic structure

This is the basic structure each definition file should be following. Heading **NEEDS** to follow the same level as shown(`#`, `##`, etc.)

```
# Title

# Routes

## [METHOD] [PATH]

### Request (Optional)
<...request definition...>

### Response
<...response definition...>
```

for example

```
# MyTitle

# Routes

## GET /mypath

### Response
<...response definition...>
```

See [examples](../examples) for more detailed samples.

## Request requirements

Request requirements are optional which means you the `Request` heading can be omitted if there is no addional requirement than the url and method.

Right under the `### Request` heading you can add a `yaml` code block defining this config.

For example:

````
### Request

```yaml
body:
  rawContent: "1234"
```
````

### Request body requirements

#### 1. Using the body heading

You can add a `#### Body` heading under the `### Request` to define the requirement for the body. In there it will be expected to have a code block with the expected content.
Set the language of the code block so it can know how to parse it. Supported languages right now are:

| Language | Expected Content-Type | Description                                                                           |
| -------- | --------------------- | ------------------------------------------------------------------------------------- |
| `text`   | `*/*`                 | Will treat the content as an exact match requirement.                                 |
| `json`   | `application/json`    | Will parse the content using `JSON.parse` and do a deep equal with the provided body. |
| `xml`    | `application/xml`     | Will parse the content as xml and do a deep equal with the provided body.             |

Example:

````
### Request

#### Body

```json
{
  "foo": "bar"
}
```
````

#### 2. Using yaml config

If the body requirement is simple it might be easier to just define the requirement inline inside the yaml code block.

```yaml
body:
  contentType: <content-type>
  rawContent: <raw-content-str>

  # To do a deep equal
  matchType: "object"
  content: <object to match>
```

Example:

```yaml
body:
  contentType: application/json
  rawContent: '"foo"'
  content: "foo"
  matchType: "object"
```

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
