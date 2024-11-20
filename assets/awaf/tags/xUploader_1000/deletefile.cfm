<cfset cpath = expandPath("temp/")/>
<cfset n_cpath = cpath & url.tempfolder & "/" & url.filename/>
<cffile action="delete" file="#n_cpath#" />