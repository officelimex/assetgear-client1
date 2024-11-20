<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset spId = '__sparepart_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#spId#_spare_part_item" url="modules/ajax/warehouse.cfm?cmd=getWarehouseItem" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ItemId" caption="##" sortable searchable />
        <g:Column id="Code" searchable field="whi.Code" sortable/>
        <g:Column id="Description" searchable field="whi.Description" sortable template="row[2]+' <small>'+row[3]+'</small>'"/>
        <g:Column id="VPN" searchable hide/>
        <g:Column id="QOH"/>
        <g:Column id="QOR"/>
        <g:Column id="MinimumInStore" caption="Order Lv"/>
        <g:Column id="UnitPrice" caption="Unit Price" hide />
        <g:Column id="Location" field="sl.Code"/>
        <g:Column id="Obsolete"/>
        <g:Column id="AssetCategoryid" hide />
        <g:Column id="UMId" hide />
        <g:Column id="ShelfLocationId" hide />
        <g:Column id="DepartmentId" hide />
	</g:Columns>
    <g:Commands>
    	<g:Command id="viewA" icon="file" help="View Spare Part"/>
    </g:Commands>

	<g:Event command="viewA">
    	<g:Window title="'View ""' + d[1] + '"" ' " width="900px" height="350px" url="'modules/maintenance/spare_part/view_spare_part_item.cfm'"/>
    </g:Event>
</g:Grid>  
</cfoutput>