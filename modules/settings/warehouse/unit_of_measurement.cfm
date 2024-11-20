<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput> 
<cfset umId = '__warehouse_setting_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#umId#_unit_of_measurement" url="modules/ajax/settings.cfm?cmd=getUnitOfMeasurement" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="UmId" caption="##" sortable searchable/>
        <g:Column id="Code" searchable />
        <g:Column id="Title" />
	</g:Columns>
    <g:Commands>
        <g:Command id="addum" help="New Unit of Measurement" pin icon="plus-sign"/> 
    	<g:Command id="editum" text="edit" help="View Unit of Measurement" class=""/>
    </g:Commands>
    
    
	<g:Event command="addum">
    	<g:Window title="'New Unit of Measurement'" width="550px" height="100px" url="'modules/settings/warehouse/save_unit_of_measurement.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/> 
        </g:Window>
    </g:Event>
    
	<g:Event command="editum">
    	<g:Window title="'Edit'" width="550px" height="100px" url="'modules/settings/warehouse/save_unit_of_measurement.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    

</g:Grid> 
 
</cfoutput>
