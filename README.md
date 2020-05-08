# legisTaiwan: An Interface to Access Taiwan Legislative Database <img src="https://github.com/yl17124/legisTaiwan/blob/master/images/hexsticker_tw.png"  width="160" align="right" /> <br /> 



<p align="right">
  <img width="right" height="150" src="https://github.com/yl17124/legisTaiwan/blob/master/images/hexsticker_tw.png">
</p>



# legislatoR: Interface to the Comparative <img src="images/sticker.jpg" width="160" align="right" /> <br /> Legislators Database

[![Travis-CI Build Status](https://travis-ci.org/saschagobel/legislatoR.svg?branch=master)](https://travis-ci.org/saschagobel/legislatoR)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/legislatoR)](https://cran.r-project.org/package=legislatoR)
[![GitHub release version](https://img.shields.io/github/release/saschagobel/legislatoR.svg?style=flat)](https://github.com/saschagobel/legislatoR/releases)

legislatoR is a package for the software environment R that facilitates access to the Comparative Legislators Database (CLD). The CLD includes political, sociodemographic, career, online presence, public attention, and visual information for over 45,000 contemporary and historical politicians from ten countries.

## Content and data structure
The CLD covers the following countries and time periods:

| Country                              | Legislative sessions        | Politicians (unique) | Integrated with    |
| ------------------------------------ | --------------------------- | -------------------- | ------------------ |
| Austria (Nationalrat)                | all 27<br /> (1920-2019)    | 1,923                | [ParlSpeech V2](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/L4OAKN) (Rauh/Schwalbach 2020)      |
| Canada (House of Commons)            | all 43<br /> (1867-2019)    | 4,515                |                    |
| Czech Republic (Poslanecka Snemovna) | all 8<br /> (1992-2017)     | 1,020                | [ParlSpeech V1](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/E4RSP9) (Rauh et al. 2017)          |
| France (Assemblée)                   | all 15<br /> (1958-2017)    | 3,933                |                    |
| Germany (Bundestag)                  | all 19<br /> (1949-2017)    | 4,075                | [BTVote data](https://dataverse.harvard.edu/dataverse/btvote) (Bergmann et al. 2018),<br /> [ParlSpeech V1](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/E4RSP9) (Rauh et al. 2017),<br /> [Reelection Prospects data](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/EBEDPI) (Stoffel/Sieberer 2017)   |
| Ireland (Dail)                       | all 33<br /> (1918-2020)          | 1,408                |	[Database of Parliamentary Speeches in Ireland](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/6MZN76) (Herzog/Mikhaylov 2017)	|
| Scotland (Parliament)                | all 5<br /> (1999-2016)           | 305                  |       			 |
| Spain (Congreso de los Diputados)    | all 14<br /> (1979-2019)          | 2634           | [ParlSpeech V2](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/L4OAKN) (Rauh/Schwalbach 2020)      |        
| United Kingdom (House of Commons)    | all 58<br /> (1801-2019)          | 13,215               | [EggersSpirling data](https://github.com/ArthurSpirling/EggersSpirlingDatabase) (starting from <br /> 38th session, Eggers/Spirling 2014),<br /> [ParlSpeech V1](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/E4RSP9) (Rauh et al. 2017) | 
| United States (House and Senate)     | all 116<br /> (1789-2019)         | 12,512               | [Voteview data](https://voteview.com/data) (Lewis et al. 2019), <br /> [Congressional Bills Project data](http://www.congressionalbills.org/) (Adler/Wilkserson 2018) |
| **10**                                | **338**                     | **45,540**           | **11** 		       |
