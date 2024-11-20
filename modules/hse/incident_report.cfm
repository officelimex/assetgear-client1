<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(../maintenance/assets/awaf/UI/img/grid_ddl.gif) no-repeat left top  !important;}
</style>
<cfset icId = '__incident_report_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="../hse/incident_report/all_incidents.cfm"/>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2" style="position:fixed;">
			<n:Nav renderTo="#icId#">
				<n:NavItem title="New Incident" url="modules/hse/incident_report/save_incident.cfm?id=0" id="new_incident"/>
				<n:NavItem type="divider"/>
				<n:NavItem title="All Incident" isactive url="modules/hse/incident_report/all_incidents.cfm" id="all_incidents"/>
      </n:Nav>
		</div>

		<div class="span10" style="float:right;">
			<div id="#icId#_grid">
				<div class="sub_page all_incidents" id="#icId#_all_incidents"></div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
