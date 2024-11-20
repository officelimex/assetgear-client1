<cfset PmtId = "__permit_c_permit_for_fs_" & url.id/>

<cfinclude template="../inc/inc_permit.cfm"/>
<cfoutput>
<script>
	function approvePermit()	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Enter PIN to Approve Permit',
			url:'modules/ptw/permit/fs/enter_pin.cfm?id=#url.id#',
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
						url: 'modules/ajax/ptw.cfm?cmd=ConfirmPINForFS&id=#url.id#&pin='+$('__ptw_pin_fs').value,
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
							$('__ptw_pin_fs').value='';
							$('__ptw_pin_fs').focus();
						},
						onSuccess: function(r){
							aW.close();
							alert("Permit sent succesfuly, You can close the window now");
						},
						onComplete: function(){e.target.disabled=false;}
					}).send();
				}
			}
		})); 
	}
	
	function rejectPermit()	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Enter PIN & Comment for Permit',
			url:'modules/ptw/permit/fs/enter_pin2.cfm?id=#url.id#',
			renderTo: $('#PmtId#'),modal:true,
			size : {
				width : '330px', height : '200px'
			}	
		});  
		aW.addButton(new Element('input[type="button"]',{
			'value': 'Continue',
			'class' : 'btn btn-success',
			events:{
				click: function(e)	{
					// send pin to server and check if ok then sign the sign the doc
					new Request({
						url: 'modules/ajax/ptw.cfm?cmd=ConfirmPINForFSReject&id=#url.id#&pin='+$('__ptw_pin_fs').value+'&cmt='+encodeURIComponent($('__ptw_comment_fs').value),
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
							$('__ptw_pin_fs').value='';
							$('__ptw_pin_fs').focus();
						},
						onSuccess: function(r){
							aW.close();
							alert("A message has been sent to the creator of this Permit, You can close the window now");
						},
						onComplete: function(){e.target.disabled=false;}
					}).send();
				}
			}
		})); 
	}
</script>
</cfoutput>
