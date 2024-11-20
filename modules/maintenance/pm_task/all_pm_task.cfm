<cfoutput> 

<!--- for frequency as category {url.cid}--->
<cfparam name="url.cid" default=""/>
<cfparam name="url.filter" default=""/>

<cfset pmId = '__pm_task_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#pmId#_all_pm_task#url.cid#" url="modules/ajax/maintenance.cfm?cmd=getAllPMTask&cid=#url.cid#&filter=#url.filter#" commandWidth="70px" class="table-hover table-condensed">
	<g:Columns>
		<g:Column id="PMTaskId" caption="##" field="pm.PMTaskId" sortable searchable/> 
        <g:Column id="Asset" caption="Asset" searchable field="a.Description" sortable/>
        <g:Column id="Location" caption="Location" searchable field="l.Name"/>
        <g:Column id="Description" field="pm.Description" caption="Task" searchable/> 
        <cfif url.filter eq "date">
        	<g:Column id="Frequency" hide/>
            <g:Column id="ReadingType" hide />   
        <cfelseif url.filter eq "milestone">
        	<g:Column id="Frequency" hide/>
            <g:Column id="ReadingType" caption="Miestone"/>      
        <cfelse>
        	<g:Column id="Frequency"/> 
            <g:Column id="ReadingType" caption="Milestone"/>
        </cfif>
         
        <g:Column id="IsActive" caption="Active"/>
	</g:Columns>
    <g:Commands> 
		<cfif (request.userinfo.role eq "HT") or (request.userinfo.role eq "MS") or (request.userinfo.role eq "FS") or (request.userinfo.role eq "SV")>
			<g:Command id="editA" text="edit" help="Edit PM Task" class="btn btn-mini"/>
		</cfif>
		<g:Command id="viewA" text="view" help="View PM Task" class="btn btn-mini"/> 
    </g:Commands>

	<g:Event command="editA">
    	<g:Window title="'Update ##' + d[0] + ' - ' + d[2]" width="900px" height="450px" url="'modules/maintenance/pm_task/save_pm_task.cfm?cid=#url.cid#'" id="">
        	<g:Button value="Delete" class="btn-danger" icon="icon-remove icon-white" executeURL="'controllers/PMTask.cfc?method=delete'"/>             
			<g:Button IsSave /> 
        </g:Window>
    </g:Event>     
	<g:Event command="viewA">
    	<g:Window title="'View ##' + d[0] + ' - ' + d[2]" width="850px" height="400px" url="'modules/maintenance/pm_task/view_pm_task.cfm?cid=#url.cid#'" id="_" >
        	<g:Button NewWindowURL="'modules/maintenance/pm_task/print_pm.cfm'" class="btn-inverse" icon="icon-print icon-white" value="Print"/> 
        </g:Window>
    </g:Event>  

</g:Grid> 
 
</cfoutput>
