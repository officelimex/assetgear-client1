<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset whId = '__warehouse_setting_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="warehouse/unit_of_measurement.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">

    <div class="span2" style="position:fixed;">
        <n:Nav renderTo="#whId#">
        	  <n:NavItem title="Unit of Measurement" isactive url="modules/settings/warehouse/unit_of_measurement.cfm"  id="unit_of_measurement"/>
            <n:NavItem title="Shipment Mode" url="modules/settings/warehouse/shipment_mode.cfm" id="shipment_mode"/>
            <n:NavItem title="Shelf Location" url="modules/settings/warehouse/shelf_location.cfm" id="shelf_location"/>
        </n:Nav>
    </div>
    <div class="span10" style="float:right">
    	<div id="#whId#_grid">
        	<div class="sub_page unit_of_measurement" id="#whId#_unit_of_measurement"></div>
        </div>
    </div>


  </div>
</div>
</cfoutput>
