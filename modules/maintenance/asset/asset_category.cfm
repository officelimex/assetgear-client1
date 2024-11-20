<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset astId = '__asset_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#astId#_asset_category" url="modules/ajax/maintenance.cfm?cmd=getAssetCategory" commandWidth="70px" class="table-hover table-condensed" pageSize="100">
	<g:Columns>
		<g:Column id="AssetCategoryId" caption="##" field="AssetCategoryId" sortable searchable/>
        <g:Column id="Name"/>
        <g:Column id="Category" caption=" "/>
        <g:Column id="SubCategory" caption=" "/>
	</g:Columns>
    <g:Commands> 
    	<g:Command id="addAssetC" help="New Asset Category" pin icon="plus-sign"/>
    	<g:Command id="editA" text="edit" help="Edit Asset Category" class=""/> 
    </g:Commands>
    
	<g:Event command="addAssetC">
    	<g:Window title="'New Asset Category'" width="550px" height="120px" url="'modules/maintenance/asset/save_asset_category.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
	<g:Event command="editA">
    	<g:Window title="'Edit Asset Category'" width="550px" height="120px" url="'modules/maintenance/asset/save_asset_category.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>   

</g:Grid> 
 
</cfoutput>
