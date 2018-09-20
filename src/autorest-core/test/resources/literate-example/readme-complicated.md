# MySample API

> see https://aka.ms/autorest

## First Chapter

``` yaml $(42 == 3 + 39)
true0: true
```

``` yaml
true1: true
```

``` yaml $(42 == 3 + 38)
true1: false
```

``` yaml $(cmd-line-true)
true2: true
```

``` yaml $(cmd-line-false)
true2: false
```

``` yaml $($["cmd-line-complex"].true)
true3: true
```

``` yaml $($["cmd-line-complex"].false)
true3: false
```

``` yaml $(true0 && true1 && true2 && true3)
true4: true
```

``` yaml $(true4)
azure-validator: true
openapi-type: arm
input-file:
- swagger.md
```

``` yaml !$(notdefined)  
shouldwork: true

```

``` yaml $(notdefined)  
shouldnotwork: true

```
