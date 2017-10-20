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
Unfortunately, this strategy turns out to occasionally be sufficient to model some real world scenarios, in which there simply is no dedicated discriminator field, but still a selection of potential schemas after applying the above mechanism.

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

#### Solution 1 - demand it
Statically enforce disjoint schemas in `oneOf`s. This could be a viable option or at least a strong validation message - it's usually a very bad sign if schemas overlap and indicates that the service wasn't modeled carefully enough.

#### Solution 2 - ensure it
If `S_1` and `S_2` are not disjoint, we may statically (during code generation) precompute slightly altered schemas `S_1' = S_1 \ S_2` and `S_2' = S_2 \ S_1` (using OpenAPI 3.0 `not` syntax, so we're not doing any voodoo). A `oneOf` using these altered schemas is equivalent to the original one, but `S_1'` and `S_2'` are also disjoint! In general, we would precompute all `S_i' = S_i \ (S_1 ∪ ... ∪ S_{i-1} ∪ S_{i+1} ∪ ... ∪ S_n)` and patch the `oneOf`s. This may sound complicated but really is not.

**Ultimately, we're always able to perform eager runtime checking of schemas.**

> Note that polymorphic hierarchies using `discriminator`s can be modeled *without* `discriminator` using a `oneOf` on the set of participating schemas, each of which having a constant property `<discriminator>: <discriminator value>`. Since the discriminator values are unique, all participating schemas are automatically mutually disjoint.


### Optimizing schema checks

Checking an object against a schema is not trivial, but there are shortcuts we can take, now that we may safely assume that schemas are mutually disjoint.
The idea is to select key features of a schema that actually *makes* it disjoint from all the others.
Formally, we are allowed to *weaken* the schemas/predicates `S_i'` as long as they *stay* mutually disjoint, yielding new, faster to check predicates `S_i''`.

> In case of the above thought experiment with remodelling `discriminator`s using `oneOf`, that key feature would obviously be the constant value of the `<discriminator>` field of each schema.
> Since that constant value is known to *differ* between all schemas, we may just as well *only* check for it to determine the matching runtime type.
> So while `S_dog'(o)` may have *fully* checked that `o` is in fact a dog and not a cat, `S_dog''(o) = o.<discriminator> = "dog"`

It is true that weakening the predicate means that object that actually *don't* comply with the full schema could pass the check (e.g., a dog would be classified as one just because of some field, even if other required fields are missing)


## Conclusion
Shown that `discriminator`s are a concept that is fully compatible with, but also just a special case of our approach.
Schema discrimination is generalized and formalized and illustrated with 

# Appendix

Further thoughts.

## Taking it one step further: `anyOf`