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
<cfquery name="qU">
	SELECT
    *
    FROM core_user u
    LEFT JOIN core_login l ON l.UserId = u.UserId
    WHERE u.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfoutput><br />
<f:Form id="#comId#frm" action="modules/ajax/settings.cfm?cmd=ResetPIN" EditId="#url.id#"> 
    <div align="center">
    	Are you sure you want to <strong>Reset</strong> the PIN for #qU.Surname# #qU.OtherNames#.<br/>
    	The new PIN will be sent to <a>#qU.Email#</a>
    </div>
</f:Form>

</cfoutput>