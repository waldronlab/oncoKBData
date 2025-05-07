
# oncoKBData

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The aim of the package is to expose the OncoKB API through an R client.
This vignette demonstrates public API access. To learn more about the
OncoKB database, visit <https://www.oncokb.org>.

# Installation

To get the development version of `oncoKBData` use:

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("waldronlab/oncoKBData")
```

# Package Load

``` r
library(oncoKBData)
library(S4Vectors)
```

# Introduction

The `oncoKBData` aims to provide access to the OncoKB API via the public
API. Access is also possible with a licensed token.

## API representation

In order to use the OncoKB API, we must instantiate an API object as
provided by the
*[rapiclient](https://CRAN.R-project.org/package=rapiclient)* and
*[AnVIL](https://bioconductor.org/packages/3.22/AnVIL)* packages.

``` r
oncokb <- oncoKB()
```

Note that for private API access, users must change the `api.` argument
in the `oncoKB` function.

## Operations

Check available tags, operations, and descriptions as a `tibble`:

``` r
tags(oncokb)
#> # A tibble: 20 × 3
#>    tag          operation                                       summary                             
#>    <chr>        <chr>                                           <chr>                               
#>  1 Annotations  annotateCopyNumberAlterationsGetUsingGET_1      annotateCopyNumberAlterationsGet    
#>  2 Annotations  annotateCopyNumberAlterationsPostUsingPOST_1    annotateCopyNumberAlterationsPost   
#>  3 Annotations  annotateMutationsByGenomicChangeGetUsingGET_1   annotateMutationsByGenomicChangeGet 
#>  4 Annotations  annotateMutationsByGenomicChangePostUsingPOST_1 annotateMutationsByGenomicChangePost
#>  5 Annotations  annotateMutationsByHGVSgGetUsingGET_1           annotateMutationsByHGVSgGet         
#>  6 Annotations  annotateMutationsByHGVSgPostUsingPOST_1         annotateMutationsByHGVSgPost        
#>  7 Annotations  annotateMutationsByProteinChangeGetUsingGET_1   annotateMutationsByProteinChangeGet 
#>  8 Annotations  annotateMutationsByProteinChangePostUsingPOST_1 annotateMutationsByProteinChangePost
#>  9 Annotations  annotateStructuralVariantsGetUsingGET_1         annotateStructuralVariantsGet       
#> 10 Annotations  annotateStructuralVariantsPostUsingPOST_1       annotateStructuralVariantsPost      
#> 11 Cancer Genes utilsAllCuratedGenesGetUsingGET_1               utilsAllCuratedGenesGet             
#> 12 Cancer Genes utilsAllCuratedGenesTxtGetUsingGET_1            utilsAllCuratedGenesTxtGet          
#> 13 Cancer Genes utilsCancerGeneListGetUsingGET_1                utilsCancerGeneListGet              
#> 14 Cancer Genes utilsCancerGeneListTxtGetUsingGET_1             utilsCancerGeneListTxtGet           
#> 15 Info         infoGetUsingGET_1                               infoGet                             
#> 16 Levels       levelsDiagnosticGetUsingGET_1                   levelsDiagnosticGet                 
#> 17 Levels       levelsGetUsingGET_1                             levelsGet                           
#> 18 Levels       levelsPrognosticGetUsingGET_1                   levelsPrognosticGet                 
#> 19 Levels       levelsResistanceGetUsingGET_1                   levelsResistanceGet                 
#> 20 Levels       levelsSensitiveGetUsingGET_1                    levelsSensitiveGet
head(tags(oncokb)$operation)
#> [1] "annotateCopyNumberAlterationsGetUsingGET_1"      "annotateCopyNumberAlterationsPostUsingPOST_1"   
#> [3] "annotateMutationsByGenomicChangeGetUsingGET_1"   "annotateMutationsByGenomicChangePostUsingPOST_1"
#> [5] "annotateMutationsByHGVSgGetUsingGET_1"           "annotateMutationsByHGVSgPostUsingPOST_1"
```

**Note**. The annotations API access requires a token.

## Levels of Evidence

To retrieve the levels of evidence for all types (i.e., ‘therapeutic’,
‘diagnostic’, ‘prognostic’, and ‘FDA’) run the `levelsOfEvidence`
function.

``` r
(loe <- levelsOfEvidence(oncokb))
#> DataFrame with 16 rows and 4 columns
#>     levelOfEvidence            description        htmlDescription    colorHex
#>         <character>            <character>            <character> <character>
#> 1           LEVEL_1 FDA-recognized bioma.. <span><b>FDA-recogni..     #33A02C
#> 2           LEVEL_2 Standard care biomar.. <span><b>Standard ca..     #1F78B4
#> 3          LEVEL_3A Compelling clinical .. <span><b>Compelling ..     #984EA3
#> 4          LEVEL_3B Standard care or inv.. <span><b>Standard ca..     #BE98CE
#> 5           LEVEL_4 Compelling biologica.. <span><b>Compelling ..     #424242
#> ...             ...                    ...                    ...         ...
#> 12        LEVEL_Px1 FDA and/or professio.. <span><b>FDA and/or ..     #33A02C
#> 13        LEVEL_Px2 FDA and/or professio.. <span><b>FDA and/or ..     #1F78B4
#> 14        LEVEL_Px3 Biomarker is prognos.. <span>Biomarker is p..     #984EA3
#> 15         LEVEL_R1 Standard care biomar.. <span><b>Standard of..     #EE3424
#> 16         LEVEL_R2 Compelling clinical .. <span><b>Compelling ..     #F79A92
```

It will return a `DataFrame` with important `metadata`:

``` r
names(metadata(loe))
#> [1] "oncoTreeVersion" "ncitVersion"     "dataVersion"     "appVersion"      "apiVersion"      "publicInstance"  "genomeNexus"

