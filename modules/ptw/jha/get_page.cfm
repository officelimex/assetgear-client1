<cfparam name="url.id" default=""> 
<cfquery name="qWS">
	SELECT Status 
    FROM ptw_jha
    WHERE JHAId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>
 
<cfif qWS.Status eq "c"> 
	<cfinclude template="view_jha.cfm" />
<cfelse>
	<cfif request.IsHSE>
    	<cfinclude template="view_jha.cfm" />
    <cfelse>
		<cfinclude template="save_jha.cfm" />
    </cfif>
</cfif> 