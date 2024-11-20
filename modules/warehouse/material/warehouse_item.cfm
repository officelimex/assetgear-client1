<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>
<cfset wrhou = '__material_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
<cfparam name="url.ob" default="">


<g:Grid renderTo="#wrhou#_warehouse_item#url.ob#" url="modules/ajax/warehouse.cfm?cmd=getWarehouseItem&ob=#url.ob#" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ItemId" caption="##" sortable searchable />
        <g:Column id="Code" searchable field="whi.Code" sortable/>
        <g:Column id="Description" searchable field="whi.Description" sortable template="row[2]+' <small>'+row[3]+'</small>'"/>
        <g:Column id="VPN" searchable hide/>
        <g:Column id="QOH"/>
        <g:Column id="QOR"/>
        <g:Column id="MinimumInStore" caption="Order Lv"/>
        <g:Column id="UnitPrice" caption="Unit Price" />
        <g:Column id="Location" field="sl.Code"/>
        <g:Column id="Obsolete"/>
        <g:Column id="AssetCategoryid" hide />
        <g:Column id="UMId" hide />
        <g:Column id="ShelfLocationId" hide />
        <g:Column id="DepartmentId" hide />
	</g:Columns>
    <g:Commands>
    	<g:Command id="editItem" icon="pencil"/>
    	<g:Command id="viewItem" icon="file"/>
		<g:Command id="adjustItem" icon="indent-right" help="Inventory Correction"/>
    </g:Commands>

	<g:Event command="editItem">
    	<g:Window title="'Edit ""' + d[1] + '"" ' " width="900px" height="435px" url="'modules/warehouse/material/save_warehouse_item.cfm'">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/Warehouse.cfc?method=deleteItem'"/>
        	<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="viewItem">
    	<g:Window title="'View Warehouse Item'" width="900px" height="350px" url="'modules/warehouse/material/view_warehouse_item.cfm'">
        </g:Window>
    </g:Event>
	<g:Event command="adjustItem">
    	<g:Window title="'Inventory Correction on ' + d[1]" width="900px" height="310px" url="'modules/warehouse/material/inv_correction.cfm'">
        	<g:Button value="Correct Item" IsSave />
        </g:Window>
    </g:Event>
</g:Grid>


</cfoutput>
