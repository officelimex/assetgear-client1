<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset fuel = '__fuel_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#fuel#_fuel_request" url="modules/ajax/warehouse.cfm?cmd=getFuelRequest" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="FuelRequestId" caption="##" sortable searchable />
        <g:Column id="Vehicle" searchable field="Description" />
        <g:Column id="DateLastIssued" caption="Last Issued"/>
        <g:Column id="Purpose" />
        <g:Column id="Qty" caption="Liters" />
        <g:Column id="IssuedBy" />
        <g:Column id="CollectedBy"  />
        <g:Column id="Date"  />
	</g:Columns>
    <g:Commands> 
    	<g:Command id="editfuelrequest" icon="pencil"/>
    	<g:Command id="viewfuelrequest" icon="file"/>
    </g:Commands>

    
    
	<g:Event command="editwarehitem">
    	<g:Window title="'Edit ""' + d[1] + '"" ' " width="900px" height="350px" url="'modules/warehouse/material/save_fuel_request.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>
	<g:Event command="viewwarehitem">
    	<g:Window title="'View Warehouse Item'" width="900px" height="350px" url="'modules/warehouse/material/view_fuel_request.cfm'" >
        </g:Window>
    </g:Event>

</g:Grid> 
 
 
</cfoutput>
