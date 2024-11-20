<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="TextBox"/> 
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.Label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default="input-large"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.help" type="string" default=""/>
    <cfparam name="Attributes.inlinehelp" type="string" default=""/>
    <cfparam name="Attributes.Validate" type="string" default=""/><!---integer, numeric, digits, alpha, alphanum, date, email, url---->
    <cfparam name="Attributes.hint" type="string" default=""/>
    <cfparam name="Attributes.Disabled" type="boolean" default="false"/>
    <cfparam name="Attributes.Type" type="string" default="text"/>
    
    <cfassociate basetag="cf_form" /> 
    <cfset req = ""/>
	<cfset vali = ""/>
    
 <div class="control-group">
    <cfif Attributes.Type neq "Hidden">
        <label for="#request.form.formid##Attributes.name#" class="control-label">#Attributes.Label#
        <cfif Attributes.required><i class="red">*</i>
            <cfset req = "required"/> 
        </cfif></label>
    </cfif>

	<div class="controls"> 
    <cfswitch expression="#Attributes.Validate#">
    	<cfcase value="integer,numeric,digits,alpha,alphanum,date,email" delimiters=",">
			<cfset vali = ListAppend(vali,'validate-#Attributes.Validate#',' ')/>
        </cfcase>
        <cfdefaultcase>
        	<cfset vali = ListAppend(vali,'#Attributes.Validate#',' ')/>
        </cfdefaultcase>
    </cfswitch>
    <!---<cfif FindNoCase('integer',Attributes.Validate)>
    	<cfset vali = ListAppend(vali,'validate-integer',' ')/>
    </cfif>--->
	<input  autocomplete="off" <cfif Attributes.Disabled>disabled="disabled"</cfif> type="#Attributes.Type#" id="#request.form.formid##Attributes.name#" name="#Attributes.name#" style="display:inline-block" class="#Attributes.class# #req# #vali#" value="#Attributes.value#" placeholder="#Attributes.hint#"/> 
    <cfif Attributes.InlineHelp neq ""><span class="help-inline">#Attributes.inlinehelp#</span></cfif>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
<cfelse>
 </div></div>  
</cfif> 
</cfoutput>