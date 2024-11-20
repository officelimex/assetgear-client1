<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
--->
<cfoutput> 
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset fuel = '__fuel_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="fuel/fuel_request.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
  
    <div class="span2" style="position:fixed;">
        <n:Nav renderTo="#fuel#">
            <n:NavItem title="Fuel Request" url="modules/warehouse/fuel/fuel_request.cfm" id="fuel" />
        </n:Nav>  
    </div>
    <div class="span10" style="float:right">
    	<div id="#fuel#_grid">
        	<div class="sub_page fuel_request" id="#fuel#_fuel_request"></div>
        </div>
    </div>

  </div>
</div>  
</cfoutput> 