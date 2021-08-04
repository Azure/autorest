# Error in config example

> see https://aka.ms/autorest

## Settings

```yaml
# this is not nested correctly
some:
    nested:
  this_is_not_indented_correctly # Error line should be this one.
```
