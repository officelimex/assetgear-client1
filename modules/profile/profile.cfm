<cfimport taglib="../../assets/awaf/tags/xForm_1001/" prefix="f" />
<cfimport taglib="../../assets/awaf/tags/xNavTab_1000/" prefix="nt" />
<cfimport taglib="../../assets/awaf/tags/xUploader_1000/" prefix="u" />
<cfimport taglib="../../assets/awaf/tags/xUtil/" prefix="util" />
<cfimport taglib="../../assets/awaf/tags/xEditTable/" prefix="et" />

<cfset usrId = '__profile' & request.userinfo.userid/>

<cfset Id1 = "#usrId#_1"/>
<cfset Id2 = "#usrId#_2"/>
<cfset Id3 = "#usrId#_3"/>
<cfset Id4 = "#usrId#_4"/>
<cfset Id5 = "#usrId#_5"/>
<cfset Id6 = "#usrId#_6"/>

<cfquery name="qU">
	SELECT 
    	cu.*,
        cd.Name Department,
        ut.Name Unit,
        c.Name Company
    FROM core_user cu
    INNER JOIN core_department cd ON cu.DepartmentId = cd.DepartmentId
    LEFT JOIN core_unit ut ON ut.UnitId = cu.UnitId
    INNER JOIN core_company c ON c.CompanyId = cu.CompanyId
    WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
</cfquery>
  

<cfoutput> 
<f:Form id="#usrId#frm" action="modules/ajax/profile.cfm?cmd=SaveProfile" EditId="#request.userinfo.userid#"> 
<div id="#Id1#" style="height:227spx;">
    <table border="0" width="100%">
    	<tr>
        	<td valign="top" width="50%">
            	<f:Label name="Surname" value="#qU.Surname#" />
            	<f:Label name="OtherNames" value="#qU.OtherNames#" />
                <f:Label name="Department" value="#qU.Department#"/>
                <f:Label name="Unit" value="#qU.Unit#"/>
                <f:Label name="Company" Value="#qU.Company#"/> 
 				<f:Label name="Position" Value="#qU.Position#"/>  
                <f:TextBox name="PersonalEmail" label="Personal e-mail" validate="email" value="#qU.PersonalEmail#" />
            </td>
        </tr>    
    </table>
</div>

<div id="#Id2#">
    <div class="alert alert-info">Fill this section only if you want to change your password</div>
    <f:PasswordTextBox name="CurrentPassword" label="Current password" class="span2"/>
    <f:PasswordTextBox name="NewPassword" label="New password" validate="minLength:4" class="span2"/>
    <f:PasswordTextBox name="ConfirmNewPassword" label="Confirm new password" validate="minLength:4" class="span2"/>
</div>

<div id="#Id3#">
    <div class="alert alert-info">Fill this section only if you want to change your PIN for signature</div>
    <f:PasswordTextBox name="CurrentPIN" label="Current PIN" class="span2"/>
    <f:PasswordTextBox name="NewPIN" label="New PIN" validate="length:4 validate-integer" class="span2"/>
    <f:PasswordTextBox name="ConfirmNewPIN" label="Confirm new PIN" validate="length:4 validate-integer" class="span2"/>
</div>

<div id="#Id4#">
	<util:FileView type="p" table="core_user" pk="#request.userinfo.userid#" source="doc/photo/" column="1" height="250px"/>
</div>
 
<div id="#Id5#">
    <cfswitch expression="#request.userinfo.role#">
    	<cfcase value="HT">
        	<cfset rls = "FS,PS"/>
        </cfcase>
        <cfcase value="FS">
        	<cfset rls = "FS"/>
        </cfcase>
        <cfcase value="PS">
        	<cfset rls = "PS"/>
        </cfcase>
    	<cfdefaultcase><cfset rls=""/></cfdefaultcase> 
    </cfswitch>
    <cfif rls eq "">
    	<div class="alert alert-danger">Delegate is not available for your role</div>
    <cfelse>
        <div class="alert alert-info">Delegate role to users</div>
        <cfset qE = application.com.User.GetUsers()/>
        <cfquery name="qR">
            SELECT 
            	dr.DelegateRoleId, dr.Role, DATE_FORMAT(dr.Start,'%Y/%c/%e') Start, DATE_FORMAT(dr.End,'%Y/%c/%e') End,
                CONCAT(tu.Surname," ",tu.OtherNames,"~",tu.UserId) UserDesc
            FROM core_delegate_role dr
            INNER JOIN core_user tu ON tu.UserId = dr.ToUserId
            WHERE ByUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
        </cfquery>
        <et:Table allowInput height="100px" id="DelegateUser">
            <et:Headers>
                <et:Header title="Staff" size="5" type="int">
                    <et:Select ListValue="#Valuelist(qE.UserId,'`')#" ListDisplay="#Valuelist(qE.UserName,'`')#" delimiters="`"/>
                </et:Header>
                <et:Header title="Role" size="1" type="text">
                    <et:Select ListValue="#rls#"/>
                </et:Header>
                <et:Header title="Start" size="2" type="text" hint="yyyy/mm/dd"/>
                <et:Header title="End" size="2" type="text" hint="yyyy/mm/dd"/>
                <et:Header title="" size="1"/>
            </et:Headers>
           <et:Content Query="#qR#" Columns="UserDesc,Role,Start,End" type="int-select,text,text,text" PKField="DelegateRoleId"/> 
        </et:Table>
     </cfif>
</div>

<div id="#Id6#">
	<f:Label name="Browser" value="#cgi.http_user_agent#"/>
    <f:Label name="IP" value="#cgi.remote_host#" /> 
    <f:Label name="Server" value="#server.os.name# #server.os.version#" />
    <f:Label name="lucee" value="#server.lucee.versionName# #server.lucee.version# #server.lucee.version# #server.lucee.state#" />
    <f:Label name="RU" value="#cgi.remote_user#" />
</div>

<nt:NavTab renderTo="#usrId#">
	<nt:Tab>
    	<nt:Item title="General" isactive/>
        <nt:Item title="Login Password"/>
        <nt:Item title="PIN"/>
        <nt:Item title="Signature"/>
        <nt:Item title="Delegate"/>
        <nt:Item title="System"/>
    </nt:Tab>
    <nt:Content>
    	<nt:Item id="#Id1#" isactive/>
        <nt:Item id="#Id2#"/>
        <nt:Item id="#Id3#"/>
        <nt:Item id="#Id4#"/>
        <nt:Item id="#Id5#"/>
        <nt:Item id="#Id6#"/>
    </nt:Content>
</nt:NavTab>
  
</f:Form> 

</cfoutput>