<cfset PmtId = "__permit_c_permit_for_hse_" & url.id/>

<cfinclude template="../inc/inc_permit.cfm"/>
<cfoutput>
<script>

	function sendToSupervisor()	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Send Back to Supervisor',
			url:'modules/ptw/permit/hse/send_back.cfm?id=#url.id#',
			renderTo: $('#PmtId#'), modal:true,
			size : {
				width : '500px', height : '300px'
			}	
		});  
		aW.addButton(new Element('input[type="button"]',{
			'value': 'Send',
			'class' : 'btn btn-success',
			events:{
				click: function(e)	{
					var param = 'msg=' + $('__ptw_hse_msg').value;
					// change the status of the ptw and send a mail back to the creator/supervisor
					new Request({
						url: 'modules/ajax/ptw.cfm?cmd=SendBackToPA&id=#url.id#',
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
						},
						onSuccess: function(r){
							aW.close();
							alert("Permit was successfully sent back to originating unit/department");
							$('#PmtId#').dispose();
						},
						onComplete: function(){e.target.disabled=false;}
					}).send(param);
				}
			}
		})); 
	}

	function sendToFS()	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Enter PIN to Approve Permit',
			url:'modules/ptw/permit/hse/enter_pin.cfm?id=#url.id#',
			renderTo: $('#PmtId#'),modal:true,
			size : {
				width : '400px', height : '100px'
			}	
		});  
		aW.addButton(new Element('input[type="button"]',{
			'value': 'Continue',
			'class' : 'btn btn-success',
			events:{
				click: function(e)	{
					// send pin to server and check if ok then sign the sign the doc
					new Request({
						url: 'modules/ajax/ptw.cfm?cmd=ConfirmPINForHSE&id=#url.id#&pin='+$('__ptw_pin_hse').value,
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
							$('__ptw_pin_hse').value='';
							$('__ptw_pin_hse').focus();
						},
						onSuccess: function(r){
							aW.close();
							alert("Permit sent successfully, You can close the window now");
							$('#PmtId#').dispose();
						},
						onComplete: function(){e.target.disabled=false;}
					}).send();
				}
			}
		})); 
	}
</script>
</cfoutput>
