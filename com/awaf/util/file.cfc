<cfcomponent>
	
    <cffunction name="Init" access="public" returntype="File">
    	
        <cfreturn this/>
    </cffunction>
    
	<cffunction name="Move" access="public" returntype="void">
    	<cfargument name="table" type="string" required="yes">
        <cfargument name="pk" type="numeric" required="yes">
        <cfargument name="type" type="string" required="yes">
		<cfargument name="source" type="string" required="yes">
        <cfargument name="destination" type="string" required="yes">
        <cfargument name="createdby" type="numeric" required="yes" default="#request.userinfo.userid#"/>
 		
        <cfif DirectoryExists(arguments.source)>
            <cfdirectory action="list" name="qL" directory="#arguments.source#"/>
            <cfif qL.recordcount>
                <cfif !DirectoryExists(arguments.destination)>
                    <cfdirectory action="create" directory="#arguments.destination#"/>
                </cfif>
            </cfif>
            <cfloop query="qL">
                <cffile action="move" source="#qL.directory#\#ql.Name#" destination="#arguments.destination##ql.Name#" nameconflict="overwrite" />
                <cfquery>
                    INSERT INTO `file` SET
                    `File` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ql.Name#"/>,
                    `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pk#"/>,
                    `Size` = <cfqueryparam cfsqltype="cf_sql_bigint" value="#ql.Size#"/>,
                    `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.table#"/>,
                    `Type` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="1" value="#arguments.type#"/>,
                    `CreatedByUserId` = #arguments.createdby#
                </cfquery>
            </cfloop>
            <!--- delete temp directory --->
            <cfdirectory action="delete" directory="#arguments.source#"/>
        </cfif>
	</cffunction>

</cfcomponent>

