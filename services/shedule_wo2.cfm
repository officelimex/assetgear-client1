<cfquery name="q">
	SELECT
		pm.*,
		a.Description Asset, a.AssetId,
		f.Description Frequency,
		rt.Type ReadingType,
		CONCAT(l.Name, " ", IFNULL(al.LocDescription,"")) Location,
		u.Name Unit
	FROM
		pm_task pm
	INNER JOIN asset_location al ON al.AssetLocationId = pm.AssetLocationId
	INNER JOIN location l ON l.LocationId = al.LocationId
	INNER JOIN asset a ON a.AssetId = al.AssetId
	LEFT JOIN frequency f ON pm.FrequencyId = f.FrequencyId
	LEFT JOIN core_unit u ON pm.UnitId = u.UnitId
	LEFT JOIN reading_type rt ON pm.ReadingTypeId = rt.ReadingTypeId
	WHERE pm.IsActive = "yes" AND pm.UnitId = 4
	AND pm.StartTime IS NOT NULL
</cfquery>


<cfloop query="q">
	<cfquery name="q1">
		SELECT * FROM work_order WHERE PMTaskId = #PMTaskId# AND Status = "Open"
	</cfquery>
	<cfdump var="#q1#"/>
	<!---
	<cfif q1.RecordCount eq 0>
		<cfquery>
			INSERT INTO work_order SET WorkClassId = 10, JobFlag = 1, WorkingForId = 1, WorkDetails='#TaskDetails#',
			Description = '#Description#', AssetLocationIds = #AssetLocationId#, DepartmentId = #DepartmentId#,
			UnitId = #UnitId#, CreatedByUserId = 9, DateOpened = <cfqueryparam cfsqltype="cf_sql_date" value="#StartTime#"/>, 
			Status = 'Open', AssetId = #AssetId#
		</cfquery>
	</cfif>--->
</cfloop>


