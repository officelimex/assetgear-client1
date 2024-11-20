<cfoutput>
<cfparam name="url.id" default="0"/>
<cfparam name="url.cid" default=""/>
<cfset woId = "__inbox_c_all_inbox#url.cid#" & url.id/>

<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<f:Form id="#woId#frm" action="modules/ajax/maintenance.cfm?cmd=SaveWorkOrder" EditId="#url.id#"> 

</f:Form>
</cfoutput>