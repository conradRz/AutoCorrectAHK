# AutoCorrectAHK

auto correct for MS Windows in AHK

<em>Win+A</em>
![](readmePics/toAddNewCorrection.png)

Otherwise no GUI

;------------------------------------------------------------------------------
; CHANGELOG:
;
;
; May 25 2021: Most frequent duplicate word pairs added
;
; May 02 2021: Balabolka software shortcut for disabling/enabling audio readout of clipboard now global across all software
;
; May 24 2020: Date and time shortcuts from the Excel software added. Now Ctrl+; inserts current date
; and Ctrl+Shift+; inserts current time globally. It doesn't cause problem when used in Excel
;
; April 05 2020: https://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings/For_machines#The_Machine-Readable_List
; added
;
; March 27 2020: Created a list of permutation out of 10000 most popular English words
; by shifting all possible combinations of letters which are next to
; eachother. That created 41417 permutations.
;
; Nov 15 2019: Added my own common misspellings, added 1000 popular names, that
; is 1000 for each gender, added list of languages, list of
; countires and cities above 15,000 inhabitants (22793 cities).
; - Added a "to do" section.
; - Changed shortcut to Win-A , as it's more ergonomic.
; Author: Conrad R.
; - Don't try to add a list of surnames as they often are used as
; a normal noun too.
; - Some names such as "Will", are removed, due to it being a verb
; too.
; - Do remember that you can make particular hotstrings context
; sensitive.
;
; Sep 13 2007: Added more misspellings.
; Added fix for -ign -> -ing that ignores words like "sign".
; Added word beginnings/endings sections to cover more options.
; Added auto-accents section for words like fiancée, naïve, etc.
; Taken over by https://github.com/conradOU
; Feb 28 2007: Added other common misspellings based on MS Word AutoCorrect.
; Added optional auto-correction of 2 consecutive capital letters.
; Sep 24 2006: Initial release by Jim Biancolo (http://www.biancolo.com)
;
; INTRODUCTION
;
; This is an AutoHotKey script that implements AutoCorrect against several
; "Lists of common misspellings":
;
; This does not replace a proper spellchecker such as in Firefox, Word, etc.
; It is usually better to have uncertain typos highlighted by a spellchecker
; than to "correct" them incorrectly so that they are no longer even caught by
; a spellchecker: it is not the job of an autocorrector to correct _all_
; misspellings, but only those which are very obviously incorrect.
;
; From a suggestion by Tara Gibb, you can add your own corrections to any
; highlighted word by hitting Win+A. These will be added to a separate file,
; so that you can safely update this file without overwriting your changes.
;
; Some entries have more than one possible resolution (achive->achieve/archive)
; or are clearly a matter of deliberate personal writing style (wanna, colour)
;
; These have been placed at the end of this file and commented out, so you can
; easily edit and add them back in as you like, tailored to your preferences.
;
; SOURCES
;
; http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings
; http://en.wikipedia.org/wiki/Wikipedia:Typo
; https://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings/Repetitions#Most_frequent_duplicate_word_pairs
; Microsoft Office autocorrect list
; Script by jaco0646 http://www.autohotkey.com/forum/topic8057.html
; OpenOffice autocorrect list
; TextTrust press release
; User suggestions.
;------------------------------------------------------------------------------
