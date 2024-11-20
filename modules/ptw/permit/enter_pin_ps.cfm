<br>
<div align="center">
	<cfset qP = application.com.Permit.GetPermit(url.id)/> 
    <cfif val(qP.FSApprovedByUserId) eq 0 or qP.FSC eq "">
    	<input id="__ptw_pin_ps" type="password" maxlength="4" style="font-size:30px; height:50px; text-align:center; color:red; letter-spacing:30px; width:300px"/>    
    <cfelse>
    	<cfif qP.Completed neq "">
        	This Permit is closed
        <cfelse>
    		This permit has already been Approved and sent to the HSE
    	</cfif>
    </cfif>
</div>