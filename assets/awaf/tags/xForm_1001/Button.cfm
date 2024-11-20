<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

	<cfparam name="request.form.buttton.count" default="0"/>
    
    <cfset request.form.buttton.count ++/>
    
    <cfparam name="Attributes.TagName" type="string" default="Button"/> 
    <cfparam name="Attributes.Value" type="string" default="Button #request.form.buttton.count#"/> 
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.IsSave" type="boolean" default="false"/> 
    <cfparam name="Attributes.ReloadURL" type="string" default=""/>
    <cfparam name="Attributes.subpageId" type="string" default=""/>
    <cfparam name="Attributes.onClick" type="string" default=""/>
	<cfparam name="Attributes.beforeSave" type="string" default=""/> <!--- run js script before saving --->
    <cfparam name="Attributes.actionURL" type="string" default=""/> <!--- change the action on the form --->
	<cfparam name="Attributes.IsNewWindow" type="boolean" default="false"/> <!--- open in a new window --->
	

	<cfif Attributes.IsNewWindow><cfset Attributes.IsSave = false/></cfif>
	<cfif Attributes.IsSave><cfset Attributes.IsNewWindow = false/></cfif>
 
	<cfassociate basetag="cf_form" />   

		$('#request.form.formid#_bg').adopt(new aButton('',{
			value: '#Attributes.Value#',
			'class' : '#Attributes.class#',
			styles :	{
				'margin-left' : '10px'
			},
			click:function(e)	{
				var frm = '#request.form.formid#';
				#Attributes.beforeSave#
				<cfif Attributes.actionURL neq "">
					$(frm).set('action','#Attributes.actionURL#');
				</cfif>
				new Form.Validator.Inline($(frm), {
					onFormValidate: function(passed, form, event) {
						if (passed) {
							<cfif Attributes.IsSave>
								$(frm).set('send', {
									onRequest: function(){e.target.disabled=true},
									onFailure: function(r){showError(r);},
									onSuccess: function(r){ 
										if(r.trim()==''){r='Your data was saved sucessfuly. Please refresh to see change.'}
											var an = new aNotify();
											an.alert('Success!',r);  
											$(frm).reset();
											<!--- clear the form by replaading the url --->
											<cfif Attributes.ReloadURL neq "">
												<cfset d = "__" & listgetat(request.form.formid,'1','_') & "_c_" & Attributes.subpageId/>
												<!---TODO: Work on the bug on the listgetat---->
												$('#d#').set('load', {method: 'post'});
												$('#d#').load('#Attributes.ReloadURL#');
												console.log($('#d#'));
											</cfif> 
											<!------>
									},
									onComplete: function(){e.target.disabled=false;}
								}).send();
							</cfif>
							<cfif Attributes.IsNewWindow>
								$(frm).set('target','_blank');
								$(frm).submit();
							</cfif>
						}
				}}).validate(); 
				<cfif Attributes.OnClick neq "">
					#Attributes.OnClick#
				</cfif>
			}
		}));
<cfelse>
 
</cfif> 
</cfoutput>