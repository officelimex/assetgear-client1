<cfoutput>

<!--- for frequency as category {url.cid}--->
<cfparam name="url.cid" default=""/>
<cfparam name="url.status" default=""/>
<cfparam name="url.srtype" default=""/>

<cfset jrId = '__service_request_c'/>
 
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" />

  <g:Grid renderTo="#jrId#_all_service_request#url.status##url.srtype#" url="modules/ajax/maintenance.cfm?cmd=getAllServiceRequest&cid=#url.cid#&status=#url.status#&srtype=#url.srtype#" commandWidth="70px" class="table-hover"  firstsortOrder="DESC">
  
    <g:Columns>
      <g:Column id="ServiceRequestId" caption="##" field="ServiceRequestId" sortable searchable/>
      <g:Column id="AssetDescription" searchable field="a.Description" caption="Asset" hide/>
      <g:Column id="Request" searchable field="sr.Description" template="row[2]+'<br/>'+row[1]" />
      <g:Column id="RequestByUserId" caption="Request By" nowrap/>
      <g:Column id="Date" nowrap/>
      <g:Column id="Categ" caption="CloseBy" nowrap/>
      <g:Column id="ServiceType" caption="Service Type" nowrap/>
      <g:Column id="Priority"/>
      <g:Column id="Status"/>
    </g:Columns>

    <g:Commands>
      <g:Command id="ViewSR" icon="file" help="Edit Service Request"/>
      <g:Command id="PrintSR" icon="print" help="Print Service Request"/>
    </g:Commands>

    <g:Event command="ViewSR">
      <g:Window title="'View Service Request - ##'+d[0]" width="800px" height="450px" url="'modules/maintenance/service_request/view_service_request.cfm?cid=#url.cid#&r=#url.srtype#'" id="">
        <cfif (ListContainsNoCase('1,3,16',request.userinfo.DepartmentId)) && (url.srtype != "")>
          <g:Button value="Close SR" class="btn-success" icon="icon-remove icon-white" executeURL="'controllers/Maintenance.cfc?method=closeServiceRequest'"/>
        </cfif>
      </g:Window>
    </g:Event>
    
    <g:Event command="PrintSR">
      <g:Window title="'Print Service Request ## ' + d[0]" IsNewWindow url="'modules/maintenance/service_request/print_service_request.cfm'"  />
    </g:Event>

  </g:Grid>

</cfoutput>
