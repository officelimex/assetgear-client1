<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset jrId = '__service_request_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="service_request/all_service_request.cfm"/>

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2" style="position:fixed;">
            <n:Nav renderTo="#jrId#">
                <n:NavItem title="New Service Request" url="modules/maintenance/service_request/save_service_request.cfm"/>
                <n:NavItem type="divider"/>
                <n:NavItem title="All Service Request" isactive url="modules/maintenance/service_request/all_service_request.cfm" id="all_service_request"/>
				<n:NavItem type="divider"/>
                <n:NavItem title="Opened Service Request"  url="modules/maintenance/service_request/all_service_request.cfm?status=open" id="all_service_requestopen"/>
                <n:NavItem title="Closed Service Request" url="modules/maintenance/service_request/all_service_request.cfm?status=close" id="all_service_requestclose"/>
                <cfif (ListContainsNoCase('2,15,8',request.userinfo.DepartmentId) || (request.userinfo.role == "HT") || (request.userinfo.role == "HSE"))>
                    <n:NavItem type="divider"/>
                    <n:NavItem title="Waiting For Closure"  url="modules/maintenance/service_request/all_service_request.cfm?srtype=waiting" id="all_service_requestwaiting"/>
                </cfif>
            </n:Nav>
        </div>

        <div class="span10" style="float:right;">
            <div id="#jrId#_grid">
            	<div class="sub_page all_service_request" id="#jrId#_all_service_request"></div>
            </div>
        </div>
    </div>
</div>
</cfoutput>
