<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset ursId = '__users_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 <cfdump var="#ursId#">
<g:Grid renderTo="#ursId#_unit" url="modules/ajax/settings.cfm?cmd=getUnits" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="UnitId" caption="##" field="cu.UnitId" sortable searchable/>
        <g:Column id="Department" field="cu.Name" searchable/>
        <g:Column id="Name" field="cd.Name" sortable searchable />
        <g:Column id="DepartmentId" hide />
	</g:Columns>
    <g:Commands>
    	<g:Command id="addunit" help="New Unit" pin icon="plus-sign"/> 
        <g:Command id="editR" text="edit" help="View Unit" class=""/> 
    </g:Commands>
    
	<g:Event command="addunit">
    	<g:Window title="'New Unit'" width="550px" height="100px" url="'modules/settings/users/save_unit.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
    <g:Event command="editR">
    	<g:Window title="'Edit ""' + d[1] + '""' " width="550px" height="100px" url="'modules/settings/users/save_unit.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
