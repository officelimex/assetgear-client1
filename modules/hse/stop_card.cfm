<!---
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application
--->
<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(../maintenance/assets/awaf/UI/img/grid_ddl.gif) no-repeat left top  !important;}
</style>
<cfset spCD = '__stop_card_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="stop_card/all_stop_card.cfm"/>

<cfquery name="qD">
	SELECT * FROM core_department ORDER BY Name
</cfquery>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2" style="position:fixed;">
			<n:Nav renderTo="#spCD#">
				<n:NavItem title="New Stop Card" url="modules/hse/stop_card/save_stop_card.cfm?id=0" id="new_stop_card"/>
				<n:NavItem type="divider"/>
				<n:NavItem title="All Stop Card" isactive url="modules/hse/stop_card/all_stop_card.cfm" id="all_stop_card"/>
				<cfif (request.IsAdmin)||(request.IsHost)||(request.userinfo.role eq "HSE")>
                    <n:NavItem type="divider"/>
                    <n:NavItem type="header" title="SOP BY DEPARTMENT"/>
                	<cfloop query="qD">
                        <n:NavItem title="&nbsp;&nbsp;#Name#"  url="modules/hse/stop_card/all_stop_card.cfm?filter=d&cid=#DepartmentId#" id="all_stop_cardd#DepartmentId#"/>
                    </cfloop>
                    
                </cfif>
				
                <n:NavItem type="divider"/>
                <n:NavItem type="header" title="SOP BY SAFE ACTS"/>
				<n:NavItem title="&nbsp;&nbsp;Safe Acts"  url="modules/hse/stop_card/all_stop_card.cfm?filter=a&cid=SafeActs" id="all_stop_cardaSafeActs"/>
				<n:NavItem title="&nbsp;&nbsp;Unsafe Acts"  url="modules/hse/stop_card/all_stop_card.cfm?filter=a&cid=UnsafeActs" id="all_stop_cardaUnsafeActs"/>
				<n:NavItem title="&nbsp;&nbsp;Unsafe Conditions"  url="modules/hse/stop_card/all_stop_card.cfm?filter=a&cid=UnsafeConditions" id="all_stop_cardaUnsafeConditions"/>
				<n:NavItem type="divider"/>
				<n:NavItem title="Filter Report"  url="modules/hse/stop_card/filter_report.cfm" id="filter_report"/>
      </n:Nav>
		</div>

		<div class="span10" style="float:right;">
            <div id="#spCD#_grid">
                <div class="sub_page all_stop_card" id="#spCD#_all_stop_card"></div>
            </div>
		</div>
	</div>
</div>
</cfoutput>
