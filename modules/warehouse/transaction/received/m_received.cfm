<!--- 
	Author: Arowolo Abiodun
	Created: 2012/07/10
	Modified: 2012/07/10
	-> the grid template for material recieved into the warehouse 
--->
<cfoutput> 
<cfset IssID = '__transaction_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#IssID#_material_received" url="modules/ajax/warehouse.cfm?cmd=getMaterialReceived" commandWidth="70px" class="table-hover table-condensed"  firstsortOrder="DESC">
	<g:Columns>
		<g:Column id="MaterialReceivedId" caption="##" sortable searchable/>
        <g:Column id="MRId" Caption="MR ##" searchable field="r.MRId"/>
        <g:Column id="Reference" Caption="Reference" searchable field="m.Reference"/>        
        <g:Column id="ReceivedByUserId" caption="Received By" hide/> 
         <g:Column id="Date" caption="Date"/>
	</g:Columns>
    <g:Commands>
        <g:Command id="newMRV" help="Receive new Materials" pin icon="plus-sign"/>
        <g:Command id="printMRV" help="Print" icon="print"/>  
    </g:Commands>

	<g:Event command="newMRV">
    	<g:Window title="'Receive Material'" width="850px" height="440px" url="'modules/warehouse/transaction/received/save_m_received.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event> 
    
    <g:Event command="printMRV">
    	<g:Window IsNewWindow url="'modules/warehouse/transaction/received/print_m_received.cfm'"/>
    </g:Event>   

</g:Grid> 
 
</cfoutput>
