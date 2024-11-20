<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="Table"/> 
    <cfparam name="Attributes.Id" default="_#left(createUUID(),'8')#" />
    <cfparam name="Attributes.height" type="string" default="315px"/>
    <cfparam name="Attributes.headers" type="string"/>
 
<div style="max-height:#Attributes.height#;overflow-y:auto;overflow-x:hidden; padding-right:5px;" id="#Attributes.Id#">
 
<cfelse>
<script type="text/javascript">
window.addEvent('domready', function()  {       
    var af = new aEditTable('#Attributes.Id#',{
        'headers': [
            {},
        ]
        'tempfolder':'#Attributes.tempfolder#',
        <cfswitch expression="#Attributes.accept#">
            <cfcase value="#dphoto#" delimiters=",">'accept':'image/*'</cfcase>
            <cfdefaultcase>'accept':''</cfdefaultcase>
        </cfswitch>
            
    });
    /* add 1 upload slot */
    af.addUploadSection();
});
</script>

</cfif>
</div> 
</cfoutput>