<!--- 
	Author: Arowolo Abiodun
	Created: 2011/11/19
	Modified: 2011/11/19
	-> add new Privilege
--->
<cfoutput>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfparam name="url.id" default="0"/>
<cfset qPr = application.com.Module.getprivilegesByRole(url.id)/>
 
<cfquery name="qP">
    SELECT 
        p.PageId, p.Title,
        m.Title Module, m.ModuleId,
        CONCAT(m.Title,' &mdash; ', p.Title) PageTitle
    FROM core_page p
    INNER JOIN core_module m ON m.ModuleId = p.ModuleId
    <cfif qPr.PageId neq "">WHERE PageId  NOT IN (#ValueList(qPr.PageId)#)</cfif>
    ORDER BY m.ModuleId
</cfquery>
<table width="100%" class="table table-striped">
  <thead>
  <tr>
    <th>Modules &mdash; Pages</th>
    <th>Rights</th>
    <th>&nbsp;</th>
  </tr>
  </thead>
<tbody> 
<cfloop query="qPr"> 
  <tr>
    <td>#Module# &mdash; #Page#</td>
    <td>#Rights#</td>
    <td><a>Remove</a></td>
  </tr>
</cfloop>  
</tbody>    
</table>
 
<f:Form id="frmAddPrev" action="modules/ajax/developer.cfm?cmd=AddPrivilegeToRole" EditId="#url.id#" class="form-inline"> 
 <table width="100%" border="0">
  <tr>
    <td width="40%">
    <select name="pageid">
    	<cfloop query="qP"><option value="#qP.PageId#">#qP.PageTitle#</option></cfloop>
    </select>
    </td>
    <td width="40%">
    <label><input type="checkbox" value="v" name="rights"/> View</label>
    <label><input type="checkbox" value="e" name="rights"/> Edit</label>
    <label><input type="checkbox" value="a" name="rights"/> Add</label><br/>
    <label><input type="checkbox" value="p" name="rights"/> Print</label>
    <label><input type="checkbox" value="d" name="rights"/> Delete</label>
    <label><input type="checkbox" value="*" name="rights"/> All</label></td>
    <td width="20%"><a class="btn btn-primary span1" id="add_prev">Add</a></td>
  </tr>
</table> 
 
</f:Form>

</cfoutput>
<script>
	window.addEvent('domready', function()	{
		$('add_prev').addEvent('click', function(e)	{
			var frm = 'frmAddPrev'; 
			$(frm).set('send', {
				onRequest: function(){e.target.disabled=true },
				onFailure: function(r){showError(r);e.target.disabled=false},
				onSuccess: function(){										
					new aNotify().alert('Success!','The Privilege was added'); 
					e.target.disabled=false  
				}.bind(this)
			}).send();
		})
	});
</script>