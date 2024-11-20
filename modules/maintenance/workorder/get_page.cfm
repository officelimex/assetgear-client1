<!---<cfthrow message="#url.id#">--->
<cfparam name="url.id" default=""> 
<cfparam name="url.other" default="false"> 
<cfif IsDefined("url.filter")>
	<cfset request.filter = url.filter/>
</cfif>
<cfquery name="qWS">
	SELECT Status 
    FROM work_order
    WHERE WorkOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfif qWS.Status eq "Close" || url.other == "true">
	<cfinclude template="view_workorder.cfm" />
<cfelse>
	<cfinclude template="save_workorder.cfm" />
</cfif>