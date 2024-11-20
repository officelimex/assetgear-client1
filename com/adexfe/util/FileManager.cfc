<cfcomponent>

	<cffunction name="init" access="public" returntype="FileManager">
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="UploadFile" access="public" returntype="string">
    	<cfargument name="FormField" type="any" required="yes">
        <cfargument name="Path" type="string" required="yes">
        
        <cfif Not DirectoryExists(arguments.Path)>
            <cflock type="exclusive" name="file" timeout="30">
                <cfdirectory action="create" directory="#arguments.Path#">
            </cflock> 
        </cfif>
        
        <cffile action="upload" filefield="#FormField#" destination="#arguments.Path#" nameconflict="overwrite">
        
        <cfset serFilePath = arguments.Path & cffile.serverFile> 		
        <cfset uuid = cffile.serverFile> 
		
        <cftry>
            <cfcatch type="any">
                <cflock type="exclusive" timeout="30" name="file">
                    <cffile action="delete" file="#serFilePath#" >
                </cflock>
            </cfcatch>
        </cftry>
        
        <cfreturn uuid>
        
    </cffunction>

</cfcomponent>