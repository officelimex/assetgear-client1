<!--- Author:	Arowolo Abiodun M.
----- Created	21/02/2012
----- Updated	21/02/2012
----- Copyright	adexfe systems (c) 2009
----- About		xForm Coldfusion custom tag --->

<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start"> 
    
    <cfparam name="Attributes.TagName" type="string" default="Select"/>
	<cfparam name="Attributes.Name" type="string">
    <cfparam name="Attributes.Label" type="string" default="#Attributes.Name#"/>
    <cfparam name="Attributes.ShowLabel" type="boolean" default="true"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/> 
    <cfparam name="Attributes.IsMultiple" type="boolean" default="false"/> 
    <cfparam name="Attributes.Height" type="string" default=""/>
    <cfparam name="Attributes.Disabled" type="boolean" default="false"/> 
    
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.ListValue" type="string" default=""/> 
    <cfparam name="Attributes.ListDisplay" type="string" default="#Attributes.ListValue#"/>
    <cfparam name="Attributes.delimiters" type="string" default=","/>  
	<cfparam name="Attributes.Selected" type="string" default=""/>
    <cfparam name="Attributes.Help" type="string" default=""/>
    <cfparam name="Attributes.inlinehelp" type="string" default=""/>
    
    <cfparam name="Attributes.AutoSelect" type="boolean" default="false"/>
    
    <cfparam name="Attributes.onchange" type="string" default=""/>
    
 	<cfparam name="request.form.formid" default=""/>
    <cfset req = ""/> 
 <div class="control-group">
    <cfif Attributes.ShowLabel><label for="#request.form.formid##Attributes.name#" class="control-label">#Attributes.Label#	<cfif Attributes.required>
    	<cfset req = "required"/><i class="red">*</i>
    </cfif></label></cfif>
	<div class="controls">
<cfset el_id = "#request.form.formid##Attributes.name#"/>
	<select <cfif Attributes.Disabled>disabled="disabled"</cfif> <cfif Attributes.onchange neq "">onchange="#Attributes.onchange#"</cfif> id="#el_id#"   name="#Attributes.name#" class="#Attributes.class# #req#" <cfif Attributes.IsMultiple>multiple="multiple" <Cfif Attributes.Height neq "">style="height:#Attributes.Height#;"</cfif></cfif>>
    <cfset i=0/>
    
    <option <cfif Attributes.Selected eq "" or Attributes.Selected eq 0>selected</cfif> value=""> - </option>
    <cfloop list="#Attributes.ListValue#" index="lv" delimiters="#Attributes.delimiters#">
    	<cfset i++/>
		<cfset dsp = ListGetAt(Attributes.ListDisplay,i,'#Attributes.delimiters#')/>
        <!--- check if the value is $optgroup$, then group --->
        <cfif lv eq "$optgroup$">
        	<optgroup label="#dsp#">
        <cfelseif lv eq "$/optgroup$"> 
        	</optgroup>
        <cfelse>
    		<option value="#lv#" <cfif ListFindNoCase(Attributes.Selected,lv)>selected</cfif>>#dsp#</option>
        </cfif>
     </cfloop>

<cfelse>
 </select>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
    <cfif Attributes.InlineHelp neq ""><span class="help-inline">#Attributes.inlinehelp#</span></cfif>
</div></div>
<cfif Attributes.AutoSelect>
<script>
	window.addEvent('domready', function(){
		new Meio.Autocomplete.Select.One($('#el_id#'),{
			//name:'#Attributes.Name#',
			styles:	{width:''},
			classname:'#Attributes.class# #req#'		
		});
	});
</script>
</cfif>  
</cfif> 
</cfoutput>