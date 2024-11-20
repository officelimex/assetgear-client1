<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset RetuId = '__transaction_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#RetuId#_material_returned" url="modules/ajax/warehouse.cfm?cmd=getMaterialreturn" commandWidth="70px" class="table-hover table-condensed" firstsortOrder="DESC">
	<g:Columns>
		<g:Column id="ReturnID" caption="##" field="wr.ReturnId" sortable searchable/>
        <g:Column id="Note" Caption="Note" field="wr.Note" searchable/>
        <g:Column id="Department" field="cd.`Name`"  searchable/>
        <g:Column id="Date"  />
        <g:Column id="Datereturned" caption="Date Returned" />
        <g:Column id="ReturnedBy" caption="Returned By" />
        <g:Column id="ReturnedTo" caption="Returned To" hide />

	</g:Columns>
    <g:Commands>
        <g:Command id="addreturn" help="New Material Returned" pin icon="plus-sign"/> 
    	<g:Command id="viewReturn" icon="file" help="View Material Returned" />
        <!---<g:Command id="printReturn" icon="print" help="Print Material Return"/>--->
    </g:Commands>
    
    
	<g:Event command="addreturn">
    	<g:Window title="'New Material Returned'" width="850px" height="440px" url="'modules/warehouse/transaction/return/save_material_returned.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="viewReturn">
    	<g:Window title="'View return items'" width="850px" height="440px" url="'modules/warehouse/transaction/return/view_material_returned.cfm'"/>
    </g:Event>  
      
	<!---<g:Event command="printReturn">
    	<g:Window title="'Edit '" width="850px" height="440px" url="'modules/warehouse/transaction/return/print_material_return.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>  --->  

</g:Grid> 
 
</cfoutput>
