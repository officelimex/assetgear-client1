<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/29
	Modified: 2011/09/29
	-> display all the module in the application 
--->

<cfoutput>
  

<cfset devId = '__mod_c'/>

<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#devId#_all_module" url="modules/ajax/developer.cfm?cmd=ModuleGrid">
	<g:Columns>
		<g:Column id="ModuleId" caption="##"/>
        <g:Column id="Title" searchable sortable template = "row[1]+' &ndash; <i>'+row[3]+'</i><br/>'+row[2]"/>
        <g:Column id="Description" hide/>
        <g:Column id="URL" hide/>
        <g:Column id="Page"/> 
	</g:Columns>
    <g:Commands>
    	<g:Command id="edit" icon="pencil"/>
        <g:Command id="delete" icon="trash"/>
    </g:Commands>
    
	<g:Event command="edit">
    	<g:Window title="'Edit ' + d[1] + ' Module'" width="810px" height="200px" url="'modules/developer/module/w_module.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>

</g:Grid> 
</cfoutput>