<!--- send alert to the owner of an asset before its expired date --->

<cfquery name="qE">
	SELECT
		e.*,
		a.Description Asset, a.DepartmentIds
	FROM expiration e
	INNER JOIN asset a ON a.AssetId = e.AssetId
	WHERE e.Reminder <> 0
	AND e.Date > CURDATE()
</cfquery>
<cfoutput>
<cfloop query="qE">
	<cfset ddif = dateDiff("d", now(),qE.Date)/>

	<cfif ddif lte qE.Reminder>
		<!--- get the email of the department that own the asset --->
		#ddif#
		<cfset em_ = "operations@#application.domain#"/>
		<cfif qE.DepartmentIds neq "">
			<cfquery name="qD" cachedwithin="#createTimespan(1,0,0,0)#">
				SELECT Email FROM core_department
				WHERE DepartmentId IN (#qE.DepartmentIds#)
			</cfquery>
			<cfset em_ = valueList(qD.Email)/>
			<cfdump var="#qD#"/>
		</cfif>
		<!--- send alert 
		<cfmail from="do-not-reply@assetgear.net" username="do-not-reply@assetgear.net" password="CexF!ssHl%74" server="mail.assetgear.net" to="" subject="" type="text/html">
			
		</cfmail>--->
		<cfset i = application.com.Notice.SendEmail("#em_#","Reminder: #qE.Asset# Expiration","
			Hello,
			<p>
			Expiration of #qE.Title# is on #dateformat(qE.Date,"ddd d, mmmm yyyy")#.
			</p>
			Thank you"																				   
	    )/>
	</cfif>
</cfloop>
</cfoutput>
<cfdump var="#qE#"/>
