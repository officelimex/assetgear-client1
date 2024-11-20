<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset comId = '__users_c_all_company' & url.id/>

<cfquery name="qU">
	SELECT *
    FROM core_company
    WHERE CompanyId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfoutput>
<f:Form id="#comId#frm" action="modules/ajax/settings.cfm?cmd=SaveCompany" EditId="#url.id#"> 
    <table border="0" width="100%">
    	<tr>
        	<td valign="top" width="50%">
            	<f:TextBox name="Name" required value="#qU.Name#" />
            	<f:TextBox name="Description" required label="Description" value="#qU.Description#"  class="span9"/>
                <f:TextArea name="Address" label="Address" value="#qU.Address#" class="span9" rows="3" />
            </td>
        </tr>    
    </table>
</f:Form>

</cfoutput>