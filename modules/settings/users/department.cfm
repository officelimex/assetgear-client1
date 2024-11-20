<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset ursId = '__users_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#ursId#_department" url="modules/ajax/settings.cfm?cmd=getDepartments" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="DepartmentId" caption="##" field="DepartmentId" sortable searchable/>
        <g:Column id="Name" sortable searchable field="Name"/>
		<g:Column id="Email"/>
	</g:Columns>
    <g:Commands>
        <g:Command id="adddept" help="New Department" pin icon="plus-sign"/> 
    	<g:Command id="editdept" text="edit" help="View Department" class=""/>        
    </g:Commands>
    
    
	<g:Event command="adddept">
    	<g:Window title="'New Department'" width="550px" height="100px" url="'modules/settings/users/save_department.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editdept">
    	<g:Window title="'Edit'" width="550px" height="100px" url="'modules/settings/users/save_department.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
