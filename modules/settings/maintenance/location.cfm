<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset setId = '__maintenance_setting_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#setId#_location" url="modules/ajax/settings.cfm?cmd=getLocation" pagesize="100" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="LocationId" caption="##" sortable searchable/>
    <g:Column id="Name" sortable searchable/>
	</g:Columns>
    
	<g:Commands>
		<g:Command id="addlocation" help="New Location" pin icon="plus-sign"/> 
		<g:Command id="editlocation" text="edit" help="View Location" class="btn btn-mini btn-info"/>
	</g:Commands>

    
	<g:Event command="addlocation">
		<g:Window title="'New Location'" width="550px" height="180px" url="'modules/settings/maintenance/save_location.cfm'" IdFromGrid="">
			<g:Button IsSave IsNewForm/> 
		</g:Window>
  </g:Event>
    
	<g:Event command="editlocation">
		<g:Window title="'Edit ""' + d[1] + '"" ' " width="650px" height="180px" url="'modules/settings/maintenance/save_location.cfm'">
			<g:Button IsSave /> 
		</g:Window>
  </g:Event>

</g:Grid> 
 

</cfoutput>
