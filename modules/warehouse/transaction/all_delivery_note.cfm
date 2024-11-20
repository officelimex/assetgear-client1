<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput> 
<cfset DNId = '__transaction_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#DNId#_all_delivery_note" url="modules/ajax/warehouse.cfm?cmd=getDeliveryNote" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="DeliveryNoteID" caption="##" field="" sortable searchable/>
        <g:Column id="MRId" caption="Requisition ##" sortable/>
        <g:Column id="Destination" />
        <g:Column id="Date" />
        <g:Column id="ItemFrom" caption="Item From" />
        <g:Column id="ReceivedBy" caption="Received By" />
        <g:Column id="VerifiedBy" caption="Verified By" />
        <g:Column id="VehicleNo" caption="Vehicle ##"/>
	</g:Columns>
    <g:Commands>
        <g:Command id="addDN" help="New Delivery Note" pin icon="plus-sign"/> 
    	<g:Command id="editDN" text="edit" help="View Delivery Note" class=""/>
        
    </g:Commands>
    
    
	<g:Event command="addDN">
    	<g:Window title="'New Delivery Note'" width="850px" height="460px" url="'modules/warehouse/transaction/save_delivery_note.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editDN">
    	<g:Window title="'Edit Delivery Note' " width="850px" height="460px" url="'modules/warehouse/transaction/save_delivery_note.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
