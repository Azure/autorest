# Only have required parameters in constructor signature in C#

> see https://aka.ms/autorest

This causes addition/removal/reordering of *optional* properties *no* breaking change in the future.
We decided to make this the default behavior and also turn on the `useDefaultInConstructor` behavior (see `use-default-in-constructor` example).

Specify `--use-legacy-constructors` to go back to the previous behavior (and prevent the initial breaking change that goes along with this new behavior).

``` yaml 
input-file: new-constructors.yaml
```

## Regular run

``` yaml
csharp:
  - output-folder: Client
```

## Legacy run

``` yaml
csharp:
  - output-folder: ClientLegacy
    use-legacy-constructors: true
```

