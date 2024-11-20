
<cfparam default="0" name="url.id"/>
<cfparam name="url.cid" default=""/>
<cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../../assets/awaf/tags/xUtil/" prefix="util" />
<cfimport taglib="../../../assets/awaf/tags/xEditTable/" prefix="et" />


<cfset usrId = '__users_c_all_users#url.cid#' & url.id/>
<cfset officeLoc = application.com.User.GetOfficeLocation()/>

<cfset Id1 = "#usrId#_1"/>
<cfset Id2 = "#usrId#_2"/>
<cfset Id3 = "#usrId#_3"/>
<cfset Id4 = "#usrId#_4"/>

<cfquery name="qU">
	#application.com.User.SQL_USER#
    WHERE u.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/> 
    	AND u.UserStatus = "Active" AND u.Approved = "Yes"
</cfquery>

<cfquery name="qAU">
	#application.com.User.SQL_USER#
	WHERE u.UserStatus = "Active" AND u.Approved = "Yes"
</cfquery>

<cfset qD = application.com.User.GetDepartments()/>
<cfset qUt = application.com.User.getUnit()/>

<cfquery name="qC">
	#application.com.User.SQL_COMPANY#
    ORDER BY Name
</cfquery>

<cfquery name="qM">
	#application.com.User.SQL_USER#
    WHERE u.CompanyId = <cfqueryparam cfsqltype="cf_sql_integer" value="1"/>
    AND u.UserId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"/>
    AND Approved="Yes" AND u.UserStatus = "Active"
</cfquery>

<cfoutput>
<f:Form id="#usrId#frm" action="controllers/Settings.cfc?method=SaveUser" EditId="#url.id#"> 
<div id="#Id1#" <cfif url.id neq 0>style="height:240px;"</cfif>>
    <table border="0" width="100%"> 
    	<tr>
        	<td valign="top" width="50%">
            	<f:TextBox name="Surname" required value="#qU.Surname#" />
            	<f:TextBox name="OtherNames" required label="Other Names" value="#qU.OtherNames#" />
                <f:TextBox name="Position" required label="Position" value="#qU.Position#" />
                <!---f:Select name="RelieveUserId" autoselect label="Relieve Personnel" ListDisplay="#Valuelist(qM.Names)#" ListValue="#Valuelist(qM.UserId)#" selected="#qU.RelieveUserId#" /---> 
                <f:Select name="ManagerId" autoselect label="Manager" ListDisplay="#Valuelist(qM.UserName)#" ListValue="#Valuelist(qM.UserId)#" selected="#qU.ManagerId#" />       
                <f:Select name="CompanyId" required label="Company" ListDisplay="#Valuelist(qC.Name)#" ListValue="#Valuelist(qC.CompanyId)#" selected="#qU.CompanyId#" />                      
                <f:CheckBox name="OfficeLocationId" ListValue="#ValueList(officeLoc.OfficeLocationId)#" selected="#qU.OfficeLocationId#" ListDisplay="#ValueList(officeLoc.LocationName)#" inline showlabel label="Office Location" />
            </td>
            <td class="horz-div" valign="top">
                <f:Select name="DepartmentId" label="Department" required ListDisplay="#Valuelist(qD.Name)#" ListValue="#Valuelist(qD.DepartmentId)#" selected="#qU.DepartmentId#" />                
            	<f:Select name="UnitId" label="Unit" ListDisplay="#Valuelist(qUt.Name)#" ListValue="#Valuelist(qUt.UnitId)#" selected="#qU.UnitId#" />
            	<cfif url.id eq 0><f:TextBox name="Email" validate="email" value="#qU.Email#"/></cfif>
                <f:TextBox name="PersonalEmail" label="Personal e-mail" validate="email" value="#qU.PersonalEmail#" />
                <!---f:Select name="Location" required label="Location" ListValue="Kwale,Lagos" selected="#qU.Location#" /--->                      
                <f:RadioBox name="Approved" inline showlabel required selected="#qU.Approved#" ListValue="Yes,No"/>
            </td>
        </tr>    
    </table>
</div>
<div id="#Id2#">
 	
 		<cfquery name="qAI">
			SELECT
				rt.*,
				CONCAT(h.Surname," ",h.OtherNames,' ~',rt.UserId) AS ReportTo
			FROM
				report_to AS rt
			INNER JOIN core_user AS h ON rt.HeadId = h.UserId
			WHERE rt.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#"/>
		</cfquery>
		
		<et:Table allowInput height="100%" id="Users">		
			<et:Headers>
				<et:Header title="Report To" size="7" type="int">
                    <et:Select ListValue="#Valuelist(qAU.UserId,'`')#" ListDisplay="#Valuelist(qAU.UserName,'`')#" delimiters="`"/>
                </et:Header>
				<et:Header title="Position" size="4" type="text" hint="Position"/>
				<et:Header title="" size="1"/>
			</et:Headers>
			<et:Content Query="#qAI#" Columns="ReportTo,Position" type="int,text" PKField="ReportTOId"/>
		</et:Table>

</div>
<div id="#Id3#">
	<cfquery name="qAI2">
			SELECT
				rt.*,
				CONCAT(h.Surname," ",h.OtherNames,' ~',rt.UserId) AS Reliefer
			FROM
				relief_user AS rt
			INNER JOIN core_user AS h ON rt.BackToBackId = h.UserId
			WHERE rt.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Id#"/>
		</cfquery>
		
		<et:Table allowInput height="100%" id="Relief">		
			<et:Headers>
				<et:Header title="Back to Back" size="11" type="int">
                    <et:Select ListValue="#Valuelist(qAU.UserId,'`')#" ListDisplay="#Valuelist(qAU.UserName,'`')#" delimiters="`"/>
                </et:Header>
				
				<et:Header title="" size="1"/>
			</et:Headers>
			<et:Content Query="#qAI2#" Columns="Reliefer" type="int" PKField="ReliefUserId"/>
		</et:Table>	
</div>
<div id="#Id4#">
	<table width="100%" border="0">
	  <tr>
	    <td width="70%" valign="top"><u:UploadFile accept="photo" id="Photos" height="192px" table="core_user" pk="#url.id#"/></td>
	    <td valign="top">
	    	<f:TextBox name="Height" label="Height" value="#qU.Height#" class="span7"/>
	        <f:TextBox name="Width" label="Width" value="#qU.Width#" class="span7"/>
	    </td>
	  </tr>
	</table>	
</div>


<nt:NavTab renderTo="#usrId#">
	<nt:Tab>
    	<nt:Item title="General" isactive/>
        <nt:Item title="Report to"/>
        <nt:Item title="Back To Back"/>
        <nt:Item title="Signature"/>
    </nt:Tab>
    <nt:Content>
    	<nt:Item id="#Id1#" isactive/>
        <nt:Item id="#Id2#"/>
        <nt:Item id="#Id3#"/>
        <nt:Item id="#Id4#"/>
    </nt:Content>
</nt:NavTab>

	 <cfif url.id eq 0>
        <f:ButtonGroup>
            <f:Button value="Create new Item" class="btn-primary" IsSave/>
        </f:ButtonGroup>
     </cfif>

</f:Form>

</cfoutput>