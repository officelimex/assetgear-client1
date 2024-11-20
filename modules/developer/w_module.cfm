<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> edit a module 
--->
<cfparam default="0" name="url.id"/>
<cfset devId = '__mod_c' & url.id/>

<cfset qM = application.com.Module.getModule(url.id)/>
<cfoutput>

<cfimport taglib="../../assets/awaf/tags/xForm_1001/" prefix="f" />

<f:Form id="#devId#frm" action="modules/ajax/developer.cfm?cmd=SaveModule" EditId="#url.id#"> 
	<table width="95%">
    	<tr>
        	<td valign="top">
                <f:TextBox name="title" label="Module title" required value="#qM.title#"/>
                <f:TextBox name="Code" Help="Unique variable name" required value="#qM.Code#" class="span1"/> 
                <f:TextBox name="Position" required value="#qM.Position#" validate="integer" class="span1"/>  
            
            </td>
            <td class="horz-div" valign="top">
                <f:TextBox name="url" label="URL" required value="#qM.URL#"/>
                <f:TextArea name="desc" label="Description" required value="#qM.Description#"/> 
            
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
 