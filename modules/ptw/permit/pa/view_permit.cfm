<cfparam name="url.wid" default="permit_for_pa"/>

<cfset PmtId = "__permit_c_#url.wid#_" & url.id/>

<cfinclude template="../inc/inc_permit.cfm"/>
<cfoutput>
<script>
	/**
	 * Ask for extension of permit by performaing authority
	 * @return {void}
	 */
	function AskForExtension()	{
		if(confirm('Are you sure you want to send this Permit to the Field Supervisor for revalidation?'))	{
			new Request({
				url: 'modules/ajax/ptw.cfm?cmd=AsForPermitEstension' + '&id=#url.id#',
				onRequest: function(){},
				onFailure: function(r){showError(r);},
				onSuccess: function(r){
					alert("Your Permit was successfuly send the Field Supervisor");
					$('__permit_c_permit_for_pa_#url.id#').dispose();
				},
				onComplete: function(){}
			}).send();			
		}
	}
	
	/*
	 * @param cmd string command to send to the server 
	 * @title msg string window title
	 */
	function OpenPINWindow(cmd,title)	{
		var aW = new aWindow('_#left(CreateUUID(),6)#',{
			title:'Enter PIN to Flag Permit as ' + title,
			url:'modules/ptw/permit/pa/enter_pin.cfm?id=#url.id#',
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
						url: 'modules/ajax/ptw.cfm?cmd='+ cmd + '&id=#url.id#&pin='+$('__ptw_pin_pa').value,
						onRequest: function(){e.target.disabled=true;},
						onFailure: function(r){
							showError(r); 
							$('__ptw_pin_pa').value='';
							$('__ptw_pin_pa').focus();
						},
						onSuccess: function(r){
							aW.close();
							alert("Your Permit was successfuly closed");
							$('__permit_c_permit_for_pa_#url.id#').dispose();
						},
						onComplete: function(){e.target.disabled=false;}
					}).send();
				}
			}
		})); 
	}

	/**
	* bring up the work complete window
	* @return void
	*/
	function workCompleted()	{
		OpenPINWindow('ConfirmPINForPAComplete','Completed');
	}
	
	/**
	* bring up the work complete window
	* @return void
	*/
	function workNotCompleted()	{
		OpenPINWindow('ConfirmPINForPANotComplete','Completed');
	}	
</script>
</cfoutput>
