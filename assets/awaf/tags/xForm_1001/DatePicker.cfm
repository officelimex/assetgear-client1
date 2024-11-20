<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="DatePicker"/> 
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.id" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.Label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default="input-large"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.inlinehelp" type="string" default=""/>
    <cfparam name="Attributes.type" type="string" default="date"/> <!--- date, time, datetime --->
    <!---<cfparam name="Attributes.Validate" type="string" default=""/>integer,---->
    
    <cfif isdate(Attributes.value)>
    	<cfswitch expression="#Attributes.type#">
        	<cfcase value="date"><cfset Attributes.value="#dateformat(Attributes.value,'yyyy-mm-dd')#"/></cfcase>
            <cfcase value="datetime"><cfset Attributes.value="#dateformat(Attributes.value,'yyyy-mm-dd')# #timeformat(Attributes.value,'hh:mm tt')#"/></cfcase> 
    	</cfswitch>
    </cfif>
    <cfassociate basetag="cf_form" /> 
    <cfset req = ""/>
	<cfset vali = ""/>
    
 <div class="control-group">
    <label for="#request.form.formid##Attributes.name#" class="control-label">#Attributes.Label#
    <cfif Attributes.required><i class="red">*</i>
    	<cfset req = "required"/> 
    </cfif></label>
	<div class="controls"> 
<!---    <cfif FindNoCase('integer',Attributes.Validate)>
    	<cfset vali = ListAppend(vali,'validate-integer',' ')/>
    </cfif>--->
	<input type="text" id="#request.form.formid##Attributes.id#" autocomplete="off" name="#Attributes.name#" class="<cfif Attributes.type eq "date">span5</cfif> #Attributes.class# #req# #vali#" value="#Attributes.value#"/> 
    <cfif Attributes.InlineHelp neq ""><span class="help-block">#Attributes.inlinehelp#</span></cfif>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
<cfelse>
 </div></div>  
	<script>

	window.addEvent('domready', function(){
		new Picker.Date('#request.form.formid##Attributes.id#', {
			<cfif Attributes.type eq "datetime">timePicker:true,format:'db',<cfelse>format:'db',</cfif>
			pickerClass: 'datepicker_vista'
		});
	});

	</script> 
 
</cfif> 
</cfoutput>