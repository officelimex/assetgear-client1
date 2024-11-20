<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="CustomTextBox"/> 
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.Label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.CustomFieldId" type="numeric" default="0"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default="input-large"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.inlinehelp" type="string" default=""/>
    <cfparam name="Attributes.Validate" type="string" default=""/><!---integer,---->
    
    <cfassociate basetag="cf_form" /> 
    <cfset req = ""/>
	<cfset vali = ""/>
    
<cfset spid = "_" & left(CreateUUID(),'8')/>
    
 <div class="control-group">
    <label for="#request.form.formid##Attributes.name#" class="control-label"><span onDblClick="__#spid#();" id="#spid#">#Attributes.Label#</span>
    
    <cfif Attributes.required><i class="red">*</i>
    	<cfset req = "required"/> 
    </cfif></label>
	<div class="controls"> 
    <cfif FindNoCase('integer',Attributes.Validate)>
    	<cfset vali = ListAppend(vali,'validate-integer',' ')/>
    </cfif>
	<input type="text" id="#request.form.formid##Attributes.name#" name="#Attributes.name#" class="#Attributes.class# #req# #vali#" value="#Attributes.value#"/> 
    <cfif Attributes.InlineHelp neq ""><span class="help-block">#Attributes.inlinehelp#</span></cfif>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
    <input type="hidden" id="#request.form.formid##Attributes.name#_label" name="#Attributes.name#_label" value="#Attributes.Label#"/>
    <input type="hidden" name="#Attributes.name#_id" value="#Attributes.CustomFieldId#"/>
<cfelse>
 </div></div>  
</cfif> 
<script>
	function __#spid#()	{
		var cf = prompt("Please enter Custom field name","#Attributes.Label#");
		if(cf!=null)	{
			$('#request.form.formid##Attributes.name#_label').value = cf;
			$('#spid#').set('html',cf);
		}
	}
</script>

</cfoutput>