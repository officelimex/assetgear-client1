<cfoutput>
<cfswitch expression="#url.cmd#">
    <cfcase value="GetNoticeCount">
        <cfquery name="qN">
            SELECT COUNT(NoticeId) C FROM core_notice
            WHERE (RecipientId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
            		OR RecipientDepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.departmentid#"/>
                    OR `Role` = <cfqueryparam cfsqltype="cf_sql_char" value="#request.userinfo.role#"/>)
                AND Status = "o"
        </cfquery><cfif qN.C neq 0>#qN.C#</cfif>
    </cfcase>
    
    <cfcase value="SaveProfile">
    	<!--- save personal details ---->
        <cfquery>
        	UPDATE core_user SET PersonalEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PersonalEmail#"/>
            WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.userinfo.userid#"/>
        </cfquery>
        <!--- change password ---> 
        <cfif form.NewPassword neq "">
        	<cfset qU = application.com.User.UpdatePassword(form,request.userinfo.userid)/>
        	Your password was change successfuly.
        </cfif>	
		<!--- change pin --->
        <cfif form.NewPIN neq "">
        	<cfset qU = application.com.User.UpdatePIN(form,request.userinfo.userid)/>
        	Your PIN was change successfuly.
        </cfif>
        <!--- delegate role to user --->
        <cfparam name="form.DelegateUser" default=""/>
        <cfif form.DelegateUser neq "">
			<!--- update service request item from temp data --->
            <!---  int0 - touserid, text0 - role, text1 - Start, text2 - End ---->
            <cfset h = createobject('component','assetgear.com.awaf.util.helper').Init()/> 
            <cfset h.SaveFromTempTable(form.DelegateUser,
                "core_delegate_role",
                "ToUserId,Role,Start,End",
                "int0,text0,text1,text2",
                "DelegateRoleId","ByUserId",request.userinfo.userid)/>
            Role delegation updated
        </cfif>
    </cfcase>
</cfswitch>
</cfoutput>