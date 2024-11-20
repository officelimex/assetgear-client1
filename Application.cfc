<cfcomponent>

	<cfset variables.appName = "app"/>
	<cfset variables.companyName = "App"/>
	<cfset variables.domain = "app.com"/>

	<cfset this.name = "#variables.appName#_ams">
	<cfset this.applicationTimeout = createTimeSpan(1,0,0,0)>
	<cfset this.clientmanagement= "yes">
	<cfset this.ClientStorage = "cookie">
	<cfset this.sessionmanagement = "yes">
	<cfset this.sessiontimeout = createTimeSpan(0,5,0,0)>
	<cfset this.setClientCookies = "yes"/>
	<cfset this.datasource = "#variables.appName#_ams"/>
	<cfset this.pdf.type = "classic"/>
	
  <cffunction name="onApplicationStart" output="false">

		<cfset application.appName = variables.appName/>
		<cfset application.domain = variables.domain/>
		<cfset application.companyName = variables.companyName/>
		<cfset application.companyAddress = ""/>
		<cfset application.site.url = "http://localhost/assetgear-#application.appName#/"/>
		
		<!--- save the most used components(CFC) into an application variable --->
		<cfset application.com.Module = createobject('component','assetgear.com.awaf.Module').init()/>
		<cfset application.com.Asset = createobject('component','assetgear.com.awaf.ams.maintenance.Asset').init()/>
		<cfset application.com.PMTask = createobject('component','assetgear.com.awaf.ams.maintenance.PMTask').init()/>
		<cfset application.com.Item = createobject('component','assetgear.com.awaf.ams.warehouse.Item').init()/>
		<cfset application.com.Transaction = createobject('component','assetgear.com.awaf.ams.warehouse.Transaction').init()/>
		<cfset application.com.WorkOrder = createobject('component','assetgear.com.awaf.ams.maintenance.WorkOrder').init()/>
		<cfset application.com.Permit = createobject('component','assetgear.com.awaf.ams.ptw.Permit').init()/>
		<cfset application.com.User = createobject('component','assetgear.com.awaf.User').init()/>
		<cfset application.com.Notice = createobject('component','assetgear.com.awaf.ams.Notice').init()/>
		<cfset application.com.Incident = createobject('component','assetgear.com.awaf.ams.maintenance.Incident').init()/>

		<cfset application.Module = application.com.Module.SetupModuleIds()/>

		<cfset application.AppModuleId = 'app_module'/>

		<cfscript>
			System = createObject("java", "java.lang.System");
			System.setProperty("mail.debug", "true");
			System.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
		</cfscript>

  </cffunction>

  <cffunction name="onApplicationEnd" output="false">
    <cfargument name="applicationScope" required="true">

  </cffunction>

	<cffunction name="onRequestStart">
		<cfargument name="requestname" required="true" />

		<cflock type="exclusive" scope="session" timeout="10">
			<cfparam name="session.IsLogin" default="false" type="boolean" />
			<cfparam name="session.Userinfo" default="" />
			<cfparam name="session.loginType" default="guest"/>
			<cfparam name="session.Delegate" default="" />
		</cflock>

		<cflock type="readonly" scope="session" timeout="40">
			<cfset request.IsLogin = session.IsLogin />
			<cfset request.UserInfo = session.UserInfo />
			<cfset request.loginType = session.loginType />
			<cfset request.Delegate = session.Delegate />
		</cflock>

		<cfparam name="request.IsHost" default="false" type="boolean"/>
		<cfparam name="request.IsWarehouseMan" default="false" type="boolean"/>
		<cfparam name="request.IsMS" default="false" type="boolean"/>
		<cfparam name="request.IsAdmin" default="false" type="boolean"/>
		<cfparam name="request.IsHSE" default="false" type="boolean"/>
		<cfparam name="request.IsPS" default="false" type="boolean"/>
		<cfparam name="request.IsSV" default="false" type="boolean"/>
		<cfparam name="request.IsFS" default="false" type="boolean"/>

		<cfif IsDefined("request.userinfo.role")>
			<cfswitch expression="#request.userinfo.role#">
				<cfcase value="HT"><cfset request.IsHost = true/></cfcase>
				<cfcase value="WH"><cfset request.IsWarehouseMan = true/></cfcase>
				<cfcase value="MS"><cfset request.IsMS = true/></cfcase>
				<cfcase value="AD"><cfset request.IsAdmin = true/></cfcase>
				<cfcase value="HSE"><cfset request.IsHSE = true/></cfcase>
				<cfcase value="PS"><cfset request.IsPS = true/></cfcase>
				<cfcase value="FS"><cfset request.IsFS = true/></cfcase>
				<cfcase value="SV"><cfset request.IsSV = true/></cfcase>
			</cfswitch>
		</cfif>
		<!--- delegated role ---->
		<cfparam name="request.IsPSDelegated" default="false" type="boolean"/>
		<cfparam name="request.IsFSDelegated" default="false" type="boolean"/>

		<cfif IsQuery(request.Delegate)>
			<cfif request.Delegate.Recordcount>
			<!--- TODO: check date too --->
				<cfswitch expression="#request.delegate.role#">
					<cfcase value="PS"><cfset request.IsPSDelegated = true/></cfcase>
					<cfcase value="FS"><cfset request.IsFSDelegated = true/></cfcase>
				</cfswitch>
      </cfif>
    </cfif>
	  
		<!---cfset application.com.Module = createobject('component','assetgear.com.awaf.Module').init()/>
		<cfset application.com.Asset = createobject('component','assetgear.com.awaf.ams.maintenance.Asset').init()/>
		<cfset application.com.PMTask = createobject('component','assetgear.com.awaf.ams.maintenance.PMTask').init()/>
		<cfset application.com.Item = createobject('component','assetgear.com.awaf.ams.warehouse.Item').init()/>
		<cfset application.com.Transaction = createobject('component','assetgear.com.awaf.ams.warehouse.Transaction').init()/>
		<cfset application.com.WorkOrder = createobject('component','assetgear.com.awaf.ams.maintenance.WorkOrder').init()/>
		<cfset application.com.Permit = createobject('component','assetgear.com.awaf.ams.ptw.Permit').init()/>
		<cfset application.com.User = createobject('component','assetgear.com.awaf.User').init()/>
		<cfset application.com.Notice = createobject('component','assetgear.com.awaf.ams.Notice').init()/--->
	  
		<!--- Check who is visiting and redirect to proper site --->
		<cfif !request.IsLogin && ListContainsNoCase('update_spare_parts.cfm,register.cfm,login.cfm,forget.cfm,error.cfm,clear.cfm,shedule_wo.cfm,pwd.cfm,backup.cfm,backup2.cfm,update_spare_parts.cfm,due_for_order.cfm,sync.cfc,expire_alert.cfm,reminder.cfm',listlast(cgi.SCRIPT_NAME,'/')) eq 0 >
			<cflocation url="login.cfm" addtoken="no"/>
		</cfif>

   </cffunction>

</cfcomponent>
