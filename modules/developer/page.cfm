<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> display all the pages in the application 
--->

<cfoutput>
<cfset devId = '__page_c'/> 
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="page/all_page.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
  
    <div class="span2" style="position:fixed;"> 
        <n:Nav renderTo="#devId#">
        	<n:NavItem icon="plus-sign" title="New page" url="modules/developer/page/w_page.cfm" id="w_page"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Pages" isactive url="modules/developer/page/all_page.cfm" id="all_page"/>
            <n:NavItem type="divider"/>
            <!---</n:NavItem> --->
        </n:Nav>    
    </div>
    <div class="span10" style="float:right">
    	<div id="#devId#_grid">
        	<div class="sub_page page" id="#devId#_all_page"></div>
        </div>
    </div>

  </div>
</div> 
</cfoutput>
