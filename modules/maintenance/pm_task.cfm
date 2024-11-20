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
<cfset pmId = '__pm_task_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="pm_task/all_pm_task.cfm"/>

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2" style="position:fixed;">  
            <n:Nav renderTo="#pmId#">
                <n:NavItem title="New PM Task" url="modules/maintenance/pm_task/save_pm_task.cfm"/>
                <n:NavItem type="divider"/>
                <n:NavItem title="All PM Task" isactive url="modules/maintenance/pm_task/all_pm_task.cfm" id="all_pm_task"/>
                <cfquery name="qC">
                	SELECT 
                    	f.FrequencyId, f.Description Frequency
                    FROM frequency f 
                </cfquery>
                <n:NavItem type="header" title="Filter by Frequency"/>
                <cfloop query="qC">
                	<n:NavItem title="&nbsp;&nbsp;#qC.Frequency#" url="modules/maintenance/pm_task/all_pm_task.cfm?filter=date&cid=#qC.FrequencyId#" id="all_pm_task#qC.FrequencyId#"/>
                </cfloop>
                <cfquery name="qR">
                	SELECT 
                    	rt.ReadingTypeId, rt.Type ReadingType
                    FROM reading_type rt
                    LIMIT 0,3
                </cfquery> 
                <n:NavItem type="header" title="Filter by Milestone"/>
                <cfloop query="qR">
                	<n:NavItem title="&nbsp;&nbsp;#qR.ReadingType#" url="modules/maintenance/pm_task/all_pm_task.cfm?filter=milestone&cid=#qR.ReadingTypeId#" id="all_pm_task#qR.ReadingTypeId#"/>
                </cfloop>
                <cfif request.IsHost>
                <n:NavItem type="divider"/>    
                	<n:NavItem title="Custom Search" url="modules/maintenance/pm_task/custom_search.cfm"/>
                <n:NavItem type="divider"/>                
                <n:NavItem title="Frequency" url="modules/maintenance/pm_task/frequency.cfm" id="frequency"/>
                </cfif>  
                <n:NavItem type="header" title="Reports"/>
                <n:NavItem type="new window" title="PM Task - Location" url="modules/maintenance/pm_task/print_all_pm.cfm"/>
                <n:NavItem type="new window" title="PM Task - Unit" url="modules/maintenance/pm_task/print_all_pm_unit.cfm"/>
            </n:Nav>  
        </div>
        
        <div class="span10" style="float:right;">
            <div id="#pmId#_grid">
            	<div class="sub_page all_pm_task" id="#pmId#_all_pm_task"></div>
            </div>
        </div> 
    </div>
</div>
</cfoutput>
