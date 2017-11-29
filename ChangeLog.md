## 2017.11.29 Version 2.0.4210
* Use Ruby generator 3.x.x (instead of 2.x.x) by default, supports multi API version generation. Use `--use=@microsoft.azure/autorest.ruby@^2.0.0` to use the old generator.
* Extensible enum support for C#
* Generate API version metadata for C#
* Reactivated oav model validator plugin
* Integrated VSCode LSP
* Improved command line help (showing automatically in some situations that imply that the user may need it; Python and C# generator specific help)
* Feature coverage tracking for most generators (see [http://azure.github.io/autorest/dashboard.html](http://azure.github.io/autorest/dashboard.html))
* Better output colorization
* Various bugfixes (see #2727, #2694, #2689, #2688, #2685, #2674, #2671, #2655, #2434, #1734), most notably
  * Nested schema definitions (outside of `definitions` section) completely ignored the `required` field
  * Better support for huge OpenAPI files (caused stack overflow)
  * Constant body parameters where not treated as constants
