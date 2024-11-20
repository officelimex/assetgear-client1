<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput>
  
<cfset astId = '__asset_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 
 
<g:Grid renderTo="#astId#_meter_reading" url="modules/ajax/maintenance.cfm?cmd=getMeterReadings" commandWidth="150px" class="table-hover">
	<g:Columns> 
		<g:Column id="AssetId" caption="##" field="a.AssetId" sortable searchable/>
        <g:Column id="Asset" field="a.Description" searchable sortable template="row[1]+'<span class=grb1>'+row[2]+'</span>'"/>
        <g:Column id="Location" hide/>
        <g:Column id="CurrentReading" caption="Current Reading"/>
        <g:Column id="TimeModified" caption="Last updated" sortable/> 
	</g:Columns>
    <g:Commands> 
    	<g:Command id="updateReading" text="Enter reading" help="Update Reading"/>
        <g:Command id="readingHistory" text="History" help="Reading History"/> 
    </g:Commands> 
<!---    <g:Commands> 
    	<g:Command id="updateReading" icon="pencil" help="Update Reading"/>
        <g:Command id="readingHistory" icon="file" help="Reading History"/> 
    </g:Commands>---> 
        
	<g:Event command="updateReading">
    	<g:Window title="'Take readings for '+d[1]" width="600px" height="400px" url="'modules/maintenance/asset/take_reading.cfm'" id="_" >
        	<g:Button IsSave />
        </g:Window>
    </g:Event>
	<g:Event command="readingHistory">
    	<g:Window title="'History readings for '+d[1]" width="850px" height="340px" url="'modules/maintenance/asset/reading_history.cfm'" id="view" > 
        </g:Window>
    </g:Event>  

</g:Grid> 
 
</cfoutput>
