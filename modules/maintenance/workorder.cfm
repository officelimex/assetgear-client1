<cfoutput>
	<style>
		tr.tt td{border-bottom: 1px solid ##fff !important;}
		tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
		td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
	</style>
	<cfset woId = '__workorder_c'/>
	<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

	<cfinclude template="workorder/all_workorder.cfm"/>

	<cfquery name="q">
		SELECT * FROM job_class ORDER BY Class
	</cfquery>

	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span2" style="position:fixed;">
				<n:Nav renderTo="#woId#">
					<n:NavItem title="New WorkOrder" url="modules/maintenance/workorder/new_workorder.cfm" id="new_workorder"/>
					<n:NavItem type="divider"/>
					<n:NavItem title="My Department" isactive url="modules/maintenance/workorder/all_workorder.cfm?cid=#request.userinfo.departmentid#&filter=d" id="all_workorder#request.userinfo.departmentid#d"/>
					<cfif val(request.userinfo.unitid) >
						<n:NavItem title="My Unit" url="modules/maintenance/workorder/all_workorder.cfm?cid=&filter=unit" id="all_workorderunit"/>
					</cfif>
					<cfloop list="Open,Close,Suspended,Part on hold" index="stat">
						<cfset stat_ = replace(stat," ","_","all")/>
						<n:NavItem title="&nbsp;&nbsp;&nbsp;#stat#" url="modules/maintenance/workorder/all_workorder.cfm?cid=#stat_#&filter=status" id="all_workorder#stat_#status"/>
					</cfloop>
					<cfif request.IsFS || request.IsAdmin || request.IsWarehouseMan || request.IsHost || request.IsHSE || request.isMS> 
						<n:NavItem type="divider"/>
						<n:NavItem title="All WorkOrder" url="modules/maintenance/workorder/all_workorder.cfm?cid=&filter=" id="all_workorder"/>
					</cfif>
					<n:NavItem type="divider"/>
					<n:NavItem type="header" title="WorkOrder By Work Class"/>
					<cfloop query="q">
						<n:NavItem title="&nbsp;&nbsp;#Class#" url="modules/maintenance/workorder/all_workorder.cfm?cid=#request.userinfo.departmentid#&jid=#JobClassId#" id="all_workorder#JobClassId##request.userinfo.departmentid#d"/>
					</cfloop>
					<n:NavItem type="divider"/>
					<cfset dm = month(now())/>
					<n:NavItem type="header" title="Planned mtce. Reports"/>
					<n:NavItem type="new window" title="This week Planned Job" url="modules/maintenance/workorder/print_scheduled_wo.cfm?m=#dm#&w=#Week(now())#"/>
					<n:NavItem type="new window" title="This month Planned Jobs" url="modules/maintenance/workorder/print_scheduled_wo.cfm?m=#dm#"/>
					<!---<n:NavItem type="divider"/>
					<n:NavItem type="new window" title="#dateformat(now(),'mmm.')# Planned Jobs" url="modules/maintenance/workorder/print_scheduled_wo.cfm?m=#dm#"/>
					<n:NavItem type="new window" title="#dateformat(DateAdd('m',1,now()),'mmm.')# Planned Jobs" url="modules/maintenance/workorder/print_scheduled_wo.cfm?m=#dm+1#"/>--->

					<!---<n:NavItem type="header" title="Other mtce. Reports"/>
					<n:NavItem type="new window" title="#dateformat(DateAdd('m',-1,now()),'mmm.')# Other Jobs" url="modules/maintenance/workorder/print_other_wo.cfm?m=#dm-1#"/>
					<n:NavItem type="new window" title="#dateformat(now(),'mmm.')# Other Jobs" url="modules/maintenance/workorder/print_other_wo.cfm?m=#dm#"/>
					<n:NavItem type="new window" title="#dateformat(DateAdd('m',1,now()),'mmm.')# Other Jobs" url="modules/maintenance/workorder/print_other_wo.cfm?m=#dm+1#"/>--->

					<n:NavItem type="divider"/>
					<n:NavItem title="Filtered Report" url="modules/maintenance/workorder/filter_report.cfm" id="filter_report"/>
					<n:NavItem type="new window" title="Month End Report" url="modules/maintenance/workorder/print_month_end.cfm"/>
				</n:Nav>
			</div>

			<div class="span10" style="float:right;">
				<div id="#woId#_grid">
					<div class="sub_page all_workorder" id="#woId#_all_workorder#request.userinfo.departmentid#d"></div>
				</div>
			</div>
		</div>
	</div>

</cfoutput>