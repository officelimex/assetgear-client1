<cfoutput>
<cfquery name="qPM">
#application.com.PMTask.PM_TASK_SQL#
WHERE DepartmentId =16 AND Unitid = 1
Order by Location,Frequency asc
</cfquery>

<table width="80%" style=" border:1px thick">
<tr>
	<th>Location</th><th>Asset</th>		<th>Task</th>	<th>Frequency</th>
</tr>
<cfloop query="qPM">
	<tr>
    	<td nowrap>#Location#</td>
    	<td nowrap>#Asset#</td>
    	<td>#Description#</td>
    	<td nowrap>#Frequency#</td>
    </tr>
</cfloop>
</table>
</cfoutput>