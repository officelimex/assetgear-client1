<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> display all the roles and privelages in the application 
--->
<cfoutput>

<cfset devId = '__role_c'/>

<cfimport taglib="../../assets/awaf/tags/xGrid_1001/" prefix="g" />
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<g:Grid renderTo="#devId#_role" url="'modules/ajax/developer.cfm?cmd=Role_PrivilegeGrid'">
	<g:Columns>
		<g:Column id="RoleId" caption="##"/>
        <g:Column id="Title" caption="Role" searchable sortable template = "row[1]+'<br/>'+row[2]"/>
        <g:Column id="Description" hide/> 
        <g:Column id="Pages"/> 
	</g:Columns>
    <g:Commands>
    	<g:Command id="editR" icon="pencil" text="Role"/>
        <g:Command id="editP" icon="pencil" text="Privilege"/> 
    </g:Commands>
    
	<g:Event command="editR">
    	<g:Window title="'Edit ' + d[1] + ' Role'" width="500px" height="140px" url="'modules/developer/w_role.cfm'">
        	<g:Button IsSave /> 
        </g:Window>
    </g:Event>    
    <g:Event command="editP">    
    	<g:Window title="'Update Privileges for ' + d[1]" width="700px" height="400px" url="'modules/developer/w_privilege.cfm'" Id="_"/>
    </g:Event>

</g:Grid>

<div class="container-fluid">
  <div class="row-fluid">
    <div class="span10">
    	<div id="#devId#_grid">
        	<div class="sub_page role" id="#devId#_role"></div>
        </div>
    </div>
  
    <div class="span2" style="position:fixed;right:35px;">  
        <div class="well" style="padding: 8px 0; margin-top:30px" id="#devId#_nav"/>  
    </div>  
    <!---<div class="span2">m 
        <n:Nav renderTo="#devId#">
        	<n:NavItem icon="plus-sign" title="New Role">
            	<n:Window url="'modules/developer/w_role.cfm'" height="180px">
                	<n:Button formId="#devId#0frm"/>
                </n:Window>
            </n:NavItem> 
        </n:Nav>  
    </div> ---> 

  </div>
</div> 


<script type="text/javascript">
document.addEvent('domready', function() {
 	var n = new aNavigate('#devId#', {
		items:[
			{title: 'New Role'},
			{type:'divider'}, 
			{title:'Role', isactive:true, url: 'modules/requisition/all_rpo.cfm', id:'all_rpo'},
			{type:'divider'}, 
		]
	}); 
});
</script>
</cfoutput>
