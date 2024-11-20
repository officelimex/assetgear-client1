<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset jobId = '__maintenance_setting_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#jobId#_job_class" url="modules/ajax/settings.cfm?cmd=getJobClass" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="JobClassId" caption="##" sortable searchable/>
        <g:Column id="Code" searchable />
        <g:Column id="Class" searchable />

	</g:Columns>
    <g:Commands>
        <g:Command id="addjobclass" help="New Job Class" pin icon="plus-sign"/> 
    	<g:Command id="editjobclass" text="edit" help="View Job Class" class=""/>
    </g:Commands>
    
    
	<g:Event command="addjobclass">
    	<g:Window title="'New Job Class'" width="550px" height="100px" url="'modules/settings/maintenance/save_job_class.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editjobclass">
    	<g:Window title="'Edit ""' + d[2] + '""' " width="550px" height="100px" url="'modules/settings/maintenance/save_job_class.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
