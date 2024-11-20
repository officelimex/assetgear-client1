<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput>

<!--- for frequency as category {url.cid}---> 

<cfset PwId = '__permit_c'/>
<cfimport taglib="../../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#PwId#_revalidate_permit" url="modules/ajax/ptw.cfm?cmd=getPermitToRevalidate" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
    <g:Columns>
		<g:Column id="PermitId" caption="##" field="p.PermitId" sortable searchable/>
        <g:Column id="JHAId" caption="JHA" searchable hide /> 
        <g:Column id="Work" caption="Work Description" field="wo.Description" searchable/>
        <g:Column id="Date" />
        <g:Column id="EndTime" caption="End Time"/>
        <g:Column id="Status"/> 
	</g:Columns>
    <g:Commands>
        <g:Command id="editA" text = "Revalidate" help="View Permit"/>
    	<g:Command id="Print" icon="print" help="Print Permit"/> 
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Permit ##'+d[0]" width="1000px" height="400px" url="'modules/ptw/permit/ps/view_permit_rv.cfm'" id="">        	
            <g:Button value="Validate Permit" class="btn btn-success" icon="icon-eye-open icon-white" onClick="RevalidatePermit();"/>
            <!---g:Button IsSave/---> 
        </g:Window>
    </g:Event>     
	<g:Event command="Print">
    	<g:Window title="'Print Work Order For ""' + d[1] + '""' " IsNewWindow  url="'modules/ptw/permit/print_permit.cfm'"/>
    </g:Event>  
<!---<cfdump var="#request.grid.columns.1#">--->
</g:Grid> 
 
</cfoutput>
