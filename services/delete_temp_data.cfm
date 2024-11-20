<cfset yesterday =dateAdd("d", -1, now()) />
<cfquery>
	DELETE FROM `temp_data`
	WHERE `TimeCreated` < <cfqueryparam value="#yesterday#" cfsqltype="cf_sql_date"/> 
</cfquery>