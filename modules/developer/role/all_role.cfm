<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset devId = '__role_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#devId#_all_role" url="modules/ajax/developer.cfm?cmd=Role_PrivilegeGrid">
	<g:Columns>
		<g:Column id="RoleId" caption="##"/>
        <g:Column id="Title" caption="Role" searchable sortable template = "row[1]+'<br/>'+row[2]"/>
        <g:Column id="Description" hide/> 
        <g:Column id="Pages"/> 
	</g:Columns>
    <g:Commands>
    	<g:Command id="editR" icon="pencil" text="Role"/>
        <g:Command id="editP" icon="pencil" text="Privilege"/> 
    </g:Commands>
    
	<g:Event command="editR">
    	<g:Window title="'Edit ' + d[1] + ' Role'" width="500px" height="140px" url="'modules/developer/role/w_role.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    
    <g:Event command="editP">    
    	<g:Window title="'Update Privileges for ' + d[1]" width="700px" height="400px" url="'modules/developer/role/w_privilege.cfm'" Id="_"/>
    </g:Event>

</g:Grid>
 
</cfoutput>
