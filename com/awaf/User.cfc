<cfcomponent displayname="User">

	<cffunction name="Init" access="public" returntype="User" hint="Init the component">

        <cfset this.SQL_USER = '
				SELECT
					u.*,
					CONCAT(u.Surname," ",u.OtherNames) AS `UserName`,
					l.Role,
					cc.Name as Company,
					s.Height,s.Width,
					d.`Name` AS DepartmentName
				FROM
					core_user AS u
				LEFT JOIN core_login AS l ON u.UserId = l.UserId
				INNER JOIN core_department AS d ON u.DepartmentId = d.DepartmentId
				INNER JOIN core_company cc ON u.CompanyId = cc.CompanyId
				LEFT JOIN signature s ON u.UserId = s.UserId
		'/>
        <cfset this.SQL_USER_LOGIN = '
            SELECT
                u.UserId, u.Email, CONCAT(u.Surname," ",u.OtherNames) User, u.Email EmployeeEmail,
                l.Role
            FROM
            	core_user u
			LEFT JOIN core_login l ON l.UserId = u.UserId
		'/>

        <cfset this.DEPARTMENT_SQL = '
            SELECT d.* FROM core_department d
        '/>

        <cfset this.SQL_UNIT = '
            SELECT * FROM core_unit
        '/>
		
		<cfset this.SQL_COMPANY = '
            SELECT * FROM core_company
        '/>
		
		<cfset this.SQL_DCOMPANY = '
            SELECT DISTINCT 
				c.CompanyId, c.Name
			FROM core_user cu
			INNER JOIN core_company c ON c.CompanyId = cu.CompanyId
        '/>

		<cfset this.OFFICE_LOCATION = '
            SELECT * FROM office_location
        '/>
        
		<cfset this.SQL_REPORTTO = '
            SELECT
				rt.*, CONCAT(
					h.Surname,
					" ",
					h.OtherNames,
					" ~",
					rt.UserId
				) AS Reportto
			FROM
				report_to AS rt
			INNER JOIN core_user AS h ON rt.UserId = h.UserId
        '/>
        
		<cfset this.SQL_BACKTOBACK = '
            SELECT
				ru.*, CONCAT(
					h.Surname,
					" ",
					h.OtherNames,
					" ~",
					ru.UserId
				) AS Reliefer
			FROM
				relief_user AS ru
			INNER JOIN core_user AS h ON ru.UserId = h.UserId
        '/>
		<cfset this.SQL_LOCATION = '
            SELECT
              l.ParentLocationId,l.LocationId,CONCAT_WS(" @ ",l.Name,ll.Name,ol.LocationName) AS Name, l.OfficeLocationId
              FROM location l
              LEFT JOIN location ll ON l.ParentLocationId = ll.LocationId
              LEFT JOIN office_location ol ON l.OfficeLocationId =ol.OfficeLocationId
              
        '/>
        <cfset this.SQL_LOCATION_COUNT = '
            SELECT
              COUNT(l.LocationId) c
              FROM location l
              LEFT JOIN location ll ON l.ParentLocationId = ll.LocationId
              INNER JOIN office_location ol ON l.OfficeLocationId =ol.OfficeLocationId
              
        '/>
		<cfreturn this>
	</cffunction>

    <cffunction name="GetLocation" access="public" returntype="query"  hint="Get all Location">
        <cfargument name="id" default="" type="numeric"/>
        <cfquery name="qDLocation" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_LOCATION#
            <cfif val(arguments.id)>
                WHERE ISNULL(l.ParentLocationId)
            </cfif>
            ORDER BY l.Name
        </cfquery>

        <cfreturn qDLocation />
    </cffunction>
    <cffunction name="GetLocationCount" access="public" returntype="numeric"  hint="Get all Location">
        <cfargument name="id" default="" type="numeric"/>
        <cfif val(arguments.id)>
            WHERE ISNULL(l.ParentLocationId)
        </cfif>
        <cfquery name="qC" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_LOCATION_COUNT#
            
        </cfquery>

        <cfreturn qC.C />
    </cffunction>

    <cffunction name="GetDCompany" access="public" returntype="query"  hint="Get all Users">

        <cfquery name="qDCompany" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_DCOMPANY#
        </cfquery>

        <cfreturn qDCompany />
    </cffunction>
	<cffunction name="GetReportTo" access="public" returntype="query"  hint="Get all Users">

        <cfquery name="qEmps" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_REPORTTO#
            WHERE rt.UserId = #request.userinfo.userid#
        </cfquery>

        <cfreturn qEmps />
    </cffunction>	
    <cffunction name="GetBackToBack" access="public" returntype="query"  hint="Get all Users">

        <cfquery name="qEmps" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_BACKTOBACK#
            WHERE ru.UserId = #request.userinfo.userid#
        </cfquery>

        <cfreturn qEmps />
    </cffunction>	
    <cffunction name="GetUsers" access="public" returntype="query"  hint="Get all Users">

        <cfquery name="qEmps" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_USER#
            WHERE u.UserStatus = "Active" AND u.Approved = "Yes"
        </cfquery>

        <cfreturn qEmps />
    </cffunction>	
	<cffunction name="GetUnit" access="public" returntype="query"  hint="Get all Users">

        <cfquery name="qUnit" cachedwithin="#createTime(1,0,0)#">
            #this.SQL_UNIT#
            ORDER BY Name
        </cfquery>

        <cfreturn qUnit />
    </cffunction>

    <cffunction name="GetDepartments" access="public" returntype="query"  hint="Get all Departments">

        <cfquery name="qD" cachedwithin="#createTime(1,0,0)#">
            #this.DEPARTMENT_SQL#
			ORDER BY Name
        </cfquery>

        <cfreturn qD/>
    </cffunction>

    <cffunction name="GetOfficeLocation" access="public" returntype="query"  hint="Get all Office Location">

        <cfquery name="qD" cachedwithin="#createTime(1,0,0)#">
            #this.OFFICE_LOCATION#
        </cfquery>

        <cfreturn qD/>
    </cffunction>

	<cffunction name="GetUser" access="public" returntype="Query" hint="Get User details">
     	<cfargument name="eid" hint="employee Id" required="yes" type="numeric">

        <cfquery name="qEmp">
        	#this.SQL_USER#
            WHERE u.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eid#">
        </cfquery>

		<cfreturn qEmp />
	</cffunction>

	<cffunction name="GetUsersInRole" access="public" returntype="Query" hint="Get all employees in a particular role">
     	<cfargument name="r" hint="role" required="yes" type="string">

        <cfquery name="qEmp">
        	#this.SQL_USER_LOGIN#
            WHERE l.Role IN ('#replace(arguments.r,",","','","all")#')
        </cfquery>

		<cfreturn qEmp />
	</cffunction>

    <cffunction name="NewUser" hint="create new employee" returntype="numeric" access="public">
    	<cfargument name="data" hint="struct data containing employee details" required="yes" />

        <cfset d = arguments.data />
        <cfparam name="d.UnitId" default="0"/>

        <!--- check if employee already exist, by using the email address (the database will do this) ---->

        <!---- register the employee --->
        <cfquery result="r">
        	INSERT INTO core_user	(
            	Surname, Othernames, Gender, Email)
            VALUES	(
            	<cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Surname#"/>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.OtherNames#"/>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Gender#"/>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Email#"/>
            )
        </cfquery>
        <cfset eid = r.GENERATED_KEY/>
        <!--- create login profile if available --->
        <cfif d.Password eq "">
			<cfset d.Password = createObject("component","assetgear.com.awaf.util.Random").RandValue() />
        </cfif>
        <cfset pwdKey = createObject("component","assetgear.com.awaf.Security").EncryptPassword(d.Role,d.Email,d.Password) />
        <cfquery>
        	INSERT INTO core_login	(UserId, Role, PasswordKey)
            VALUES	(
            	<cfqueryparam cfsqltype="cf_sql_integer" value="#eid#"/>, <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Role#"/>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#pwdKey#"/>
            )
        </cfquery>

        <!--- send login details if specified --->

        <cfreturn eid />
    </cffunction>

    <cffunction name="SaveUserRole" returntype="string" access="public">
    	<cfargument name="data" hint="struct data containing user id, role & email" required="yes" />

        <cfset d = arguments.data />

        <!--- generate new password --->
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset pwd = createObject('component','assetgear.com.awaf.util.Random').RandValue(4,'numbers')/>
        <cfset nkey = s.EncryptPassword(d.Role,d.Email,pwd) />

        <cfquery name="qL">
        	SELECT * FROM core_login
            WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#d.UserId#"/>
        </cfquery>

        <cfquery>
        	<cfif qL.Recordcount>
            	UPDATE
            <cfelse>
            	INSERT INTO
            </cfif>
            core_login SET
            	UserId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.UserId#"/>,
                `Role` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Role#"/>,
                PasswordKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nkey#"/>
            <cfif qL.Recordcount>
            	WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#d.UserId#"/>
            </cfif>
        </cfquery>

        <!--- send mail to user --->
        <cfreturn pwd/>
    </cffunction>

    <cffunction name="UpdateProfile" hint="update employee profile" returntype="void" access="public">
    	<cfargument name="data" hint="struct data containing employee details" required="yes" />

        <cfset d = arguments.data />

        <cfquery result="r">
        	UPDATE core_user SET
            	Surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Surname#"/>,
                Othernames = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.OtherNames#"/>,
                Gender = <cfqueryparam cfsqltype="cf_sql_varchar" value="#d.Gender#"/>
            WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#d.UserId#"/>
        </cfquery>

    </cffunction>
        
    <cffunction name="IsMyBackToBack" hint="Check if it is a user's back to back" returntype="boolean" access="public">
    	<cfargument name="id" hint="Id of the user" required="yes" />
    	<cfargument name="oid" hint="Id of the other user" required="yes" />

        <cfset id = arguments.id />
        <cfset oid = arguments.oid />
        <cfset checks = False />

        <cfquery result="r">
        	SELECT * FROM  relief_user 
        	WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(id)#"/> 
        	AND BackToBackId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(oid)#"/>
        </cfquery>
        
        <cfif r.RECORDCOUNT gt 0>
        	<cfset checks = True />
        </cfif>
        
		<cfreturn checks>
    </cffunction>
        
    <cffunction name="IsMySupervisor" hint="Check if it is a user's back to back" returntype="boolean" access="public">
    	<cfargument name="id" hint="Creator's Id" required="yes" />
    	<cfargument name="oid" hint="User's" required="yes" />

        <cfset id = arguments.id />
        <cfset oid = arguments.oid />
        <cfset checks = False />

        <cfquery result="r">
        	SELECT * FROM  report_to 
        	WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(id)#"/> 
        	AND HeadId = <cfqueryparam cfsqltype="cf_sql_integer" value="#val(oid)#"/>
        </cfquery>
        
        <cfif r.RECORDCOUNT gt 0>
        	<cfset checks = True />
        </cfif>
        
		<cfreturn checks>
    </cffunction>

    <cffunction name="UpdatePassword" hint="update employee password" returntype="void" access="public">
    	<cfargument name="data" hint="passwords" required="yes" type="struct" />
        <cfargument name="eid" required="yes" hint="employrr id" type="numeric"/>

        <cfset d = arguments.data />

        <cfset qUser = GetUser(arguments.eid)/>
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset l = CreateObject("component","assetgear.com.awaf.Login").init()/>
        <cfset qLog = l.GetUserByEmail(qUser.Email)/>

        <!--- check if user is telling the truth --->
       	<cfset ckey = s.EncryptPassword(qLog.Role,qUser.Email,d.CurrentPassword) />
        <cfif cKey neq qLog.PasswordKey>
        	<cfthrow message="The Current Password you provided is wrong. Please try again"/>
        </cfif>

        <!--- check if pwd is empty --->
        <cfif d.NewPassword eq "">
        	<cfthrow message="Your Password is field empty"/>
        </cfif>

        <cfif d.NewPassword eq "" or d.ConfirmNewPassword eq "">
        	<cfthrow message="Please make sure your new password and confirm password is not empty"/>
        </cfif>

      	<!--- check the two passwod if they match --->
        <cfif d.NewPassword neq d.ConfirmNewPassword>
        	<cfthrow message="Password Missmatch, Please comfirm your new password"/>
        </cfif>

        <!--- create new pwd key --->
        <cfset nkey = s.EncryptPassword(qLog.Role,qUser.Email,d.NewPassword) />

        <cfquery result="r">
        	UPDATE core_login SET
                PasswordKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nkey#"/>
            WHERE LoginId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qLog.LoginId#"/>
        </cfquery>

    </cffunction>

    <cffunction name="UpdatePIN" hint="update employee PIN" returntype="void" access="public">
    	<cfargument name="data" hint="PINs" required="yes" type="struct" />
        <cfargument name="eid" required="yes" hint="employrr id" type="numeric"/>

        <cfset d = arguments.data />

        <cfset qUser = GetUser(arguments.eid)/>
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset l = CreateObject("component","assetgear.com.awaf.Login").init()/>
        <cfset qLog = l.GetUserByEmail(qUser.Email)/>

        <!--- check if user is telling the truth --->
       	<cfset ckey = s.EncryptPassword(qLog.Role,qUser.Email,d.CurrentPIN) />
        <cfif cKey neq qLog.PINKey>
        	<cfthrow message="The Current PIN you provided is wrong. Please try again"/>
        </cfif>

        <!--- check if pwd is empty --->
        <cfif d.NewPIN eq "">
        	<cfthrow message="Your PIN field is empty"/>
        </cfif>

        <cfif d.NewPIN eq "" or d.ConfirmNewPIN eq "">
        	<cfthrow message="Please make sure your new PIN and confirm PIN is not empty"/>
        </cfif>

      	<!--- check the two passwod if they match --->
        <cfif d.NewPassword neq d.ConfirmNewPassword>
        	<cfthrow message="PIN Missmatch, Please comfirm your new PIN"/>
        </cfif>

        <!--- create new pwd key --->
        <cfset nkey = s.EncryptPassword(qLog.Role,qUser.Email,d.NewPIN) />

        <cfquery result="r">
        	UPDATE core_login SET
                PINKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nkey#"/>
            WHERE LoginId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qLog.LoginId#"/>
        </cfquery>

    </cffunction>

    <cffunction name="ResetPassword" hint="reset user password" returntype="string" access="public">
        <cfargument name="email" required="yes" hint="user email/username" type="string"/>

        <cfset msg = ""/>
        <!--- check if email exits --->
        <cfquery name="qUser">
        	SELECT * FROM core_user
            WHERE Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#"/> AND Approved="Yes"
        </cfquery>
        <cfif qUser.Recordcount>
        	<!--- check if the user has a login account --->
            <cfquery name="qLog">
            	SELECT * FROM core_login
                WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qUser.UserId#"/>
            </cfquery>
            <cfif qLog.Recordcount>
				<!--- create new passeord key --->
                <cfset npwd = randrange(100000,999999)/>
                <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
                <cfset nkey = s.EncryptPassword(qLog.Role,qUser.Email,npwd)/>

                <cfquery result="r">
                    UPDATE core_login SET
                        PasswordKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nkey#"/>
                    WHERE LoginId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qLog.LoginId#"/>
                </cfquery>
                <!--- send password via mail --->
                
                <cfset i = Application.com.Notice.SendEmail("#qUser.Email#","AssetGear Password Reset","Hello, <p>Please find below your new login details for AssetGear; <br/> Username: #qUser.Email# <br/> Password: #npwd# </p> Thank you")/>
                <cfset msg = "Please check your email for your new password"/>
            <cfelse>
				<!---- log error --->
                <cfset msg = "You dont have a login account, please see the Administrator"/>
            </cfif>
        <cfelse>
        	<!---- log error --->
            <cfset msg = "Email address '#arguments.email#' does not exist in the database"/>
        </cfif>



        <cfreturn msg/>
    </cffunction>

    <cffunction name="ResetPIN" hint="reset employee PIN" returntype="string" access="public">
        <cfargument name="eid" required="yes" hint="employrr id" type="numeric"/>

        <cfset qUser = GetUser(arguments.eid)/>
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset l = CreateObject("component","assetgear.com.awaf.Login").init()/>
        <cfset qLog = l.GetUserByEmail(qUser.Email)/>

        <cfif !qLog.recordcount>
        	<cfthrow message="User does not have login detail"/>
        </cfif>

        <!--- create new pwd key --->
        <cfset npin = randrange(1000,9999)/>
        <cfset nkey = s.EncryptPassword(qLog.Role,qUser.Email,npin)/>

        <cfquery result="r">
        	UPDATE core_login SET
            PINKey = <cfqueryparam cfsqltype="cf_sql_varchar" value="#nkey#"/>
          WHERE LoginId = <cfqueryparam cfsqltype="cf_sql_integer" value="#qLog.LoginId#"/>
        </cfquery>

        <!--- send pin via mail --->

        <cfreturn npin/>
    </cffunction>

    <cffunction name="getRole" access="public" returntype="struct" hint="get all roles">

        
			<cfreturn {
				Code : "UR,FS,SV,MS,HSE,PS,AD,WH",
				Title : "User,F.S,Supervisor,Main. Supervisor,HSE,Production Supv.,IT,Warehouse"
			}/>

		</cffunction>

</cfcomponent>
