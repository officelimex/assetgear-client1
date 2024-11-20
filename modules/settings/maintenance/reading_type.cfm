<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset rdtId = '__maintenance_setting_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#rdtId#_reading_type" url="modules/ajax/settings.cfm?cmd=getReadingType" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ReadingTypeId" caption="##" sortable searchable/>
        <g:Column id="Code" searchable />
        <g:Column id="Type" searchable/>
	</g:Columns>
    
    <g:Commands>
        <g:Command id="addreadingtype" help="New Reading Type" pin icon="plus-sign"/> 
    	<g:Command id="editreadingtype" text="edit" help="View Reading Type" class=""/>
    </g:Commands>

    
	<g:Event command="addreadingtype">
    	<g:Window title="'New  Reading Type'" width="550px" height="100px" url="'modules/settings/maintenance/save_reading_type.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editreadingtype">
    	<g:Window title="'Edit ""' + d[2] + '"" ' " width="550px" height="100px" url="'modules/settings/maintenance/save_reading_type.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>

</g:Grid> 
 

</cfoutput>
