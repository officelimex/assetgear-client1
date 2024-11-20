<cfquery>
	UPDATE temp_data SET `Flag` = "d"
    WHERE TempDataId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>