<cfoutput>
<cfset devId = '__page_c'/>
<cfimport taglib="../../../assets/awaf/tags/xGrid_1001/" prefix="g" /> 

<g:Grid renderTo="#devId#_all_page" url="modules/ajax/developer.cfm?cmd=PageGrid">
	<g:Columns>
		<g:Column id="PageId" caption="##"/>
        <g:Column id="Title" searchable sortable template = "row[2]+' &ndash; '+row[1]+'<br/><i>'+row[3]+'</i>'"/>
        <g:Column id="Module" searchable hide/>
        <g:Column id="Description" hide/>
        <g:Column id="URL"/> 
	</g:Columns>
    <g:Commands>
    	<g:Command id="edit" icon="pencil"/>
        <g:Command id="delete" icon="trash"/>
    </g:Commands>
    
	<g:Event command="edit">
    	<g:Window title="'Edit ' + d[2]" width="850px" height="250px" url="'modules/developer/page/w_page.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>

</g:Grid>
 
</cfoutput>
