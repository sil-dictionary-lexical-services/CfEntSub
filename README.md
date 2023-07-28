# CfEntSub - Compare Entry and Subentries
This repo has an opl script to display all entries and subentries in a summary form that makes it easy to compare them. This facilitates checking for duplicates and near duplicates within entries and sub-entries.

## Why run this script?
The information in a complex form may be contained in its own entry and duplicated its components' entries as sub-entries. This script will gather pertinent fields from the various places, format the information, find exact duplicates and display similar ones together.

## An Example
Here is an example taken from Nahuatl Mecayapan (Ethnologue code *nhx*). It uses an non-MDF set of markers. Here is a list of the markers that will be compared (equivalent MDF markers are in parentheses):
 - \\w Lexeme - record marker (\\lx)
 - \\p Part of Speech Spanish (\\ps)
 - \\d Spanish gloss (\\gr)
 - \\ew English gloss (\\ge)
 - \\ewx English gloss (\\ge)
 - \\s Sub-entry (\\se)
 - \\sd Sub-entry Gloss Spanish
 - \\sdex Sub-entry Gloss English
 - \\sp Sub-entry Part of Speech

For comparison purposes, the following will be grouped together:
 - Lexemes (\\w and \\s) will be labelled **LEX:**
 - Parts of Speech (\\p and \\sp) will be labelled **POS:**
 - Spanish glosses (\\d and \\sd) will be labelled **DEF:**
 - English glosses (\\ew,\\ewx \\sdex) will be labelled **EDF:**

The complex form *a̱mapowa*, 'to read' has components *a̱maꞌ*, 'paper' and *kipowa*, 'to tell a story'.
*a̱mapowa*, has its own main entry and also appears as a sub-entry under *a̱maꞌ* and *kipowa*. An extract of the relevant entries from the Nahuatl Mecayapan SFM database is contained in *Example/nhx-extract.sfm*.

When the *CfEntSub.pl* script processes *Example/nhx-extract.sfm*, with the requisite options and the *nhx.ini* file, like this:
````bash
 ./CfEntSub.pl --inifile Example/nhx.ini Example/nhx-extract.sfm > Example/EntsSubs.txt
````
 It produces:
````text
      2 LEX:a̱mapowa#POS:v. i#DEF:leer#\EDF:read
      1 LEX:a̱mapowa#POS:v. i#DEF:leer#\EDF:to read#\EDF:read
      1 LEX:kipowa#POS:v. t#DEF:relatar#DEF:contar (cuentos)#\EDF:tell (a story)
      1 LEX:a̱maꞌ#POS:s#DEF:higuera#\EDF:tropical fig tree (ficus)#DEF:amate#DEF:papel#\EDF:paper
````
This result shows that *a̱mapowa* appears in three entries and sub-entries. In two of them it has one English definition 'read' in the other it has two English definitions, 'to read' and 'read'.

## Finding Duplicates and Near Duplicates
You will want to review entries/sub-entries that are duplicates of each other, whether exact duplicates or near duplicates. If you send the output of the script to a file, e.g., *Example/EntsSubs.txt*, exact duplicates will occur in that file with a leading count of 2 or more. Near duplicates will occur in that file more than once. Here are two bash commands to make additional files that have the duplicates and near duplicates:
````bash
egrep '[2-9] LEX:' EntsSubs.txt > dupes.txt
egrep -o 'LEX:[^#]*'  EntsSubs.txt | uniq -dc >neardupes.txt
````

 An editor (like *Notepad++*) displays all the occurences of a search in multiple files. You can search in the files to find the duplicates and near duplicates to find the needed changes to the entry and sub-entries.

## The *INI* file
The script looks for an *INI* file to control the information included in the summary lines. By default, the *INI* file has the same name as the script with a *.ini* extension. If you want to use a different name, add the `--inifile name.ini` option on the command line.

### The Record marker and Subentry markers
The Record marker and Subentry markers fields control where the information for an entry or subentry starts and ends. If you have more than one subentry marker, enter them in a comma separated list.
### Label# and Fields# pairs
The *INI* file determines which fields are included in the summary and how they are labelled. Fields that mean the same thing but are marked differently in an entry and a sub-entry should joined together in a list. 

For example, you might use *\\ps* marker to indicate the part of speech in an entry and use *\\ps_SE* in a sub-entry. Here is how you could indicate that:
````ini
Label2=POS:
Fields2=ps,ps_SE
````
### Other notes about the *INI* file
 - You need a *\[CfEntSub\]* section header at the top.
 - Enter multiple SFM markers in a comma separated list.
 - You will probably want to include at least Lexeme, Part of Speech and Definition/Gloss fields.
 - A sample *CfEntSub.ini* file that uses MDF markers is included.

## Bugs and Enhancements
 - The script uses the perl default sort order, not the *LDML* sort order. 
	- **TODO**: give a recipe to move the count to the end of the line, sort using ldmlsort and move the count back to the front.
 - The fields are not re-ordered.
