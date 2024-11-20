<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput>

<!--- for department as category {url.cid}--->
<cfparam name="url.cid" default=""/>

<cfset PwId = '__permit_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#PwId#_unapproved_permit#url.cid#" url="modules/ajax/ptw.cfm?cmd=GetUnApprovedPermit" commandWidth="70px" class="table-hover" firstsortOrder="DESC">
    <g:Columns>
		<g:Column id="PermitId" caption="##" field="p.PermitId" sortable searchable />
        <g:Column id="JHAId" caption="JHA" searchable/> 
        <g:Column id="Work" caption="Work Description" field="wo.Description" searchable />
        <g:Column id="Date"/>
        <g:Column id="EndTime" caption="End Time"/>
        <g:Column id="StatusDescription" caption="Status"/>
        <g:Column id="Status" hide/>
	</g:Columns>
    <g:Commands>
        <g:Command id="editA" icon="edit" help="View Permit" condition="row[6]=='STPSTA'"/>
    	<g:Command id="Print" icon="print" help="Print Permit"/> 
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Permit ##'+d[0]" width="1000px" height="400px" url="'modules/ptw/permit/save_permit.cfm?cid=#url.cid#'" id="">        	
            <g:Button value="Send to Facility Supervisor" class="btn btn-success" icon="icon-share icon-white" executeURL="'modules/ajax/ptw.cfm?cmd=SendToPS&jhaid='+d[1]"/>
            <g:Button IsSave /> 
        </g:Window>
    </g:Event>     
	<g:Event command="Print">
    	<g:Window title="'Print Work Order For ""' + d[1] + '""' " IsNewWindow  url="'modules/ptw/permit/print_permit.cfm?cid=#url.cid#'"/>
    </g:Event>  
 
</g:Grid> 
 
</cfoutput>
