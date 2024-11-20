<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput> 
<cfset DNId = '__transaction_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#DNId#_all_delivery_note" url="modules/ajax/warehouse.cfm?cmd=getDeliveryNote" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="DeliveryNoteId" caption="##" field="DeliveryNoteId" sortable searchable/>
        <g:Column id="MRId" caption="MR ##" sortable/> 
        <g:Column id="Department" sortable/>         
        <g:Column id="DeliverTo" caption="Deliver to" />
        <g:Column id="Reference" caption="Ref."/>
        <g:Column id="Date"/> 
	</g:Columns>
    <g:Commands>
        <g:Command id="addDN" help="New Delivery Note" pin icon="plus-sign"/> 
    	<g:Command id="viewDN" icon="file" help="View Delivery Note"/>
        <g:Command id="printDN" icon="print" help="Print Delivery Note"/>        
    </g:Commands>
    
	<g:Event command="addDN">
    	<g:Window title="'New Delivery Note'" width="850px" height="460px" url="'modules/warehouse/transaction/delivery/save_delivery_note.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm value="Create DN"/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="viewDN">
    	<g:Window title="'View Delivery Note ' + d[0]" width="850px" height="460px" url="'modules/warehouse/transaction/delivery/view_delivery_note.cfm'"/>
    </g:Event>  
    
    <g:Event command="printDN">
    	<g:Window IsNewWindow url="'modules/warehouse/transaction/delivery/print_dn.cfm'"/>
    </g:Event>

</g:Grid> 
 
</cfoutput>
