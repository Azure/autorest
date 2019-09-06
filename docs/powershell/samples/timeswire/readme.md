# TimesWire Search

> see https://aka.ms/autorest

This is the AutoRest configuration and documentation file for TimesWire Search.

---
## Getting Started
To build the SDK for TimesWire Search, you will need the following: 

- An [API KEY](https://developer.nytimes.com/get-started) for the times wire service

- Some files, which you can get with the following script:

``` powershell
mkdir -ea 0 ./generated/custom  
mkdir -ea 0 ./generated/test  

iwr https://raw.githubusercontent.com/Azure/autorest/master/docs/powershell/samples/timeswire/readme.md -outfile ./readme.md
iwr https://raw.githubusercontent.com/Azure/autorest/master/docs/powershell/samples/timeswire/timeswire.yaml -outfile ./timeswire.yaml
iwr https://raw.githubusercontent.com/Azure/autorest/master/docs/powershell/samples/timeswire/generated/custom/Module.cs -outfile ./generated/custom/Module.cs
iwr https://raw.githubusercontent.com/Azure/autorest/master/docs/powershell/samples/timeswire/generated/test/get-article.tests.ps1 -outfile ./generated/test/get-article.tests.ps1

```

Then simply [Install AutoRest Beta](../../readme.md#installing) and in this folder, run:

> `autorest`

Then you can compile the module:

> `./generated/build-module.ps1`

``` text
Spawning in isolated process.
Cleaning folders...
Compiling private module code
Private Module loaded (C:\...\sample\generated\bin\TimesNewswire.private.dll).
Processing cmdlet variants
Generating unified cmdlet proxies
Done.
```

But really, you want to build the module and then load it in a new instance of `pwsh`, so add `-Run`:

> `./generated/build-module.ps1 -Run`

``` text
Spawning in isolated process.
Cleaning folders...
Compiling private module code
Private Module loaded (C:\...\sample\generated\bin\TimesNewswire.private.dll).
Processing cmdlet variants
Generating unified cmdlet proxies
Done.

PS C:\...\sample\generated [ testing TimesNewswire ] >
```

Set your Api Key 

> `$env:TimesApiKey="#################"

and run the cmdlet: 

> `(Get-Article -Source nyt -Section sports).Results | fl * `

``` bash 
# yada yada yada ...
Abstract          : NBC Sports contradicted Mr. Costas’s account, saying he had not been removed from Super Bowl coverage as punishment and that the decision had been mutual.
BlogName          :
Byline            : By MATTHEW HAAG
CreatedDate       : 2019-02-11T15:43:30-05:00
DesFacet          : {Football, Concussions, Television}
GeoFacet          :
Headline          :
ItemType          : Article
Kicker            :
MaterialTypeFacet : News
Multimedia        : {Times.Wire.Search.Models.ArticleMultimediaItemType, Times.Wire.Search.Models.ArticleMultimediaItemType, Times.Wire.Search.Models.ArticleMultimediaItemType,
                    Times.Wire.Search.Models.ArticleMultimediaItemType}
OrgFacet          :
PerFacet          : {Costas, Bob}
PublishedDate     : 2019-02-10T19:00:00-05:00
RelatedUrls       : {Times.Wire.Search.Models.ArticleRelatedUrlsItemType, Times.Wire.Search.Models.ArticleRelatedUrlsItemType, Times.Wire.Search.Models.ArticleRelatedUrlsItemType,
                    Times.Wire.Search.Models.ArticleRelatedUrlsItemType...}
Section           : Sports
ShortUrl          :
Source            : The New York Times
Subsection        :
ThumbnailStandard : https://static01.nyt.com/images/2019/02/12/sports/12xp-costas/12xp-costas-thumbStandard.jpg
Title             : Bob Costas Accuses NBC of Retaliating for His Remarks on Concussions in N.F.L.
UpdatedDate       : 2019-02-12T12:25:42-05:00
Url               : https://www.nytimes.com/2019/02/11/sports/bob-costas-super-bowl.html
```

---


## Notes about using Authentication
AutoRest doesn't add authentication code into the generated client, given that there is so much variance on how that works.

This sample includes an [extension](./generated/custom/Module.cs) to the module that alters the HTTP payload before it's sent.


### AutoRest Configuration  Information
These are the settings for generating the cmdlets for the API with AutoRest (instead of putting them on the command line)

``` yaml
input-file: timeswire.yaml
namespace: Times.Wire.Search

powershell:
  clear-output-folder: true
  output-folder: generated

  operations:
    Articles_ListBySourceAndRange:
      verb: Get
      noun: MyArticle
      description: Gets an article for me.
      parameters:
        TimePeriod:
          type: integer
          description: The *time* period. Get it ? "TIME"
        Source: null # delete this parameter entirely.
```

# PowerShell
This configuration block pulls in the powershell generator automatically. 

``` yaml
use:
- "@autorest/powershell"

```

