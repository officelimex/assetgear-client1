<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

<cfset devId = '__page_c_all_page' & url.id/>

<cfset qP = application.com.Module.getPage(url.id)/>
<cfoutput>
<cfquery name="qM">
   	SELECT * FROM core_module
</cfquery>
<f:Form id="#devId#frm" action="modules/ajax/developer.cfm?cmd=SavePage" EditId="#url.id#"> 
    <table width="100%">
    	<tr>
        	<td valign="top" width="50%">
                <f:TextBox name="title" label="Page title" required value="#qP.title#"/>
                <f:Select name="moduleid" label="Module" required selected="#qP.ModuleId#" listvalue="#ValueList(qM.moduleid)#" ListDisplay="#ValueList(qM.title)#"/> 
                <f:TextBox name="Position" required value="#qP.Position#" validate="integer" class="span4"/> 
            
            </td>
            <td class="horz-div" valign="top">
                <f:TextBox name="Code" Help="Unique variable name" required value="#qP.Code#" class="span7"/>
                <f:TextBox name="url" label="URL" required value="#qP.URL#"/>
                <f:TextArea name="desc" label="Description" required value="#qP.Description#"/> 
                        
            </td>
        </tr>
    </table>
    <cfif url.id eq 0>
        <f:ButtonGroup>
            <f:Button value="Create new PM Task" class="btn-primary" IsSave/>
        </f:ButtonGroup>
	</cfif>
</f:Form>

</cfoutput>
<script>

document.addEvent('domready', function() {

});
</script>