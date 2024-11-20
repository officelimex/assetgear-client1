<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset mrId = '__transaction_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#mrId#_all_mr" url="modules/ajax/warehouse.cfm?cmd=getMR&t=SI" commandWidth="75px" class="table-hover table-condensed"  firstsortOrder="DESC">
	<g:Columns>
		<g:Column id="MRId" caption="##" field="m.MRId" sortable searchable/>
        <g:Column id="WorkOrderId" caption="W.O. ##" searchable/>
        <g:Column id="Note" searchable field="m.Note"/>
        <g:Column id="DateIssued" caption="Date issued"/>        
        <g:Column id="TotalValue" caption="Total value" />
        <g:Column id="Status"/>
	</g:Columns>
    <g:Commands>
        <g:Command id="addMR" help="New MR" pin icon="plus-sign"/> 
    	<g:Command id="editMR" text="edit" help="Edit MR" class="btn btn-mini"/>
        <g:Command id="printMR" text="print" help="Print MR" class="btn btn-mini"/>        
    </g:Commands>
    
    
	<g:Event command="addMR">
    	<g:Window title="'New MR'" width="850px" height="440px" url="'modules/warehouse/transaction/save_mr.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editMR">
    	<g:Window title="'Edit material requisition ## '+d[0] " width="850px" height="440px" url="'modules/warehouse/transaction/save_mr.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>

    <g:Event command="printMR">
        <g:Window IsNewWindow url="'modules/warehouse/transaction/print_mr.cfm'"> 
        </g:Window>
    </g:Event> 

</g:Grid> 
 
</cfoutput>
