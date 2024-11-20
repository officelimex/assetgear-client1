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
<cfset ursId = '__maintenance_setting_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="maintenance/job_class.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
     <div class="span2" style="position:fixed;">  
        <n:Nav renderTo="#jobId#">             
        	<n:NavItem title="Job Class" isactive url="modules/settings/maintenance/job_class.cfm" id="job_class"/> 
            <n:NavItem title="Location" url="modules/settings/maintenance/location.cfm" id="location"/>
            <n:NavItem title="Reading Type" url="modules/settings/maintenance/reading_type.cfm" id="reading_type"/>
        </n:Nav>  
    </div>
  
    <div class="span10" style="float:right;">
    	<div id="#jobId#_grid">
        	<div class="sub_page job_class" id="#ursId#_job_class"></div>
        </div>
    </div>
  


  </div>
</div>  
</cfoutput>
