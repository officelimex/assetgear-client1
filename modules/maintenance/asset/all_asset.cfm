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
<cfparam name="url.cl" default=""/>

<cfset astId = '__asset_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<g:Grid renderTo="#astId#_all_asset#url.status##url.cid##url.cl#" url="modules/ajax/maintenance.cfm?cmd=getAllAsset&cid=#url.cid#&status=#url.status#&cl=#url.cl#" commandWidth="70px" class="table-hover">
	<g:Columns>
		<g:Column id="AssetId" caption="##" field="a.AssetId" sortable searchable/>
        <g:Column id="Description" caption="Asset" field="a.Description" searchable/>
        <g:Column id="AssetCategory" caption="Category" field="ac.Name" searchable/>
        <g:Column id="Location" caption="Locations"/>
        <g:Column id="Status"/>
	</g:Columns>
    <g:Commands>
    	<!--- <g:Command id="viewReport" help="Print Users Report" text="Batch Update" pin icon=""/> --->
			<g:Command id="editA" icon="pencil" help="Edit Asset" condition="16=='#request.userinfo.departmentid#'||#request.IsHost#"/>
    	<g:Command id="viewA" icon="file" help="View Asset"/>
    </g:Commands>
	
	<!--- <g:Event command="viewReport">
		<g:Window title="'Quick Asset Update'" isNewWindow width="490px" height="120px" url="'modules/maintenance/asset/assetupdate.cfm'" id="">
			<g:Button   />
		</g:Window>
	</g:Event> --->

	<g:Event command="editA">
    	<g:Window title="'Update '+d[1]" width="870px" height="450px" url="'modules/maintenance/asset/save_asset.cfm?cid=#url.cid#'" id="">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Asset.cfc?method=deleteAsset'"/>
			<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="viewA">
    	<g:Window title="d[1]" width="850px" height="400px" url="'modules/maintenance/asset/view_asset.cfm?cid=#url.cid#'" id="_" >
        	<!---g:Button value="Edit" /--->
        </g:Window>
    </g:Event>

</g:Grid>

</cfoutput>
