<!--- 
	Author: Arowolo Abiodun
	Created: 2011/09/30
	Modified: 2011/09/30
	-> edit a page 
--->
<cfparam default="0" name="url.id"/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />

<cfset usrId = '__users_c_all_users' & url.id/>

<cfquery name="qU">
	SELECT 
    	cu.*,
        cd.Name ,
        ct.Name Unit
    FROM core_user cu
    INNER JOIN core_department cd ON cu.DepartmentId = cd.DepartmentId
    INNER JOIN core_unit ct ON cu.UnitId = ct.UnitId
    WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
</cfquery>

<cfquery name="qD">
	SELECT * 
    FROM core_department
    WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qU.DepartmentId#">
</cfquery>


<cfoutput>
<br/>
<f:Form id="#usrId#frm" action="modules/ajax/settings.cfm?cmd=SaveUser" EditId="#url.id#"> 
    <table border="0" width="100%">
    	<tr>
        	
            <td valign="top">
                <f:Label name="Surname" value="#qU.Surname#" />
            	<f:Label name="Other Names" value="#qU.OtherNames#" />
            	<f:Label name="Email" required value="#qU.Email#" />
                <f:Label name="Department" value="#qD.Name#" />
                <!---<f:Label name="Unit" value="#qU.Unit#" />--->
                <f:Label name="Position" value="#qU.PositionId#" />
                <f:Label name="Manager" value="#qU.ManagerId#" />
            </td>
        </tr>    
    </table>
	 <cfif url.id eq 0>
        <f:ButtonGroup>
            <f:Button value="Create new Item" class="btn-primary" IsSave/>
        </f:ButtonGroup>
     </cfif>

</f:Form>

</cfoutput>