
<cfset qPM = application.com.Permit.GetPermit(url.id)/>

<cfif qWS.Status eq "Close">
	<cfinclude template="view_workorder.cfm" />
<cfelse>
	<cfinclude template="save_workorder.cfm" />
</cfif>