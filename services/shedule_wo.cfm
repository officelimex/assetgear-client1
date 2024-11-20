<!--- schedule to generate work order --->
<cfsetting requesttimeout="99999999999"/>
<cfset application.com.PMTask = createobject('component','assetgear.com.awaf.ams.maintenance.PMTask').init()/>
<cfset application.com.PMTask.GenerateWorkOrder()/>