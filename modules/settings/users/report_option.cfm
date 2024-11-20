<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
--->
<cfparam default="0" name="url.id"/>
<cfparam name="url.cid" default=""/> 
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset comId = '__users_c_all_users#url.cid#' & url.id/>

<!---<cfif url.id eq 1>
	<cfabort showerror="You can't edit this user" />
</cfif>--->

<cfoutput><br />
	<div class="span12">
		<div class="span6">
			<a class="btn btn-muted" href="modules/settings/users/print_users_report.cfm" target="_blank" >View Users & Privileges</a>
		</div>
		
	</div>

</cfoutput>