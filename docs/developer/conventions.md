# Autoest Extension conventions

This is a set of convention extension should follow for consistency.

### `project-folder`

See [Issue 3695](https://github.com/Azure/autorest/issues/3695) for context.
If a generator needs to differentiate between `output-folder` where the generated content will be written and a project folder where the user might have their own data that shouln't be deleted, then `project-folder` configuration should be used.

- `project-folder`: Root of their sdk project
- `output-folder`: Folder where the generated SDK will be. Most likely under `$(project-fodler)`

Example:

```yaml
project-folder: $(sdk-root)
output-folder: ./$(project-folder)/src
clean-output-folder: true
customization-jar: ./$(project-folder)/target/bodycomplex-customization-1.0.0-beta.1.jar
```
