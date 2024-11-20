<cfcomponent>

	<cffunction name="init" access="public" returntype="Notice">

		<cfset this.NOTICE_SQL = '
			SELECT
				n.*,
				CONCAT(r.Surname," ",r.OtherNames) Recipient,
				CONCAT(s.Surname," ",s.OtherNames) Sender
			FROM core_notice n
			LEFT JOIN core_user r ON r.UserId = n.RecipientId
			INNER JOIN core_user s ON s.UserId = n.SenderId
		'/>
		<cfreturn this>
	</cffunction>

	<cffunction name="SendNotice" access="public" returntype="void" hint="send notification to someone">
		<cfargument name="s" hint="sender id" type="numeric"/>
		<cfargument name="r" hint="recipient id" type="numeric"/>
		<cfargument name="rd" hint="Recipient department Id" type="numeric"/>
		<cfargument name="ru" hint="Recipient unit Id" type="numeric"/>
		<cfargument name="m" hint="module name" type="string"/>
		<cfargument name="n" hint="messaga to send" type="string" required="yes"/>
		<cfargument name="pk" hint="primary key id" type="numeric"/>
		<cfargument name="rl" hint="role" type="string" default="" required="no"/>

			<cfquery>
				INSERT INTO core_notice SET
					SenderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s#"/>,
					RecipientId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.r#"/>,
					RecipientDepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rd#"/>,
					`Message` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.n#"/>,
					`Module` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.m#"/>,
					`Date` = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"/>,
					`PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pk#"/>,
					`Role` = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.rl#"/>
			</cfquery>

			<!--- get sender info --->
			<cfquery name="qS">
				SELECT CONCAT(Surname,' ',OtherNames) Name, Email  FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s#"/>
			</cfquery>
			<!--- get receiptant --->
			<cfif arguments.rd neq 0>
				<cfquery name="qR">
					SELECT Name, Email  FROM core_department WHERE DepartmentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.rd#"/>
				</cfquery>
			</cfif>
			<cfif arguments.r neq 0>
				<cfquery name="qR">
					SELECT CONCAT(Surname,' ',OtherNames) Name, Email  FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.r#"/>
				</cfquery>
			</cfif>
			<cfswitch expression="#arguments.rl#">
				<cfcase value="FS">
					<cfset qR = {}/>
					<cfset qR.Name = "FS"/>
					<cfset qR.Email = "operations@#application.domain#"/>
				</cfcase>
				<cfcase value="PS">
					<cfset qR = {}/>
					<cfset qR.Name = "PS"/>
					<cfset qR.Email = "fieldsupervisor@#application.domain#"/>
				</cfcase>
				<cfcase value="HSE">
					<cfset qR = {}/>
					<cfset qR.Name = "HSE"/>
					<cfset qR.Email = "hse@#application.domain#"/>
				</cfcase>
			</cfswitch>
			<cfswitch expression="#arguments.rd#">
				<cfcase value="16">
					<cfset qR = {}/>
					<cfset qR.Name = "MTCE"/>
					<cfset qR.Email = "mtce@#application.domain#"/>
				</cfcase>
			</cfswitch>

			<!--- send mail--->
			<cfif IsDefined('qR')>
					
				<cfset i = SendEmail("#qR.Email#","Alert: #ucase(arguments.m)# ###arguments.pk#","#arguments.n#")/>
					
			</cfif>

	</cffunction>

	<cffunction name="CloseNotice" returntype="void" hint="close notification" access="public">
		<cfargument name="nid" required="yes" type="numeric" hint="notice id"/>

		<cfquery>
			UPDATE core_notice SET `Status` = "c"
				WHERE NoticeId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.nid#"/>
		</cfquery>

	</cffunction>

	<cffunction name="CloseNoticeByModule" returntype="void" hint="close notification" access="public">
		<cfargument name="pk" required="yes" type="numeric" hint="module primary key id"/>
		<cfargument name="m" required="yes" type="string" hint="module"/>

		<cfquery>
			UPDATE core_notice SET `Status` = "c"
				WHERE `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pk#"/>
					AND Module = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.m#"/>
		</cfquery>

	</cffunction>

	<cffunction name="SendBackMail" returntype="void" access="public">
		<cfargument name="subject" required="true" type="string"/>
		<cfargument name="toid" required="true" type="numeric"/>
		<cfargument name="msg" required="true" type="string"/>

		<cfquery name="qR">
				SELECT Email  FROM core_user WHERE UserId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.toid#"/>
		</cfquery>

		<cfset i = SendEmail("#qR.Email#","#arguments.subject#","#arguments.msg#")/>

	</cffunction>

	<cffunction name="GetNoticeByModule" returntype="query" hint="get notification" access="public">
		<cfargument name="pk" required="yes" type="numeric" hint="module primary key id"/>
		<cfargument name="m" required="yes" type="string" hint="module"/>

		<cfquery name="qN">
			#this.NOTICE_SQL#
				WHERE n.PK = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pk#"/>
					AND n.Module = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.m#"/>
						AND n.Status = "o"
		</cfquery>

		<cfreturn qN/>
	</cffunction>

	<cffunction name="SendEmail" returntype="void" hint="Send Email" access="public">
		<cfargument name="to" required="yes" type="string" hint="Reciver of the mail"/>
		<cfargument name="subject" required="yes" type="string" hint="Subject of email"/>
		<cfargument name="msg" required="yes" type="string" hint="Subject of message"/>
		<cfargument name="cc" required="no" type="string"/>
		<cfargument name="bcc" required="no" type="string"/>

<!--- 		<cfset mailAttributes = {
			server="mail.assetgear.net",
			username="do-not-reply@assetgear.net",
			password="CexF!ssHl%74",
			from="do-not-reply@assetgear.net",
			to="#arguments.to#", 
			cc="#arguments.cc#",
			subject="#arguments.subject#"
		}/> --->

		<!----
			ses-smtp-user.20241019.assetgear
			AKIA2I3JCTXEC3JVAKX7
			BI2jle3vnR2jINXb5Gq4LumH4x+7rw/Wr8TkgLOBdKmX
		----> 

		<!----
			TODO: allow closure of work order with zero value in materials not in warehouse
			60314
			60314
			60314
		---->
	
		<cfmail from="AssetGear <do-not-reply@assetgear.net>" to="#arguments.to#" cc="#arguments.cc#" bcc="#arguments.bcc#" subject="#arguments.subject#" type="html">
			<html>
				<head></head>
				<body>
					<strong>AssetGear Notification</strong><br><br>
					<div>#arguments.msg#<br></div>
				</body>
			</html>
		</cfmail>


		<cfreturn 0/>
	</cffunction>
		 
</cfcomponent>
