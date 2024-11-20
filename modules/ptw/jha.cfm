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
<cfset JSId = '__jha_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />
<cfinclude template="jha/all_jha.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2" style="position:fixed;">  
        <n:Nav renderTo="#JSId#"> 
            <n:NavItem title="New JHA" url="modules/ptw/jha/save_jha.cfm"  id="save_jha"/>
            <n:NavItem type="divider"/> 
			<cfif request.IsHSE>
            	<n:NavItem title="All JHA" isactive url="modules/ptw/jha/all_jha.cfm" id="all_jha"/>
            <cfelse> 
            	<n:NavItem title="All JHA" isactive url="modules/ptw/jha/all_jha.cfm" id="all_jha"/>
            </cfif>         
        </n:Nav>  
    </div>
    <div class="span10" style="float:right">
    	<div id="#JSId#_grid">
        	<div class="sub_page all_jha" id="#JSId#_all_jha"></div>
        </div>
    </div>
  </div>
</div>  
</cfoutput>
