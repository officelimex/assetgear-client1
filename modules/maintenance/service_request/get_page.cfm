<!---<cfthrow message="#url.id#">
<cfparam name="url.id" default="">
<cfquery name="qWS">
	SELECT *
    FROM service_request
    WHERE ServiceRequestId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
</cfquery>

<cfif (qWS.Status eq "Close")>
	<cfinclude template="view_service_request.cfm" />
<cfelse>
	<cfinclude template="save_service_request.cfm" />
</cfif>--->