# CompareEntrySubentries
This repo has an opl script to display all entries and subentries in a format that makes for easy comparison to check for duplicates and near duplicates within entries and sub-entries.

## Why run this script
The information in a complex form may be contained in its own entry and duplicated its components' entries as sub-entries. This script will gather the information from the various places, find exact duplicates and display similar entries/sub-entries together. 

## An Example
Here is an example taken from Nahuatl Mecayapan. It uses an non-MDF set of markers. Here is a list of the markers that will be compared (MDF equivalent):
 - \\w Lexeme -  record marker (\\lx)
 - \\p Part of Speech Spanish (\\ps)
 - \\d Spanish gloss (\\gr)
 - \\ew English gloss (\\ge)
 - \\ewx English gloss (\\ge)
 - \\s Sub-entry (\\se)
 - \\sd Sub-entry Gloss Spanish
 - \\sdex Sub-entry Gloss English
 - \\sp Sub-entry Part of Speech
 

The complex form *a̱mapowa*, 'to read' has components *a̱maꞌ*, 'paper' and *kipowa*, 'to tell a story'.
*a̱mapowa*, has its own main entry and also appears as a sub-entry  under  *a̱maꞌ* and *kipowa*. Here is an extract of the Nahuatl Mecayapan SFM lexical file:

````SFM
\w a̱mapowa
\p v. i
\edtn 1
\d leer
\ew to read
\ew read
\r a̱maꞌ, kipowa
\dt 21/Oct/2003

\w a̱maꞌ
\edtn 1
\p s
\# 1
\d higuera
\ewx tropical fig tree (ficus)
\d amate
\# 2
\d papel
\ewx paper
\s a̱mapowa
\sp v. i
\sd leer
\sdex read
\dt 21/Oct/2003

\w kipowa
\edtn 1
\p v. t
\d relatar
\d contar (cuentos)
\ew tell (a story)
\g fut.: quipohuas

\s a̱mapowa
\sp v. i
\sd leer
\sdex read

\cm . . . other kipowa sub-entries are not included here
\dt 05/Aug/1999
````

The *Cmp-en-se.pl* script, with the requisite options and *.ini* file produces :

````text
      2 LEX:a̱mapowa@POS:v. i@DEF:leer@\EDF:read
      1 LEX:a̱mapowa@POS:v. i@DEF:leer@\EDF:to read@\EDF:read
      1 LEX:kipowa@POS:v. t@DEF:relatar@DEF:contar (cuentos)@\EDF:tell (a story)
      1 LEX:a̱maꞌ@POS:s@DEF:higuera@\EDF:tropical fig tree (ficus)@DEF:amate@DEF:papel@\EDF:paper

````

## Bugs and Enhancements

