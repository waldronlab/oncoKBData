
# oncoKBData

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
*[AnVIL](https://bioconductor.org/packages/3.17/AnVIL)* packages.

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
#> [1] "oncoTreeVersion" "ncitVersion"     "dataVersion"     "appVersion"      "apiVersion"      "publicInstance"

metadata(loe)["oncoTreeVersion"]
#> $oncoTreeVersion
#> [1] "oncotree_2019_12_01"

metadata(loe)[["apiVersion"]]
#> $version
#> [1] "v1.4.0"
#> 
#> $major
#> [1] 1
#> 
#> $minor
#> [1] 4
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
#> # A tibble: 725 × 13
#>    grch37Isoform   grch37RefSeq   grch38Isoform   grch38RefSeq   entrezGeneId hugoSymbol oncogene highest…¹ highe…² summary backg…³ tsg   highe…⁴
#>    <chr>           <chr>          <chr>           <chr>                 <int> <chr>      <lgl>    <chr>     <chr>   <chr>   <chr>   <lgl> <chr>  
#>  1 ENST00000318560 NM_005157.4    ENST00000318560 NM_005157.4              25 ABL1       TRUE     "1"       "R1"    ABL1, … "ABL1 … FALSE "R1"   
#>  2 ENST00000502732 NM_007314.3    ENST00000502732 NM_007314.3              27 ABL2       TRUE     ""        ""      ABL2, … "ABL2 … FALSE ""     
#>  3 ENST00000321945 NM_139076.2    ENST00000321945 NM_139076.2           84142 ABRAXAS1   FALSE    ""        ""      ABRAXA… "The A… TRUE  ""     
#>  4 ENST00000331925 NM_001199954.1 ENST00000573283 NM_001199954.1           71 ACTG1      FALSE    ""        ""      ACTG1,… "ACTG1… TRUE  ""     
#>  5 ENST00000263640 NM_001111067.2 ENST00000263640 NM_001111067.2           90 ACVR1      TRUE     ""        ""      ACVR1,… "ACVR1… FALSE ""     
#>  6 ENST00000396623 NM_144650      ENST00000396623 NM_144650            137872 ADHFE1     TRUE     ""        ""      ADHFE1… "ADHFE… FALSE ""     
#>  7 ENST00000265343 NM_014423      ENST00000265343 NM_014423             27125 AFF4       TRUE     ""        ""      AFF4, … "AFF4 … FALSE ""     
#>  8 ENST00000373204 NM_012199.2    ENST00000373204 NM_012199.2           26523 AGO1       TRUE     ""        ""      AGO1, … "AGO1 … FALSE ""     
#>  9 ENST00000220592 NM_012154.3    ENST00000220592 NM_012154.3           27161 AGO2       FALSE    ""        ""      AGO2, … "AGO2 … FALSE ""     
#> 10 ENST00000262713 NM_032876.5    ENST00000262713 NM_032876.5           84962 AJUBA      FALSE    ""        ""      AJUBA,… "AJUBA… TRUE  ""     
#> # … with 715 more rows, and abbreviated variable names ¹​highestSensitiveLevel, ²​highestResistanceLevel, ³​background, ⁴​highestResistancLevel
```

and a long list of genes associated with cancer where there can be
multiple entries for the same `hugoSymbol` due to multiple
`geneAliases`:

``` r
cancerGeneList(oncokb)
#> # A tibble: 3,019 × 17
#>    hugoSymbol entrezGeneId grch37…¹ grch3…² grch3…³ grch3…⁴ oncok…⁵ occur…⁶ mSKIm…⁷ mSKHeme found…⁸ found…⁹ vogel…˟ sange…˟ geneA…˟ tsg   oncog…˟
#>    <chr>             <int> <chr>    <chr>   <chr>   <chr>   <lgl>     <int> <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <lgl>   <list>  <lgl> <lgl>  
#>  1 ABL1                 25 ENST000… NM_005… ENST00… NM_005… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  2 ABL1                 25 ENST000… NM_005… ENST00… NM_005… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  3 ABL1                 25 ENST000… NM_005… ENST00… NM_005… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  4 AKT1                207 ENST000… NM_001… ENST00… NM_001… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  5 AKT1                207 ENST000… NM_001… ENST00… NM_001… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  6 AKT1                207 ENST000… NM_001… ENST00… NM_001… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  7 AKT1                207 ENST000… NM_001… ENST00… NM_001… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  8 AKT1                207 ENST000… NM_001… ENST00… NM_001… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#>  9 ALK                 238 ENST000… NM_004… ENST00… NM_004… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   FALSE TRUE   
#> 10 AMER1            139285 ENST000… NM_152… ENST00… NM_152… TRUE          7 TRUE    TRUE    TRUE    TRUE    TRUE    TRUE    <chr>   TRUE  FALSE  
#> # … with 3,009 more rows, and abbreviated variable names ¹​grch37Isoform, ²​grch37RefSeq, ³​grch38Isoform, ⁴​grch38RefSeq, ⁵​oncokbAnnotated,
#> #   ⁶​occurrenceCount, ⁷​mSKImpact, ⁸​foundation, ⁹​foundationHeme, ˟​vogelstein, ˟​sangerCGC, ˟​geneAliases, ˟​oncogene
```

# Session Information

``` r
sessionInfo()
#> R Under development (unstable) (2023-02-22 r83892)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Ubuntu 22.04.1 LTS
#> 
#> Matrix products: default
#> BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
#> LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.20.so;  LAPACK version 3.10.0
#> 
#> locale:
#>  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8     LC_MONETARY=en_US.UTF-8   
#>  [6] LC_MESSAGES=en_US.UTF-8    LC_PAPER=en_US.UTF-8       LC_NAME=C                  LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> time zone: Etc/UTC
#> tzcode source: system (glibc)
#> 
#> attached base packages:
#> [1] stats4    stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] BiocStyle_2.27.1    S4Vectors_0.37.4    BiocGenerics_0.45.0 oncoKBData_0.99.1   AnVIL_1.11.3        dplyr_1.1.0         colorout_1.2-2     
#> 
#> loaded via a namespace (and not attached):
#>  [1] utf8_1.2.3           generics_0.1.3       tidyr_1.3.0          futile.options_1.0.1 digest_0.6.31        magrittr_2.0.3      
#>  [7] evaluate_0.20        fastmap_1.1.1        jsonlite_1.8.4       DBI_1.1.3            formatR_1.14         promises_1.2.0.1    
#> [13] BiocManager_1.30.20  httr_1.4.5           purrr_1.0.1          fansi_1.0.4          rapiclient_0.1.3     codetools_0.2-19    
#> [19] cli_3.6.0            shiny_1.7.4          rlang_1.0.6          futile.logger_1.4.3  ellipsis_0.3.2       withr_2.5.0         
#> [25] yaml_2.3.7           tools_4.3.0          parallel_4.3.0       httpuv_1.6.9         DT_0.27              lambda.r_1.2.4      
#> [31] curl_5.0.0           vctrs_0.5.2          R6_2.5.1             mime_0.12            lifecycle_1.0.3      htmlwidgets_1.6.1   
#> [37] miniUI_0.1.1.1       pkgconfig_2.0.3      pillar_1.8.1         later_1.3.0          glue_1.6.2           Rcpp_1.0.10         
#> [43] xfun_0.37            tibble_3.1.8         tidyselect_1.2.0     rstudioapi_0.14      knitr_1.42           xtable_1.8-4        
#> [49] htmltools_0.5.4      rmarkdown_2.20       compiler_4.3.0
```
