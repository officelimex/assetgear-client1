<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>
<cfset shlId = '__material_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

<g:Grid renderTo="#shlId#_shelf_location" url="modules/ajax/settings.cfm?cmd=getShelfLocation" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="ShelfLocationId" caption="##" sortable searchable/>
        <g:Column id="Code" searchable  sortable />
	</g:Columns>
    <g:Commands>
        <g:Command id="addshl" help="New Shelf Location" pin icon="plus-sign"/>
    	<g:Command id="editshl" text="edit" help="View Shelf Location" class=""/>
    </g:Commands>


	<g:Event command="addshl">
    	<g:Window title="'New Shelf Location'" width="550px" height="70px" url="'modules/warehouse/material/save_shelf_location.cfm'" IdFromGrid="">
        	<g:Button IsSave IsNewForm/>
        </g:Window>
    </g:Event>

	<g:Event command="editshl">
    	<g:Window title="'Edit ' + d[1]" width="550px" height="70px" url="'modules/warehouse/material/save_shelf_location.cfm'">
        	<g:Button IsSave />
        </g:Window>
    </g:Event>

</g:Grid>

</cfoutput>
