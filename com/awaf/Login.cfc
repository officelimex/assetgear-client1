<cfcomponent>

	<cffunction name="init" access="public" returntype="Login">   
        <cfargument name="url" default="" required="no" hint="the website to login to"/>
        
    	<cfset this.userinfo = "" />
        <cfset this.errmsg = "" />
        <cfset this.captchaAnswer = "" />
        <cfset this.IsLogin = false />
        <cfset this.url = arguments.url/>
        <cfset this.SQL_USER_LOGIN = '
			SELECT
				l.*,
				u.*, CONCAT(u.Surname," ",u.OtherNames) User,
				d.Name Department, d.Email DepartmentEmail
			FROM core_login AS l
			INNER JOIN core_user AS u ON l.UserId = u.UserId
			LEFT JOIN core_department d ON d.DepartmentId = u.DepartmentId
		'/>
        
		<cfreturn this />
	</cffunction>
    
    <cffunction name="Impersonate" access="public" returntype="void" hint="Impersonate a user">
    	<cfargument name="uid" required="yes" type="string" hint="user id">     	
          
    	<cfset this.userinfo = GetUserById(arguments.uid)/>
		<cfif this.userinfo.Recordcount>
			<cfset this.IsLogin = true> 
        <cfelse>
        	<cfset this.IsLogin = false/>
        	<!--- user does not exists --->
            <cfset this.errmsg = ListAppend(this.errmsg, "Wrong username and password")>	
        </cfif>
    </cffunction> 
    
    <cffunction name="SignIn" access="public" returntype="void" hint="sign in a user">
    	<cfargument name="formA" required="yes" type="struct" hint="login details {Captcha, username and Password}">
        <cfargument name="security" required="yes" type="assetgear.com.awaf.Security"> 
    	<cfargument name="captchaAnswer" required="no" type="string" default="">    	
        
    	<cfset this.userinfo = GetUserByEmail(arguments.FormA.username)>
        <!--- deligate --->
        <cfquery name="this.delegate">
        	SELECT * FROM core_delegate_role
            WHERE ToUserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.userinfo.userid#"/>
            	AND (`Start` >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/> AND `End` >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"/>)
        </cfquery>
        
        <cfif this.captchaAnswer neq "">
        <cfif arguments.FormA.Captcha neq this.captchaAnswer>
        	<cfset arguments.FormA.errmsg = ListAppend(this.errmsg, "Wrong Captcha")>
        </cfif>
        </cfif>
		<cfif this.userinfo.Recordcount>
        	<!--- check password ---> 
            <cfif arguments.security.EncryptPassword(this.userinfo.Role,arguments.formA.username,arguments.formA.password) eq this.userinfo.PasswordKey>
            	<!--- grant access --->
            	<cfset this.IsLogin = true>
            <cfelse>
            	<!--- failed attemp: count attemps if necc, and log it --->
                <cfset this.errmsg = ListAppend(this.errmsg, "Wrong password")>
            </cfif>
        <cfelse>
        	<!--- user does not exists --->
            <cfset this.errmsg = ListAppend(this.errmsg, "Wrong username and password")>	
        </cfif>
    </cffunction>
    
	<cffunction name="GetUserByEmail" access="public" returntype="Query" hint="Get User details by email address">
     	<cfargument name="e" hint="employee enail address" required="yes" type="string">
        
        <cfquery name="qtemp">
        	#this.SQL_USER_LOGIN#
            WHERE u.Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.e#">
                AND u.Approved = "Yes" 
        </cfquery>
        
		<cfreturn qtemp />
	</cffunction>
    
	<cffunction name="GetUserById" access="public" returntype="Query" hint="Get User details by email address">
     	<cfargument name="eid" hint="employee id" required="yes" type="string">
        
        <cfquery name="qtemp">
        	#this.SQL_USER_LOGIN#
            WHERE u.UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eid#"> 
        </cfquery>
        
		<cfreturn qtemp />
	</cffunction>
    
    <cffunction name="UpdateLoginAccess" access="public" returntype="string" hint="update the login details of an employee" output="yes"> 
        <cfargument name="FormA" required="yes" type="struct" hint="login details struct data"> 
        
        <cfset f = arguments.FormA/>
        
        <!--- check if employee already has a login details --->
        <cfquery name="qC" >
        	SELECT * FROM core_login
            WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#f.UserId#">
        </cfquery> 
        
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset rndPwd = CreateObject("component","assetgear.com.adexfe.util.Random").RandValue(5,'numbers')/>
       
       	<cfset nKey = s.EncryptPassword(qC.Role,f.Email,rndPwd) />
        
        <cftransaction action="begin">
        	<cfquery >
            	UPDATE core_user SET
                	Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#f.Email#"/>
                WHERE UserId  = <cfqueryparam cfsqltype="cf_sql_integer" value="#f.UserId#">
            </cfquery>
            
            <cfquery >
                <cfif qC.Recordcount><!--- update --->
                    UPDATE core_login SET 
                        PasswordKey = <cfqueryparam value="#nKey#" cfsqltype="cf_sql_varchar">,
                        Role = <cfqueryparam value="#f.Role#" cfsqltype="cf_sql_varchar">
                    WHERE LoginId = <cfqueryparam value="#qC.LoginId#" cfsqltype="cf_sql_integer"> 
                <cfelse><!--- insert --->
                    INSERT INTO core_login	(
                        UserId, PasswordKey, Role 
                    )
                    VALUES	(
                        <cfqueryparam value="#f.UserId#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#nKey#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#f.Role#" cfsqltype="cf_sql_varchar">
                    )                
                </cfif>           		
            </cfquery>
        </cftransaction>

        <cfset SendLoginDetail(f.Email,rndPwd)/>
        
        <cfreturn rndPwd/>
    </cffunction>
    
    <cffunction name="SendLoginDetail" access="public" returntype="void" hint="send login detail via email to owner">
    	<cfargument name="em" hint="email address" type="string" required="yes"/>
        <cfargument name="pwd" hint="password of the receipiant" required="yes" type="string"/>
        
        <cfmail from="AssetGear <do-not-reply@assetgear.net>" to="#arguments.em#" subject="Login Access" type="html">
        	Hello,
            <p>
            	Below is your login details @ #this.url#<br/>
                Username: #arguments.em#<br/>
                Password: #arguments.pwd#
            </p>
            You can change your password immediatly you login.
            <p>Thank you<br/> 
        </cfmail>
        
    </cffunction>
    
    <cffunction name="GenerateNewPassword" access="public" returntype="void" hint="generate new login info for an employee" output="yes"> 
        <cfargument name="email" required="yes" type="string" hint="email address"> 
                
        <!--- check if employee already has a login details --->
        <cfquery name="qC" >
			SELECT
				l.Role, l.PasswordKey, l.LoginId,
				u.UserId, u.Email, CONCAT(u.Surname," ",u.OtherNames) FullName
			FROM core_login AS l
				Inner Join core_user AS e ON l.UserId = u.UserId
            WHERE u.Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Email#">
        </cfquery>
        
        <cfif qC.Recordcount>
			<cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
            <cfset rndPwd = CreateObject("component","assetgear.com.adexfe.util.Random").RandValue(5,'numbers')/>
           
            <cfset nKey = s.EncryptPassword(qC.Role,qC.Email,rndPwd) />
            
            <cftransaction action="begin"> 
                <cfquery >
                    UPDATE core_login SET 
                        PasswordKey = <cfqueryparam value="#nKey#" cfsqltype="cf_sql_varchar">
                    WHERE LoginId = <cfqueryparam value="#qC.LoginId#" cfsqltype="cf_sql_integer">           		
                </cfquery>
            </cftransaction>
            
            <!--- send a mail to the employee --->
            <!--- <cfmail to="#arguments.Email#" subject="Login Access" from="do-not-reply@assetgear.net" 
            server="mail.assetgear.net" type="text/html" port="26" useTLS="true" username="do-not-reply@assetgear.net" password="CexF!ssHl%74"> --->
            <cfmail to="#arguments.Email#" subject="Login Access" from="AssetGear <do-not-reply@assetgear.net>" type="html">
                Hello,
                <p>
                    Below is your login details @ #this.url#<br/>
                    Username: #arguments.Email#<br/>
                    Password: #rndPwd#
                </p>
                You can change your password immediatly you login.
                <p>Thank you<br/> 
            </cfmail>
        <cfelse>
        	<cfset this.errmsg = "The email address #arguments.email# does not exist in the database."/>
        </cfif>
         
    </cffunction>

    <cffunction name="ChangePassword" access="public" returntype="void" hint="change the password" output="yes"> 
        <cfargument name="FormA" required="yes" type="struct" hint="login details struct data"> 
        
        <cfset f = arguments.FormA/> 

        <cfquery name="qC" >
            SELECT * FROM core_login
            WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#f.UserId#">
        </cfquery> 
        
        <cfset s = CreateObject("component","assetgear.com.awaf.Security").init()/>
        <cfset pKey = s.EncryptPassword(qC.Role,f.Email,f.CurrentPassword) />
            
        <cfif f.ConfirmNewPassword neq f.NewPassword>
        
        	<cfset this.errmsg = "Your new password does not tally with the confirmed password"/>
            
        <cfelseif pKey neq qC.PasswordKey>
			
			<cfset this.errmsg = "Your current password is wrong"/>

        <cfelse>    
            <cftransaction action="begin"> 
                <cfset nKey = s.EncryptPassword(qC.Role,f.Email,f.NewPassword) />
                <cfquery >
                    <cfif qC.Recordcount><!--- update --->
                        UPDATE core_login SET 
                            PasswordKey = <cfqueryparam value="#nKey#" cfsqltype="cf_sql_varchar">,
                            Role = <cfqueryparam value="#qC.Role#" cfsqltype="cf_sql_varchar">
                        WHERE LoginId = <cfqueryparam value="#qC.LoginId#" cfsqltype="cf_sql_integer"> 
                    <cfelse><!--- insert --->
                        INSERT INTO core_login	(
                            UserId, PasswordKey, Role 
                        )
                        VALUES	(
                            <cfqueryparam value="#f.UserId#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#nKey#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#qC.Role#" cfsqltype="cf_sql_varchar">
                        )                
                    </cfif>           		
                </cfquery>
            </cftransaction>         
        </cfif> 
    </cffunction>    
</cfcomponent>