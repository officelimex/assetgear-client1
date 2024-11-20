<cfset application.com.Module = createobject('component','assetgear.com.awaf.Module').init()/>
<cfset application.com.Asset = createobject('component','assetgear.com.awaf.ams.maintenance.Asset').init()/>
<cfset application.com.PMTask = createobject('component','assetgear.com.awaf.ams.maintenance.PMTask').init()/>
<cfset application.com.Item = createobject('component','assetgear.com.awaf.ams.warehouse.Item').init()/>
<cfset application.com.Transaction = createobject('component','assetgear.com.awaf.ams.warehouse.Transaction').init()/>
<cfset application.com.WorkOrder = createobject('component','assetgear.com.awaf.ams.maintenance.WorkOrder').init()/>
<cfset application.Module = application.com.Module.SetupModuleIds()/>
<cfset application.com.Permit = createobject('component','assetgear.com.awaf.ams.ptw.Permit').init()/>
<cfset application.com.User = createobject('component','assetgear.com.awaf.User').init()/>
<cfset application.com.Notice = createobject('component','assetgear.com.awaf.ams.Notice').init()/>
<cfset application.com.Incident = createobject('component','assetgear.com.awaf.ams.maintenance.Incident').init()/>

<cfscript>
  System = createObject("java", "java.lang.System");
  System.setProperty("mail.debug", "true");
  System.setProperty("mail.smtp.ssl.protocols", "TLSv1.2");
</cfscript>
<cfset qPr = application.com.Module.getPrivileges(application.Module.Warehouse.id, request.userinfo.role)/>
<cfdump var="#qPr#"/>
<cfdump var="#request.userinfo.role#"/>
<cfobjectcache action="clear"/>
<cfdump var="#session#"/>
<cfdump var="#application#"/>
clear...
<!--- <cfoutput>
<cfmail 
  from="AssetGear <do-not-reply@assetgear.net>" 
  to="adexfe@live.com" 
  subject="AssetGear Notification" 
  type="text/html">

 
    <div class="content">
      <div class="header">AssetGear Notification</div>
      <div class="message">
        <p>Hello,</p>
        <p>This is a test notification from AssetGear.</p>
        <p>Thank you for using our service!</p>
      </div>
    </div>
 

</cfmail>
</cfoutput>
 --->