<cfparam name="url.wid" default="revalidate_permit"/> 

<cfset PmtId = "__permit_c_#url.wid#_" & url.id/>

<cfinclude template="../inc/inc_permit.cfm"/>

<cfoutput>
<script>
	/*
	* @param cmd: string command to send to the server 
	* @param title: string window title
	* @param msg: string message
	*/
	function OpenPINWindow(cmd,title,msg)	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Enter PIN to '+title,
			url:'modules/ptw/permit/enter_pin_ps.cfm?id=#url.id#',
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
						url: 'modules/ajax/ptw.cfm?cmd='+cmd+'&id=#url.id#&pin='+$('__ptw_pin_ps').value,
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
							$('__ptw_pin_ps').value='';
							$('__ptw_pin_ps').focus();
						},
						onSuccess: function(r){
							aW.close();
							alert(msg+", You can close the window now"); 
							$('#PmtId#').dispose();
						},
						onComplete: function(){e.target.disabled=false;}
					}).send();
				}
			}
		})); 
	}	
	

	/*
	* revalidate permit for the next 24 hours 
	*/
	function RevalidatePermit()	{
		OpenPINWindow('ConfirmPINValidatePermit','Revalidate Permit','Permit was validated for another 24hours');
	}
	
</script>
</cfoutput>
