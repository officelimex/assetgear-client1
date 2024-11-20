<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>
<cfset wrhou = '__material_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="material/warehouse_item.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">

    <div class="span2" style="position:fixed;">
        <n:Nav renderTo="#wrhou#">
        	<n:NavItem title="New Item" url="modules/warehouse/material/save_warehouse_item.cfm" id="save_warehouse_item"/>
            <n:navItem type="divider">
            <n:NavItem title="All Warehouse Items" isactive url="modules/warehouse/material/warehouse_item.cfm" id="warehouse_item"/>
            <n:NavItem title="Obsolate Warehouse Items" url="modules/warehouse/material/warehouse_item.cfm?ob=yes" id="warehouse_itemyes"/>
            <n:navItem type="divider">
            <n:NavItem title="Shelf Location" url="modules/warehouse/material/shelf_location.cfm" id="shelf_location"/>
            <n:navItem type="divider">
            <n:NavItem type="header" title="Reports"/>
            <n:NavItem type="new window" title="Month End Report" url="modules/warehouse/material/print_month_end.cfm"/>
            <n:NavItem title="Bin Location" url="modules/settings/warehouse/shelf_location.cfm" id="shelf_location"/>
            <n:NavItem title="Count due list" url="modules/settings/warehouse/shelf_location.cfm" id="shelf_location"/>
            <n:NavItem type="new window" title="Inventory List Report" url="modules/warehouse/transaction/report/print_all_item.cfm"/>
        </n:Nav>
    </div>
    <div class="span10" style="float:right">
    	<div id="#wrhou#_grid">
        	<div class="sub_page warehouse_item" id="#wrhou#_warehouse_item"></div>
        </div>
    </div>

  </div>
</div>
</cfoutput>
