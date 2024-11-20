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

<cfinclude template="role/all_role.cfm"/>

<div class="container-fluid">
  <div class="row-fluid">
  
    <div class="span2" style="position:fixed;">  
        <n:Nav renderTo="#devId#">
        	<n:NavItem title="New Role" url="modules/developer/role/add_role.cfm"/>
            <n:NavItem type="divider"/>
            <n:NavItem title="Role" isactive url="modules/developer/role/all_role.cfm" id="all_role"/>
            <n:NavItem type="divider"/>
        </n:Nav>         
    </div>   
    <div class="span10" style="float:right">
    	<div id="#devId#_grid">
        	<div class="sub_page role" id="#devId#_all_role"></div>
        </div>
    </div>
  

  </div>
</div>

<!---<script type="text/javascript">
document.addEvent('domready', function() {
 	var n = new aNavigate('#devId#', {
		items:[
			{title: 'New Role'},
			{type:'divider'}, 
			{title:'Role', isactive:true, url: 'modules/developer/all_role.cfm', id:'all_role'},
			{type:'divider'}, 
		]
	}); 
});
</script>--->
</cfoutput>
