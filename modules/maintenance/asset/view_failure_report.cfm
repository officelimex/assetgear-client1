<cfoutput> 

    <cfset astId = '__asset_c'/>
    <cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />
	
    <cfparam name="url.s" default="1" />
    <cfparam name="url.cid" default="" />


    <g:Grid renderTo="#astId#_failure_report#url.s#" url="modules/ajax/maintenance.cfm?cmd=getFailureReports&s=#url.s#" commandWidth="150px" class="table-hover">
        <g:Columns>
            <g:Column id="AssetFailureReportId" caption="##" sortable searchable/>
            <g:Column id="ReportTitle" sortable caption="Report Title" />
            <g:Column id="FailedOn" caption="Failure On" />
            <g:Column id="Asset" field="a.Description" searchable sortable template="row[1]+'<span class=grb1>'+row[2]+' '+row[3]+'</span>'" hide/>
            <g:Column id="Location" hide/>
            <g:Column id="LocDescription" hide/>
            <g:Column id="RiskLevel" caption="Risk Level" searchable/>
            <g:Column id="Date" caption="Date" sortable nowrap/>
            <g:Column id="CreatedByUserId" hide/>
            <g:Column id="Status" hide/>
            <g:Column id="CreatedBy" caption="" />
            <g:Column id="IsMyBackToBack" caption="btb" hide/>
            <g:Column id="Status" field="fr.Status" />
        </g:Columns>
        <g:Commands>
            <g:Command id="updateFailureReport" text="edit" help="Update Failure Report" condition="row[8]==#request.userinfo.UserId# && row[9]!=='Close' || row[11]=='True' "/>
            <g:Command id="Print" icon="print" help="Print Failure Report"/>
        </g:Commands>
        
        <g:Event command="updateFailureReport">
            <g:Window title="'Update Failure Report for '+d[1]" width="800px" height="400px" url="'modules/maintenance/asset/save_failure_report.cfm?cid=#url.cid#'" id="" >
            <g:Button IsSave />
            </g:Window>
        </g:Event>

        <g:Event command="Print">
            <g:Window title="'Print Failure Report for ""' + d[0] + '""' " IsNewWindow  url="'modules/maintenance/asset/print_failure_report.cfm'" />
        </g:Event>

    </g:Grid>

</cfoutput>
