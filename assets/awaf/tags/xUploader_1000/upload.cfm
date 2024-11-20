<!---cfset headerData = getHTTPRequestData().headers />  
<cfset content = getHTTPRequestData().content /---> 
<cfset cpath = expandPath("temp/")/>
<cfset n_cpath = cpath & url.tempfolder & "/"/>

<cfif !directoryExists(n_cpath)>
	<cfdirectory action="create" directory="#n_cpath#" />
</cfif> 

<!---cfset filePath = n_cpath & headerData.X_FILE_NAME />  
<cfset fileWrite(filePath,content) /--->  


<cffile action="upload" destination="#n_cpath#" filefield="data" nameconflict="overwrite" mode="777"/>
