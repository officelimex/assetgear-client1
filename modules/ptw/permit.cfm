<!--- 
    Author: Arowolo Abiodun
    Created: 2011/11/19
    Modified: 2011/11/19
    -> display all the roles and privelages in the application 
--->
<cfoutput>
	<style>
		tr.tt td {
		    border-bottom: 1px solid ##fff !important;}
		tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
		td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
	</style>
	<cfset PwId = '__permit_c'/>
	<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n"/>

	<cfinclude template="permit/unapproved_permit.cfm"/>

	<div class="container-fluid">
		<div class="row-fluid">
		
			<div class="span2" style="position:fixed;">
				<n:nav renderto="#PwId#">
					<n:navitem title="New Permit" url="modules/ptw/permit/save_permit.cfm" id="save_permit"/>
					<n:navitem type="divider"/>
					<!---<n:NavItem title="All Permit" isactive url="modules/ptw/permit/all_permit.cfm"	id="all_permit"/>--->
					<n:navitem title="Permit yet to be Approved" isactive url="modules/ptw/permit/unapproved_permit.cfm" id="unapproved_permit"/>
                    <n:navitem title="Active Permit" url="modules/ptw/permit/pa/permit_for_pa.cfm" id="permit_for_pa"/>
                    <n:navitem title="Closed Permit" url="modules/ptw/permit/closed_permit.cfm" id="closed_permit"/>
					<n:navitem type="divider"/>
                    <cfif request.IsPS || request.IsPSDelegated>
                        <n:navitem title="Waiting for Approval" url="modules/ptw/permit/ps/permit_for_ps.cfm" id="permit_for_ps"/>
                        <n:navitem title="Revalidation" url="modules/ptw/permit/ps/revalidate_permit.cfm" id="revalidate_permit"/>
                        <n:navitem title="Permit to Close" url="modules/ptw/permit/ps/permit_to_close.cfm" id="permit_to_close"/>
                    <cfelseif request.IsHSE>
                    	<n:navitem title="Waiting for Approval" url="modules/ptw/permit/hse/permit_for_hse.cfm" id="permit_for_hse"/>
                    <cfelseif request.IsFS || request.IsFSDelegated>
                    	<n:navitem title="Waiting for Approval" url="modules/ptw/permit/fs/permit_for_fs.cfm" id="permit_for_fs"/> 
                    </cfif>
                    <!---<cfswitch expression="#request.userinfo.role#">
                    	<cfcase value="PS">
                        	<n:navitem title="Waiting for Approval" url="modules/ptw/permit/ps/permit_for_ps.cfm" id="permit_for_ps"/>
                            <n:navitem title="Revalidation" url="modules/ptw/permit/ps/revalidate_permit.cfm" id="revalidate_permit"/>
                            <n:navitem title="Permit to Close" url="modules/ptw/permit/ps/permit_to_close.cfm" id="permit_to_close"/>
                        </cfcase>
                        <cfcase value="HSE">
                        	<n:navitem title="Waiting for Approval" url="modules/ptw/permit/hse/permit_for_hse.cfm" id="permit_for_hse"/>
                        </cfcase>
                        <cfcase value="FS">
                        	<n:navitem title="Waiting for Approval" url="modules/ptw/permit/fs/permit_for_fs.cfm" id="permit_for_fs"/>                            
                        </cfcase>
                    </cfswitch> --->
				</n:nav>
			</div>
			<div class="span10" style="float:right">
				<div id="#PwId#_grid">
					<div class="sub_page unapproved_permit" id="#PwId#_unapproved_permit"></div>
				</div>
			</div>
		</div>
	</div>
</cfoutput>