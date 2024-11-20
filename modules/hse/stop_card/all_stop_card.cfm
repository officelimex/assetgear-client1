<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>

<!--- for asset category {url.cid}--->
<cfparam name="url.cid" default=""/>
<cfparam name="url.filter" default=""/>

<cfset spCD = '__stop_card_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
<cfquery name="q">
	SELECT * from sop_card
</cfquery>
<g:Grid renderTo="#spCD#_all_stop_card#url.filter##url.cid#" url="modules/ajax/hse.cfm?cmd=getStopCard&cid=#url.cid#&filter=#url.filter#" commandWidth="70px" class="table-hover">

    <g:Columns>
		<g:Column id="SOPId" caption="##" field="sc.SOPId" sortable searchable/>
        <g:Column id="ActionType" caption="Action Type" field="sc.ActDetails" searchable/>
        <g:Column id="Observation" caption="Observation" field="sc.Observation" searchable/>
        <g:Column id="Date" nowrap="true" caption="Date" field="sc.SOPDate"/>
        <g:Column id="Observer" nowrap="true" caption="Observer" field="sc.Observer"/>
        <g:Column id="CreatedBy" nowrap="true" caption="CreatedBy" field="cu.CreatedBy" hide/>
        <g:Column id="Department" nowrap="true" caption="Department" field="cd.Department"/>
        <g:Column id="CreatedById" hide/>
	</g:Columns>
    <g:Commands>
    	<g:Command id="editA" icon="pencil" help="Edit Asset" condition="3=='#request.userinfo.departmentid#'||#request.IsHost#||d[7]=='request.userinfo.userid'"/>
    	<g:Command id="Print" icon="file" help="View Incident Report"/>
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Update '+d[1]" width="1070px" height="450px" url="'modules/hse/stop_card/save_stop_card.cfm?cid=#url.cid#'" id="">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Asset.cfc?method=deletesop'"/>
			<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="Print">
    	<g:Window title="'View SOP Card ' + '""' "  width="870px" height="450px"  url="'modules/hse/stop_card/view_sop.cfm?'" />
    </g:Event>

</g:Grid>

</cfoutput>
