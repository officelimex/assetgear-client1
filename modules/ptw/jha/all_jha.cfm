<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput>

<!--- for frequency as category {url.cid}--->
<cfparam name="url.cid" default=""/>

<cfset JSId = '__jha_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
<cfset comW = "110"/>
<cfif request.IsHSE>
	<cfset comW = "80"/>
</cfif>
<g:Grid renderTo="#JSId#_all_jha" url="modules/ajax/ptw.cfm?cmd=getJHAByUsers" commandWidth="#comW#px" class="table-hover" firstsortOrder="DESC">
    <g:Columns>
		<g:Column id="JHAId" caption="##" field="j.JHAId" sortable searchable /> 
        <g:Column id="WorkDescription" caption="Job Description" field="wo.Description" searchable />
        <g:Column id="Equipment" caption="EquipmentToUse" />
        <g:Column id="Date" nowrap/>
        <g:Column id="PreparedBy" caption="Prepared by" nowrap/>
        <g:Column id="ReviewedBy" hide/>
        <g:Column id="StatusDescription" caption="Status"/>
        <g:Column id="Status" hide/>
        <g:Column id="DepartmentId" hide/>
	</g:Columns>
    <g:Commands>
    	<cfif !request.IsHSE>
        	<g:Command id="duplicateJHA" icon="tags" help="Duplicate JHA"/>
        </cfif>
        <g:Command id="editJHA" icon="pencil" help="Edit JHA" condition="row[7]=='o' && row[8]==#request.userinfo.departmentid#" />
        <g:Command id="viewJHA" icon="file" help="View JHA" condition="row[7]=='c'"/>
    	<g:Command id="PrintJHA" icon="print" help="Print JHA"/> 
    </g:Commands>
	<cfif !request.IsHSE>
        <g:Event command="duplicateJHA">
            <g:Window title="'Duplicate JHA ## '+d[0]" width="1050px" height="430px" url="'modules/ptw/jha/duplicate.cfm?cid=#url.cid#'" id="">                
            	<g:Button IsSave value="Duplicate" />                
            </g:Window>
        </g:Event>
    </cfif>
    
	<g:Event command="viewJHA">
    	<g:Window title="'JHA ## '+d[0]" width="1050px" height="430px" url="'modules/ptw/jha/view_jha.cfm?cid=#url.cid#'" id=""/>  
    </g:Event>
    
	<g:Event command="editJHA">
    	<g:Window title="'JHA ## '+d[0]" width="1050px" height="430px" url="'modules/ptw/jha/save_jha.cfm?cid=#url.cid#'" id="">
        	<cfif request.IsHSE>
            	<g:Button value="Reject" icon="icon-off icon-white" executeURL="'modules/ajax/ptw.cfm?cmd=RejectJHA'"/>
                <g:Button value="Approve" executeURL="'modules/ajax/ptw.cfm?cmd=ApproveJHA'" class="btn-success"/>
            <cfelse>
            	<g:Button IsSave />
            </cfif> 
        </g:Window>
    </g:Event>     
	<g:Event command="PrintJHA">
    	<g:Window title="'JHA ## ' + d[1]" IsNewWindow  url="'modules/ptw/jha/print_jha.cfm?cid=#url.cid#'" />
    </g:Event>  
<!---<cfdump var="#request.grid.columns.1#">--->
</g:Grid> 
 
</cfoutput>
