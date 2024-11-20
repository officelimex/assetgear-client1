<cfoutput> 
<cfif ThisTag.ExecutionMode EQ "Start"> 

    <cfparam name="Attributes.TagName" type="string" default="RadioBox"/> 
    <cfparam name="Attributes.name" type="string"/>
    <cfparam name="Attributes.Label" type="string" default="#Attributes.name#"/>
    <cfparam name="Attributes.ShowLabel" type="boolean" default="false"/>
    <cfparam name="Attributes.value" type="string" default=""/>
    <cfparam name="Attributes.class" type="string" default=""/>
    <cfparam name="Attributes.Inline" type="boolean" default="false"/>
    <cfparam name="Attributes.required" type="boolean" default="false"/>
    <cfparam name="Attributes.Help" type="string" default=""/>  
    <cfparam name="Attributes.height" type="string" default=""/>
    <cfparam name="Attributes.width" type="string" default=""/>
 
    <cfparam name="Attributes.ListValue" type="string" default=""> 
    <cfparam name="Attributes.ListDisplay" type="string" default="#Attributes.ListValue#">
    <cfparam name="Attributes.delimiters" type="string" default=",">
    <cfparam name="Attributes.selected" type="string" default="">

    <!--- bind --->
    <cfparam name="Attributes.bind" type="string" default=""/>
    <cfparam name="Attributes.Event" type="string" default=""/>
    <cfparam name="Attributes.data" type="string" default=""/>

    <cfparam name="request.form.formid" default=""/> 
 
 <div class="control-group">

    <cfset req = ""/> 
	<cfif Attributes.required>
    	<cfset req = "required"/>
    </cfif> 
    <cfif Attributes.ShowLabel><label for="#request.form.formid##Attributes.name#" class=" control-label">#Attributes.Label#</label></cfif>
    <cfset i=0/>
    <div class="controls" <cfif Attributes.height neq "">style="height:#Attributes.height#;overflow-y:auto;overflow-x:hidden; width:#Attributes.width#;"</cfif>>
    <cfloop list="#Attributes.ListValue#" index="lv" delimiters="#Attributes.delimiters#">
    <cfset i++/>
    <cfset dsp = ListGetAt(Attributes.ListDisplay,i,'#Attributes.delimiters#')/>
    	<cfif lv eq "$optgroup$">
        	<div style="background-color:##F7F7F7;padding-left:6px; margin-right:2px;border-top:##ddd 1px solid; font-weight:bold;">#dsp#</div>
        <cfelseif lv eq "$/optgroup$">
        	<!--- do nothing --->    
        <cfelse> 
    <cfset colr=""/>
	<cfif ListFindNoCase(Attributes.selected,lv)><cfset colr="color:red;"/></cfif>
 	<label class="radio <cfif Attributes.Inline>inline</cfif>" style="#colr#">

		<input type="radio" name="#Attributes.name#" class="#Attributes.class# #req#" value="#lv#" <cfif ListFindNoCase(Attributes.selected,lv)>checked="checked"</cfif>/> #dsp#
        
    </label> </cfif>
    </cfloop>
    <cfif Attributes.Help neq ""><p class="help-block">#Attributes.Help#</p></cfif>
<cfelse>
 </div></div>

<cfif Attributes.bind neq "">
    <script type="text/javascript">
    window.addEvent('domready', function()  {        
        $('#request.form.formid##Attributes.bind#').addEvent('#Attributes.Event#', function(e)  {
            new Request.JSON({
                url: '#Attributes.data#&id='+e.target.value,
                onFailure: function()   {
                    alert('error');
                }, 
                onSuccess: function(x){
                
                }
            }).send();  
        })
    });
    </script>
</cfif>   
</cfif> 
</cfoutput>