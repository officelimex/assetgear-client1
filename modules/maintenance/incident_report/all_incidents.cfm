<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>

<!--- for asset category {url.cid}--->
<cfparam name="url.cid" default=""/>
<cfparam name="url.status" default=""/>

<cfset icId = '__incident_report_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<g:Grid renderTo="#icId#_all_incidents#url.status##url.cid#" url="modules/ajax/maintenance.cfm?cmd=getIncidentReports&cid=#url.cid#" commandWidth="70px" class="table-hover">
	<g:Columns>
		<g:Column id="IncidentId" caption="##" field="ic.IncidentId" sortable searchable/>
        <g:Column id="Title" caption="Title" field="ic.Title" searchable/>
        <g:Column id="Description" caption="Description" field="ic.Description" searchable/>
        <g:Column id="ReportDate" caption="Date" field="ic.ReportTime"/>
        <g:Column id="Department"/>
	</g:Columns>
    <g:Commands>
    	<g:Command id="editA" icon="pencil" help="Edit Asset" condition="16=='#request.userinfo.departmentid#'||#request.IsHost#"/>
    	<g:Command id="viewA" icon="file" help="View Asset"/>
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Update '+d[1]" width="1070px" height="450px" url="'modules/maintenance/incident_report/save_incident.cfm?cid=#url.cid#'" id="">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Asset.cfc?method=deleteIncident'"/>
			<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="viewA">
    	<g:Window title="d[1]" width="850px" height="400px" url="'modules/maintenance/asset/print_incident.cfm?cid=#url.cid#'" id="_" >
        	<!---g:Button value="Edit" /--->
        </g:Window>
    </g:Event>

</g:Grid>

</cfoutput>
