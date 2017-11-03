# Proposal: Structural Type Discrimination

This is a proposal for realizing structural type discrimination in order to enable runtime type selection in presence of `oneOf` or moral equivalents that don't have an explicit `discriminator`.

## *Why?* - Motivation

### Status Quo
It is not uncommon for an operation's response to match a selection of potential schemas.
So far we have established the following, deterministic, straight-forward way to derive the correct schema (⇒ runtime type) for a given response:
1. switch on *status code* (according to OpenAPI 2.0 definition)
2. switch on `Content-Type` (clear treatment in OpenAPI 3.0; hand-wavy treatment in OpenAPI 2.0, today we effectively hardcode something based on `produces`, after all one can also send `Accept` to nail the type)
3. switch on `discriminator` field, if present

### Limitations
Unfortunately, this strategy turns out to occasionally be insufficient to model some real world scenarios, in which there simply is no dedicated discriminator field, but still a selection of potential schemas after applying the above mechanism.
The approach proposed here will generalize step 3.

> A real world example: There's a service that returns 400 errors under different circumstances. It could be ASP.NET (before even calling the actual service), it could be the service. Schemas are different in both cases but can't be distinguished with our existing discrimination strategy.

### OpenAPI 2.0
While it is also not possible to *model* the above scenario using OpenAPI 2.0: no discriminator means no obligation to try resolving to a subschema - actually, the spec makes no call about that at all, but then again, why would it, since this is exclusively a code generation issue! For our part, we could agree that even without a discriminator, we wanna look for subschemas if the base schema has `additionalProperties: { type: object }` (which we, controversially, treat in the spirit of JSON schema's `additionalProperties: true`).

### OpenAPI 3.0
The problem becomes very real when moving to OpenAPI 3.0, which can trivially model the above scenario using `oneOf`/`anyOf` (e.g. `oneOf: [ Cat, Dog ]`, no discriminator and even no base schema a.k.a. "`Animal`" required). So when/if we're moving to OpenAPI 3.0, we will be *forced* to address the above limitations of our discrimination strategy. We may as well think about it now, potentially delivering some of the OpenAPI 3.0 goodness to our customers sooner.

## *What?* - Problem Specification

In certain cases we need a reliable way to **structurally discriminate objects** in order to derive a suitable runtime type for deserialization in presence of `oneOf` or a moral equivalent. Example:

> Given the following schemas, which will generate code for corresponding types:
>
> ``` YAML
> A:
>   required:
>     - x
>   properties:
>     x: { type: string }
>     y: { type: number, enum: [1, 2] }
>   additionalProperties: true
> B:
>   properties:
>     x: { type: string }
>   additionalProperties: false
> C:
>   required:
>     - y
>     - z
>   properties:
>     y: { type: number }
>     z: { type: number }
>   additionalProperties: true 
> ```
> 
> Which schema/type should be chosen at runtime given static type `oneOf: [A, B, C]` when given:
> ``` HASKELL
> 0) x: 42
> 1) x: "str"
> 2) x: "str", y: 2
> 3) x: "str", y: 2, z: 42
> 4) x: "str", y: 3
> 5) x: "str", y: 3, z: 42
> 6) y: 3, z: 42
> 7) z: 42
> 8) {}
> ```
> 
> Following the specification, the answer is:
> ``` HASKELL
> 0) err (no schema matches)
> 1) err (A & B match, violating oneOf)   
> 2) A
> 3) err (A & C match, violating oneOf)
> 4) err (no schema matches)
> 5) C
> 6) C
> 7) err (no schema matches)
> 8) B
> ```

Expressed using predicate logic (`S(o)` := object `o` matches schema `S`), the problem can be formalized as:
Given a specification with response schema `oneOf: [S_1, ..., S_n]`, generate code that decides:
Given `o`, determine whether there exists exactly one `i ∈ { 1, ..., n }` such that `S_i(o)` holds.
In that case, the corresponding type should be picked for deserialization, otherwise deserialization should fail.

## *How?* - Approach
### Baseline
The baseline solution would be to literally implement the above schema/type selection algorithm, i.e. check `o` against all potential schemas `S_i` (using some JSON/OpenAPI schema checker as used in `oav`) and taking things from there. This is obviously not practicable, but would be a good reference implementation.


### Disjoint schemas ⇒ eager checking
One of the main drawbacks of the above approach is the fact that *all* schemas have to be checked before being able to pick a type - even when a matching type is found, the semantics of `oneOf` require that *only* one schema matches (which distinguishes it from `anyOf`).

We could however *trust* the service that it complies with its spec, i.e. we should be *guaranteed* that once we find a matching schema, it will be the only one, allowing us to short-circuit the checks (let's call this approach "eager"). Fortunately, there are alternative approaches that both allow short-circuiting and do not rely on trust:

Two schemas `S_1` and `S_2` may be disjoint (`S_1 ∩ S_2 = ∅`), which is a very desirable property! In that case, it is *guaranteed* that `S_1(o)` implies that `S_2(o)` does not hold, which is  sufficient justification to *not* check `S_2(o)` once `S_1(o)` was confirmed. This generalizes to: A set of mutually disjoint schemas may legally be checked for eagerly! The interesting case is obviously if the schemas are *not* mutually disjoint.

#### Solution 0 - ignore it
One could argue that it's not our problem if objects match multiple schemas in a `oneOf` and just treat them according to the first matching schema we find.

#### Solution 1 - demand it
Statically enforce disjoint schemas in `oneOf`s. This could be a viable option or at least a strong validation message - it's usually a very bad sign if schemas overlap and indicates that the service wasn't modeled carefully enough.

#### Solution 2 - ensure it
If `S_1` and `S_2` are not disjoint, we may statically (during code generation) precompute slightly altered schemas `S_1' = S_1 \ S_2` and `S_2' = S_2 \ S_1` (using OpenAPI 3.0 `not` syntax, so we're not doing any voodoo). A `oneOf` using these altered schemas is equivalent to the original one, but `S_1'` and `S_2'` are also disjoint! In general, we would precompute all `S_i' = S_i \ (S_1 ∪ ... ∪ S_{i-1} ∪ S_{i+1} ∪ ... ∪ S_n)` and patch the `oneOf`s. This may sound complicated but really is not.

**Ultimately, we're always able to perform eager runtime checking of schemas.**

> Note that polymorphic hierarchies using `discriminator`s can be modeled *without* `discriminator` using a `oneOf` on the set of participating schemas, each of which having a constant property `<discriminator>: <discriminator value>`. Since the discriminator values are unique, all participating schemas are automatically mutually disjoint.


### Optimizing schema checks (requires Solution 1 or 2 from above)

Checking an object against a schema is not trivial, but there are shortcuts we can take, now that we may safely assume that schemas are mutually disjoint.
The idea is to select key features of a schema that actually *makes* it disjoint from all the others.
Formally, we are allowed to *weaken* the schemas/predicates `S_i'` as long as they *stay* mutually disjoint, yielding new, faster to check predicates `S_i''`.

> In case of the above thought experiment with remodelling `discriminator`s using `oneOf`, that key feature would obviously be the constant value of the `<discriminator>` field of each schema.
> Since that constant value is known to *differ* between all schemas, we may just as well *only* check for it to determine the matching runtime type.
> So while `S_dog'(o)` may have *fully* checked that `o` is in fact a dog and not a cat, `S_dog''(o) = o.<discriminator> = "dog"`

It is true that weakening the predicate means that objects that actually *don't* comply with the full schema could now match the predicate (in the above examples, any other required fields of a dog could be missing in `o`, but it would still be classified as a dog).
However, while weak schemas/predicates earlier led to potential misclassification, this is not the case this time (since predicates are still disjoint).
We merely risk allowing through objects that don't fully comply with *their* schema, which is nothing new, i.e. completely independent of the problem we are solving here.
If we *wanted* to realize a zero-trust relationship with servers, we would *have* to perform full, unoptimized schema checks anyways, so this section may be ignored.


## *How?* - Implementation

For now, we assume that we have a function `disjoint(Schema, Schema): boolean` that checks two schemas for disjointness.
An implementation will be illustrated later.

### Ignoring/Demanding/Ensuring disjointness of schemas (in **generator**)
- Solution 0 (ignore) requires no efforts
- Solution 1 (demand) requires `disjoint`
- Solution 2 (ensure) is trivial to implement:

``` JavaScript
const schemas /* = schemas we're supposed to match against */;
const disjointSchemas = schemas
    .map((schema, index) => {
        const notAnyOf = schemas.filter((_, i) => i !== index); // exclude all *other* schemas
        if (schema.not) notAnyOf.push(schema.not);              // preserve preexisting `not`
        return { ...result, ...{ not: { anyOf: notAnyOf } } };  // compose
    });
```

### Checking object against schema (in **generated code**)
This is required to pick the right type.
In a sense we could either resort to some existing libraries, but given that this is not too hard, we should implement our own thing (which will then also handle `x-ms-` stuff correctly).
Recall that what we currently do for `discriminator` is just a special case of exactly that - so even though "schema checking" is *theoretically* expensive, the expectation is that it is not in practice.

In other words: it's really in the hands of the API/OpenAPI author - if there just *is no easy way* to discriminate objects, then there also *is no cheap way* to perform that discrimination! Schema checking is key to being equipped for the 1% case *and* supports being highly efficient in the 99% case.

### Optimizing disjoint schemas (in **generator**)

Given disjoint schemas (solution 1 or 2), we *may* optimize/reduce them (as in, it is not *required* for correctness, but improves the performance of schema checking as motivated above).

While there are certainly scientifically more well-founded solutions, I'd propose the following heuristics (which would totally optimize the `discriminator` example back to exactly what we currently do for disctiminators):

0) given schema `S`
1) weaken the schema `S` at some spot (more about that later), yielding `S'` with `S' ⊃ S`
2) check `S'` for being `disjoint` with all *other* schemas; if yes, set `S := S'`
3) goto 1, unless there is no more way to weaken `S` (that we haven't tried before)

The above would be performed on all schemas involved in discrimination.

Example:
> ``` Haskell
> Dog:
>   required:
>     - kind
>   properties:
>     kind: { type: string, enum: [1] }
>     barkStyle: { type: BarkStyleType }
>   additionalProperties: false
> Cat:
>   required:
>     - kind
>     - catProperties
>   properties:
>     kind: { type: string, enum: [2] }
>     catProperties: { x-ms-client-flatten: true, type: CatProps }
> ```
>
> A `oneOf: [Cat, Dog]` will be able to perform discrimination based on the following, reduced schemas:
> ``` Haskell
> Dog:
>   required:
>     - kind
>   properties:
>     kind: { type: string, enum: [1] }
> Cat:
>   required:
>     - kind
>   properties:
>     kind: { type: string, enum: [2] }
> ```
> ...which corresponds to implementations `S_Dog(o) = (o.kind == 1)` and `S_Cat(o) = (o.kind == 2)`
>
> It might be worth emphasizing that these reduced schemas are *exclusively* used in this very context and do not interfere with any other matters, including other `oneOf`s in which `Cat`/`Dog` participates!

It remains to formalize what "weakening a schema at some spot" means.
A heuristics suffices here, at the risk of not optimizing as far as theoretically possible:
- removal of items in `required`
- weakening the schema of or removal of a property
- weakening the schema of or removal of `additionalProperties`
- weakening/removal of items in `allOf`
- turning a `oneOf` to `anyOf` (potentially a gradual process, by exchanging individual properties)
- turning an `anyOf` into optional properties of the schema itself (potentially a gradual process)
- strengthen/drop `not`

### Implementing `disjoint` (in **generator**)

A *general* implementation would require deciding first-order logic.
However, a conservative approximation (erring towards `false`) would suffice in practice.

Effects of conservatively approximating disjointness:
- Solution 1 may mistakenly reject OpenAPI definitions (i.e. err on the "safe" side)
- schema optimization may be less powerful due to premature termination of "weakening" algorithm outlined above

Bottom line, correctness of generated code is never at risk.

Heuristically checking for disjointness could involve:
- checking for disjoint `type`s (e.g. `{ type: string }` and `{ properties: ... }` is automatically disjoint, the latter schema has implicit type `object`)
- checking for mutually exclusive constraints in case of same `type` (e.g. `minLength: 5` vs `maxLength: 4`)
- looking for required common properties with disjoint `enum` sets (⇒ discriminator scenario covered with *just that*)
- looking for required common properties with disjoint schemas (yes, recursion)
- looking for "indicator properties" (`required` in one schema but forbidden in another, due to `additionalProperties: false`)

## Conclusion
This proposal motivates and illustrates "structural discrimination", a generalization of our current discrimination strategy using `discriminator`s.
While non-trivial in theory, it is easy and *valid* to implement conservative approximations as illustrated.

# Appendix
Further thoughts.

## Favorite solution regarding ignoring/demanding/ensuring disjointness of `oneOf`ed schemas
I would strongly suggest solution 2 (ensuring), since then no OpenAPI definition will ever be conservatively rejected, i.e. if the worst case scenario comes, we *will* generate correct code for it.
At the same time, we may *demand* disjointness in our validation tools since it is a decent quality criterion!

Note that in practice, solution 2 can be a no-op if the schemas are detected to already be disjoint.


## More about heuristics and actual implementation cost
We can start with horribly stupid approximations.
The `discriminator` scenario will be successfully optimized back to *exactly* what we do for discriminators right now even by very naive heuristics (that implement a faction of the strategies enumerated above).
Implementing this approximation would take less than a week front to back.

We could then improve these heuristics *on demand/as necessary*, i.e. whenever we encounter an OpenAPI definition that results in generation of checks that we are not happy with performance-wise.

## Mutual disjointness in optimization step
Given that schemas are checked *sequentially* in generated code, schemas checked later must actually no longer necessarily be disjoint with schemas checked earlier.
In other words, correctness of the generated code is preserved as long as a checked schema `S_i''` is disjoint from all `S_(i+1)', ..., S_n'`. There is no need to be disjoint from previously checked schemas since, if they had applied, we would have short-circuited all other checks.
A trivial implication of such optimization is, that the very final check can be reduced to `S_n(o) = true`.

Example:
> Given disjoint schemas:
> ``` Haskell
> S_1':
>   required:
>     - A
>   properties:
>     A: { type: string }
>   additionalProperties: false
> S_2':
>   required:
>     - A
>     - B
>   properties:
>     A: { type: string }
>     B: { type: string }
>   additionalProperties: false
> S_3':
>   required:
>     - B
>   properties:
>     B: { type: string }
>   additionalProperties: false
> ```
>
> ***Naive optimization (total mutual disjointness):***
> ``` Haskell
> S_1':
>   required:
>     - A
>   properties:
>     A: { }
>   additionalProperties: false
> S_2':
>   required:
>     - A
>     - B
>   properties:
>     A: { }
>     B: { }
> S_3':
>   required:
>     - B
>   properties:
>     B: { }
>   additionalProperties: false
> ```
> a.k.a.
> ``` Haskell
> S_1''(o) = Object.keys(o) == { "A" }
> S_2''(o) = ("A" in o) && ("B" in o)
> S_3''(o) = Object.keys(o) == { "B" }
> ```
>
> ***Order-aware optimization (mutual disjointness of every suffix):***
> ``` Haskell
> S_1':
>   required:
>     - A
>   properties:
>     A: { }
>   additionalProperties: false
> S_2':
>   required:
>     - A
>   properties:
>     A: { }
> S_3': { }
> ```
> a.k.a.
> ``` Haskell
> S_1''(o) = Object.keys(o) == { "A" }
> S_2''(o) = ("A" in o)
> S_3''(o) = true
> ```

Smooth.

## Taking it one step further: `anyOf`
When/If we gotta handle OpenAPI 3.0, `anyOf` wants to be handles as well.
Formally, the above approach easily extends to `anyOf` (with, say, `n` entries) by rewriting it with a `oneOf` containing all `2^n - 1` possible combinations of the `n` schemas (one combination is an `allOf` of the participating schemas).
As a result our existing strategy is usable for selecting the correct set of schemas for some object `o` (how that maps to runtime types is another challenge for statically typed languages, but `interface` hierarchies seem to work).


Example:
> ``` Haskell
> anyOf:
> - A
> - B
> - C
> ```
> is semantically equivalent to
> ``` Haskell
> oneOf:
> - allOf: [A, B, C]
>   not: { anyOf: [] }
> - allOf: [A, B]
>   not: { anyOf: [C] }
> - allOf: [A, C]
>   not: { anyOf: [B] }
> - allOf: [B, C]
>   not: { anyOf: [A] }
> - allOf: [A]
>   not: { anyOf: [B, C] }
> - allOf: [B]
>   not: { anyOf: [A, C] }
> - allOf: [C]
>   not: { anyOf: [A, B] }
> ```
> Note:
> - the recursion regarding `anyOf`
> - the cases are mutually exclusive (so "solution 2" is a no-op and we can optimize immediately)
>
> When checked sequentially in *this order*, these schemas can *at least* be simplified to
> ``` Haskell
> - allOf: [A', B', C']
> - allOf: [A', B']
> - allOf: [A', C']
> - allOf: [B', C']
> - allOf: [A']
> - allOf: [B']
> - allOf: [C']
> ```
> for some `A' ⊇ A`, `B' ⊇ B`, `C' ⊇ C`
> (i.e. the `not`s can be dropped since they are known to be satisfied given that we made it that far)

Since `({ allOf: [S_1, ..., S_n] })(o) = S_1(o) && ... && S_n(o)`, one can really just check `o` against all `n` weakened schemas and then select, instead of checking exponentially many options.

One may think "well that was obvious", but the real value in the above derivation lies in the fact that it gives the theoretical setting for how to *reduce* the individual schemas:
Since there is no mutual disjointness between the individual schemas, there is no clear bound or correctness criterion that justifies how much one can weaken schemas - it's easy to accidentally weaken a schema in a way that causes some objects to be classified differently!
The transformation via `oneOf` provides that correctness criterion.

Example:
``` Haskell
A:
  properties:
    y: { type: string }
    z: { type: string }
  additionalProperties: true
B:
  required:
    - x
  properties:
    x: { type: string }
```
While the checks for `A` and `B` in order to decide a `oneOf` could be reduced to `A''(o) = typeof o.x !== "string"` and `B''(o) = true`, this would be incorrect for deciding an `anyOf`:
`{ x: "hello", y: "world" }` matches *both* `A` and `B`, so the corresponding runtime type should be chosen - note however that `A''({ x: "hello", y: "world" })` as defined for `oneOf` is false.

It turns out that for `anyOf`, schema checks can actually not be reduced at all. If one of the schema checks was reduced, one could always construct an "attack" object that will not be classified correctly according to the spec.
