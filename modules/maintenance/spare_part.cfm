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
<cfset spId = '__sparepart_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="spare_part/spare_part_item.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
  
    <div class="span2" style="position:fixed;">
        <n:Nav renderTo="#spId#">
            <n:NavItem title="Spare Part Items" isactive url="modules/maintenance/spare_part/spare_part_item.cfm" id="spare_part_item"/>
        </n:Nav>  
    </div>
    <div class="span10" style="float:right">
    	<div id="#spId#_grid">
        	<div class="sub_page spare_part_item" id="#spId#_spare_part_item"></div>
        </div>
    </div>

  </div>
</div>  
</cfoutput> 
