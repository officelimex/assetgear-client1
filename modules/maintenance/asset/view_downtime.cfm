<cfoutput> 
 
    <cfset astId = '__asset_c'/>
    <cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
   
    <g:Grid renderTo="#astId#_downtime" url="modules/ajax/maintenance.cfm?cmd=getdowntime" commandWidth="150px" class="table-hover">
        <g:Columns>
            <g:Column id="AssetLocationId" caption="##" sortable searchable/>
            <g:Column id="AssetDescriptions" caption="Asset Description" />
            <!---g:Column id="DownTimeCause" caption="Cause of DownTime" />
            <g:Column id="CreatedBy" sortable caption="Create By"/>
            <g:Column id="CreatedById" hide/>
			<g:Column id="DepartmentId" hide/>
            <g:Column id="StartPeriod" caption="Start Time" searchable nowrap/--->
            <g:Column id="DTPeriod" caption="D.T.(Hrs)" sortable nowrap/>
            <g:Column id="UTPeriod" caption="U.T.(Hrs)" sortable nowrap/>
            <g:Column id="Availibility" caption="Avail (%)" sortable nowrap/>
            <g:Column id="Status" nowrap/>
        </g:Columns>
        <g:Commands>
            <g:Command id="addDowntime" help="New Failure Report" pin text="New F.R.." class="btn btn-primary"/>
            <g:Command id="updateDowntime" text="edit" help="Update Downtime" />
            <g:Command id="Print" icon="print" help="Print Downtime Report"/>
        </g:Commands>
        <g:Event command="addDowntime">
            <g:Window title="'New Failure Report'" width="850px" height="320px" url="'modules/maintenance/asset/new_failure_report.cfm'" IdFromGrid="">
               
            </g:Window>
        </g:Event>
        <g:Event command="updateDowntime">
            <g:Window title="'Record Downtime for '+d[1]" width="800px" height="360px" url="'modules/maintenance/asset/save_downtime.cfm'" id="" >
                
            </g:Window>
        </g:Event>

        <g:Event command="Print">
            <g:Window title="'Print Downtime Report for ""' + d[0] + '""' " IsNewWindow  url="'modules/maintenance/asset/print_equipment.cfm'" />
        </g:Event>


    </g:Grid>
     
      
</cfoutput>
