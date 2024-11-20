<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset spmId = '__warehouse_setting_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#spmId#_shipment_mode" url="modules/ajax/settings.cfm?cmd=getShipmentMode" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ShipmentModeId" caption="##" sortable searchable/>
        <g:Column id="Mode" searchable />
        <g:Column id="Days"/>
	</g:Columns>
    <g:Commands>
        <g:Command id="addshm" help="New Shipment Mode" pin icon="plus-sign"/> 
    	<g:Command id="editshm" text="edit" help="View Shipment Mode" class=""/>
    </g:Commands>
    
    
	<g:Event command="addshm">
    	<g:Window title="'New Shipment Mode'" width="550px" height="100px" url="'modules/settings/warehouse/save_shipment_mode.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editshm">
    	<g:Window title="'Edit'" width="550px" height="100px" url="'modules/settings/warehouse/save_shipment_mode.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
