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
<cfset drId = '__drilling_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="drilling/all_drilling_return.cfm"/>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2" style="position:fixed;">
			<n:Nav renderTo="#drId#">
				<n:NavItem title="New Return Item(s)" url="modules/warehouse/drilling/save_drilling_return.cfm?id=0" id="new_drilling_return"/>
				<n:NavItem type="divider"/>
				<n:NavItem title="All Item(s) Returned" isactive url="modules/warehouse/drilling/all_drilling_return.cfm" id="all_drilling_return"/>
      </n:Nav>
		</div>

		<div class="span10" style="float:right;">
            <div id="#drId#_grid">
                <div class="sub_page all_drilling_return" id="#drId#_all_drilling_return"></div>
            </div>
		</div>
	</div>
</div>
</cfoutput>
