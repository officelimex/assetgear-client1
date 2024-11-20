<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> display all the module in the application 
--->

<cfoutput>
  

<cfset devId = '__mod_c'/>
 
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="module/all_module.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
  
    <div class="span2" style="position:fixed"> 
        <n:Nav renderTo="#devId#">
        	<n:NavItem title="New Module" url="modules/developer/module/w_module.cfm"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Modules" isactive url="modules/developer/role/all_module.cfm" id="all_module"/>
            <n:NavItem type="divider"/>
        </n:Nav>     
    </div>
    <div class="span10" style="float:right" >
    	<div id="#devId#_grid">
        	<div class="sub_page module" id="#devId#_all_module"></div>
        </div>
    </div>

  </div>
</div> 
</cfoutput>