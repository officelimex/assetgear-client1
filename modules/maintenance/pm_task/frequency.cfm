<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
---> 
<cfoutput> 
<cfset frqId = '__pm_task_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#frqId#_frequency" url="modules/ajax/maintenance.cfm?cmd=getFrequency" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="FrequencyId" caption="##" sortable searchable/>
        <g:Column id="Code" sortable searchable />
        <g:Column id="Description" />
        <g:Column id="Years" />
        <g:Column id="Quarters" />
        <g:Column id="Months" />
        <g:Column id="Weeks"  />
        <g:Column id="Days"  />
        <g:Column id="Hours" />
        <g:Column id="Minutes" />
	</g:Columns>
    <g:Commands>
        <g:Command id="addfrq" help="New Frequency" pin icon="plus-sign"/>
    	<g:Command id="editfrq" text="edit" help="View Frequency" class=""/>
    </g:Commands>
    
    
	<g:Event command="addfrq">
    	<g:Window title="'New Frequency'" width="850px" height="300px" url="'modules/maintenance/pm_task/save_frequency.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editfrq">
    	<g:Window title="'Edit ' + d[2] " width="850px" height="300px" url="'modules/maintenance/pm_task/save_frequency.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
