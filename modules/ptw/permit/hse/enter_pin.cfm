<br>
<div align="center">
	<cfset qP = application.com.Permit.GetPermit(url.id)/> 
	<cfif val(qP.HSApprovedByUserId) eq 0>
		<input id="__ptw_pin_hse" type="password" maxlength="4" style="font-size:30px; height:50px; text-align:center; color:red; letter-spacing:30px; width:300px"/>
	<cfelse>
		This permit has already been Approved and sent to Field Supervisor
	</cfif>
</div>