metadata(loe)["oncoTreeVersion"]
#> $oncoTreeVersion
#> [1] "oncotree_2019_12_01"

metadata(loe)[["apiVersion"]]
#> $version
#> [1] "v1.5.0"
#> 
#> $major
#> [1] 1
#> 
#> $minor
#> [1] 5
#> 
#> $patch
#> [1] 0
#> 
#> $suffixTokens
#> list()
#> 
#> $stable
#> [1] TRUE
```

## Gene tables

The API allows retrieval of curated genes where there is a single gene
per observation:

``` r
curatedGenes(oncokb)
#> # A tibble: 933 × 13
#>    grch37Isoform  grch37RefSeq grch38Isoform grch38RefSeq entrezGeneId hugoSymbol oncogene highestSensitiveLevel highestResistanceLevel
#>    <chr>          <chr>        <chr>         <chr>               <int> <chr>      <lgl>    <chr>                 <chr>                 
#>  1 ENST000002657… NM_000927.4  ENST00000622… NM_00134894…         5243 ABCB1      TRUE     ""                    ""                    
#>  2 ENST000003185… NM_005157.4  ENST00000318… NM_005157.4            25 ABL1       TRUE     "1"                   "R1"                  
#>  3 ENST000005027… NM_007314.3  ENST00000502… NM_007314.3            27 ABL2       TRUE     ""                    ""                    
#>  4 ENST000003219… NM_139076.2  ENST00000321… NM_139076.2         84142 ABRAXAS1   FALSE    ""                    ""                    
#>  5 ENST000002729… NM_020311    ENST00000272… NM_020311           57007 ACKR3      TRUE     ""                    ""                    
#>  6 ENST000003319… NM_00119995… ENST00000573… NM_00119995…           71 ACTG1      FALSE    ""                    ""                    
#>  7 ENST000002636… NM_00111106… ENST00000263… NM_00111106…           90 ACVR1      TRUE     ""                    ""                    
#>  8 ENST000002579… NM_004302    ENST00000257… NM_004302              91 ACVR1B     FALSE    ""                    ""                    
#>  9 ENST000002414… NM_001278579 ENST00000241… NM_001278579           92 ACVR2A     TRUE     ""                    ""                    
#> 10 ENST000003813… NM_018702.3  ENST00000381… NM_018702.4           105 ADARB2     TRUE     ""                    ""                    
#> # ℹ 923 more rows
#> # ℹ 4 more variables: summary <chr>, background <chr>, tsg <lgl>, highestResistancLevel <chr>
```

and a long list of genes associated with cancer where there can be
multiple entries for the same `hugoSymbol` due to multiple
`geneAliases`:

``` r
cancerGeneList(oncokb)
#> # A tibble: 3,275 × 17
#>    hugoSymbol entrezGeneId grch37Isoform   grch37RefSeq   grch38Isoform  grch38RefSeq oncokbAnnotated occurrenceCount mSKImpact mSKHeme
#>    <chr>             <int> <chr>           <chr>          <chr>          <chr>        <lgl>                     <int> <lgl>     <lgl>  
#>  1 ABL1                 25 ENST00000318560 NM_005157.4    ENST000003185… NM_005157.4  TRUE                          7 TRUE      TRUE   
#>  2 ABL1                 25 ENST00000318560 NM_005157.4    ENST000003185… NM_005157.4  TRUE                          7 TRUE      TRUE   
#>  3 ABL1                 25 ENST00000318560 NM_005157.4    ENST000003185… NM_005157.4  TRUE                          7 TRUE      TRUE   
#>  4 AKT1                207 ENST00000349310 NM_001014431.1 ENST000003493… NM_00101443… TRUE                          7 TRUE      TRUE   
#>  5 AKT1                207 ENST00000349310 NM_001014431.1 ENST000003493… NM_00101443… TRUE                          7 TRUE      TRUE   
#>  6 AKT1                207 ENST00000349310 NM_001014431.1 ENST000003493… NM_00101443… TRUE                          7 TRUE      TRUE   
#>  7 AKT1                207 ENST00000349310 NM_001014431.1 ENST000003493… NM_00101443… TRUE                          7 TRUE      TRUE   
#>  8 AKT1                207 ENST00000349310 NM_001014431.1 ENST000003493… NM_00101443… TRUE                          7 TRUE      TRUE   
#>  9 ALK                 238 ENST00000389048 NM_004304.4    ENST000003890… NM_004304.4  TRUE                          7 TRUE      TRUE   
#> 10 AMER1            139285 ENST00000330258 NM_152424.3    ENST000003748… NM_152424.3  TRUE                          7 TRUE      TRUE   
#> # ℹ 3,265 more rows
#> # ℹ 7 more variables: foundation <lgl>, foundationHeme <lgl>, vogelstein <lgl>, sangerCGC <lgl>, geneAliases <list>, tsg <lgl>,
#> #   oncogene <lgl>
```

# Session Information

<details>
<summary>
Click to expand <code>sessionInfo()</code>
</summary>
<pre><code>R version 4.5.0 Patched (2025-04-15 r88148)
Platform: x86_64-pc-linux-gnu
Running under: Ubuntu 24.04.2 LTS
&#10;Matrix products: default
BLAS/LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
&#10;locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
&#10;time zone: America/New_York
tzcode source: system (glibc)
&#10;attached base packages:
[1] stats4    stats     graphics  grDevices utils     datasets  methods   base     
&#10;other attached packages:
[1] BiocStyle_2.37.0    S4Vectors_0.47.0    BiocGenerics_0.55.0 generics_0.1.3      oncoKBData_0.99.4   AnVIL_1.21.3       
[7] AnVILBase_1.3.1     dplyr_1.1.4         colorout_1.3-2     
&#10;loaded via a namespace (and not attached):
 [1] utf8_1.2.4           rappdirs_0.3.3       futile.options_1.0.1 digest_0.6.37        magrittr_2.0.3       evaluate_1.0.3      
 [7] fastmap_1.2.0        rprojroot_2.0.4      jsonlite_2.0.0       processx_3.8.6       pkgbuild_1.4.7       ps_1.9.1            
[13] formatR_1.14         promises_1.3.2       BiocManager_1.30.25  httr_1.4.7           purrr_1.0.4          rapiclient_0.1.8    
[19] codetools_0.2-20     httr2_1.1.2          cli_3.6.5            shiny_1.10.0         rlang_1.1.6          futile.logger_1.4.3 
[25] remotes_2.5.0        yaml_2.3.10          BiocBaseUtils_1.11.0 tools_4.5.0          httpuv_1.6.16        DT_0.33             
[31] lambda.r_1.2.4       curl_6.2.2           vctrs_0.6.5          R6_2.6.1             mime_0.13            lifecycle_1.0.4     
[37] fs_1.6.6             htmlwidgets_1.6.4    usethis_3.1.0        miniUI_0.1.2         pkgconfig_2.0.3      desc_1.4.3          
[43] callr_3.7.6          clipr_0.8.0          pillar_1.10.2        later_1.4.2          rsconnect_1.3.4      glue_1.8.0          
[49] Rcpp_1.0.14          xfun_0.52            tibble_3.2.1         tidyselect_1.2.1     rstudioapi_0.17.1    knitr_1.50          
[55] xtable_1.8-4         htmltools_0.5.8.1    rmarkdown_2.29       compiler_4.5.0      </code></pre>
</details>
