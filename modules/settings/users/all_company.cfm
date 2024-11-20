<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset comId = '__users_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#comId#_all_company" url="modules/ajax/settings.cfm?cmd=getCompany" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="CompanyId" caption="##" field="CompanyId" sortable searchable/>
        <g:Column id="Name" searchable field="Name"/>
        <g:Column id="Description" />
        <g:Column id="Address" />
	</g:Columns>
    <g:Commands>
    	<g:Command id="add" pin icon="plus-sign" help="Add Company"/>
    	<g:Command id="editR" icon="pencil" help="Edit Company"/> 
    </g:Commands>

	<g:Event command="add">
    	<g:Window title="'New company'" width="650px" height="220px" url="'modules/settings/users/save_company.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editR">
    	<g:Window title="'Edit company ' + d[1]" width="650px" height="220px" url="'modules/settings/users/save_company.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>        

</g:Grid> 
 
</cfoutput>
