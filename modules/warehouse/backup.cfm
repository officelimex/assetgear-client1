<cfsetting requesttimeout="99999999"/>

<cfquery name="qData">
	SELECT `Id`, `FieldId`, `Table`, `Type` FROM ser_syn
    ORDER BY `Id` 
    LIMIT 0,100
</cfquery>

<cfif qData.recordcount>
<cfset io = createObject("webservice","http://#application.appName#.assetgear.net/WS/awaf/#application.appName#/ams/sync.cfc?wsdl")/>

<cfoutput>
<cfloop query="qData">#Table#<br/>
	<cfset iname = table/> 
    <cfif ListLen(table,'_') gt 0> 
        <cfif ListFindNoCase('core,ptw,whs',iname)>
        	<cfset iname = ListDeleteAt(table,1,'_')/>
        </cfif>
        <cfif table eq "pm_milestone"><cfset iname = "Milestone"/></cfif>
    </cfif>
    
	<cfset iname = replacenocase(iname,'_','','all')/> 
    <cfquery name="q">
        SELECT * FROM #table# WHERE `#iname#Id` = <cfqueryparam cfsqltype="cf_sql_integer" value="#FieldId#"/>
    </cfquery>    
	<cfif type eq "D">
    	<cfset io.DeleteItem("#iname#Id", FieldId, table)/>
    <cfelse>
    	<cfset evaluate("io.update#iname#(#FieldId#, q)")/>
    </cfif>
    <cfquery>
        DELETE FROM ser_syn WHERE Id = <cfqueryparam cfsqltype="cf_sql_integer" value="#Id#"/>
    </cfquery> 
</cfloop>
</cfoutput>
 
</cfif>