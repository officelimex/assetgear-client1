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
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset setId = '__maintenance_setting_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="maintenance/location.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span10">
    	<div id="#setId#_grid">
        	<div class="sub_page location" id="#setId#_location"></div>
        </div>
    </div>
  
    <div class="span2" style="position:fixed;right:35px;">  
        <n:Nav renderTo="#setId#">
        	
            <n:NavItem title="Location" isactive url="'modules/settings/asset/location.cfm'" id="location"/>
            <n:NavItem type="divider"/>
        </n:Nav>  
    </div>

  </div>
</div>  
</cfoutput>
