<cfoutput> 
<cfset inbxid = '__inbox_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />
 
<cfinclude template="inbox/all_inbox.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2" style="position:fixed;">  
        <n:Nav renderTo="#inbxid#">  
            <n:NavItem title="All Inbox" isactive url="modules/message/inbox/all_inbox.cfm" id="all_inbox"/>           
        </n:Nav>  
    </div>
    <div class="span10" style="float:right">
    	<div id="#inbxid#_grid">
        	<div class="sub_page all_inbox" id="#inbxid#_all_inbox"></div>
        </div>
    </div>
  </div>
</div>  
</cfoutput>
