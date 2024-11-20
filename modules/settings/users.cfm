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
<cfset ursId = '__users_c'/>

<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />
<cfset company = application.com.User.GetDCompany()/>

<cfinclude template="users/all_users.cfm"/>
<div class="container-fluid">
  <div class="row-fluid">
    <div class="span2" style="position:fixed;">  
        <n:Nav renderTo="#ursId#">
        	<n:NavItem title="New User" url="modules/settings/users/save_users.cfm"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Users" isactive url="modules/settings/users/all_users.cfm" id="all_users"/>
                
            <cfloop query="company">
            	<n:NavItem title="&nbsp;&nbsp;&nbsp;#Name#" url="modules/settings/users/all_users.cfm?cid=#CompanyId#" id="all_users#CompanyId#"/>
            </cfloop>
            
            <n:NavItem title="Departments" url="modules/settings/users/department.cfm" id="department"/>
            <n:NavItem title="Units" url="modules/settings/users/unit.cfm" id="unit"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Awaiting Approval" url="modules/settings/users/department.cfm" id="department"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Company" url="modules/settings/users/all_company.cfm" id="all_company"/>
        </n:Nav>  
    </div>
    
    <div class="span10" style="float:right;">
    	<div id="#ursId#_grid">
        	<div class="sub_page all_user" id="#ursId#_all_users"></div>
        </div>
    </div>
  

  </div>
</div>  
</cfoutput>
