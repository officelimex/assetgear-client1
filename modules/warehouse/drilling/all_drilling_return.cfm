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

<cfset drId = '__drilling_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<g:Grid renderTo="#drId#_all_drilling_return#url.status##url.cid#" url="modules/ajax/maintenance.cfm?cmd=getDrillingReturns&cid=#url.cid#" commandWidth="70px" class="table-hover">
	<g:Columns>
		<g:Column id="DReturnedId" caption="##" field="DReturnedId" sortable searchable/>
        <g:Column id="Delivered By" nowrap="true" caption="Delivered By" field="ReturnBy" searchable/>
        <g:Column id="Delivered Date" nowrap="true" caption="Delivery Date" field="ReturnedDate"/>
        <g:Column id="Comment" caption="Comment" field="Comment"/>
        <g:Column id="No of Item(s)" field="RecordCount"/>
	</g:Columns>
    <g:Commands>
    	<g:Command id="editA" icon="pencil" help="Edit Return" />
    	<g:Command id="Print" icon="print" help="View Items Returned"/>
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Update '+d[1]+' Returned Item(s)'" width="870px" height="450px" url="'modules/warehouse/drilling/save_drilling_return.cfm?cid=#url.cid#'" id="">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Item.cfc?method=deleteDrillingReturnk'"/>
			<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="Print">
    	<g:Window title="'Drilling Item(s) Returned for ""' + d[0] + '""' " IsNewWindow  url="'modules/warehouse/drilling/print_drilling_return.cfm?'" />
    </g:Event>

</g:Grid>

</cfoutput>
