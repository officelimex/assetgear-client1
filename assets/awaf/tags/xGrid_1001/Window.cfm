<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">

    <cfparam name="Attributes.TagName" type="string" default="Window"/>
    <cfparam name="Attributes.Title" type="string" default=""/>	<!--- Use d[0,1,2] to capture the title of the wind e.g "'Edit '" + d[2] ---->
    <cfparam name="Attributes.warnBeforeClose" type="boolean" default="false"/>
    <cfparam name="Attributes.ShowHideButton" type="boolean" default="true"/>
    <cfparam name="Attributes.width" type="string" default="600px"/>
    <cfparam name="Attributes.height" type="string" default="300px"/>
    <cfparam name="Attributes.IdFromGrid" type="string" default="d[0]"/>
    <cfparam name="Attributes.Id" type="string" default=""/>
    <cfparam name="Attributes.URL" type="string"/> <!--- Use d[0,1,2] to capture the parameter to pass to the url e.g "'desc='" + d[2] ---->
    <!----- --->
    <cfparam name="Attributes.IsNewWindow" type="boolean" default="false"/>
    
    <cfassociate basetag="cf_Event"/>
        <cfswitch expression="#Attributes.IsNewWindow#">            
            <cfcase value="true">
                <cfset nid = "_" & left(createUUID(),6)/>
                <cfif find('?',Attributes.URL)>
                    window.open(#Attributes.URL#+'&id='+#Attributes.IdFromGrid#,'#nid#'+d[0],'',false);
                <cfelse>
                    window.open(#Attributes.URL#+'?id='+#Attributes.IdFromGrid#,'#nid#'+d[0],'',false);
                </cfif> 
            </cfcase>
            <cfdefaultcase>
                <cfif  Attributes.IdFromGrid eq "">
                var _w = new aWindow('#request.grid.renderTo#_#Attributes.Id#', {
                <cfelse>
                var _w = new aWindow('#request.grid.renderTo#_'+#Attributes.IdFromGrid#+'#Attributes.Id#',  {
                </cfif>
                    renderTo : $('#request.grid.renderTo#'),
                    title : #Attributes.Title#,
                    warnBeforeClose : #Attributes.warnBeforeClose#,
                    ctrlButtons : {
                        hide: #Attributes.ShowHideButton#
                    },
                    size : {
                        width: '#Attributes.width#',
                        height : '#Attributes.height#'
                    },
                    url :         
                <cfif  Attributes.IdFromGrid eq "">
                    #Attributes.URL#
                <cfelse>
                    <cfif find('?',Attributes.URL)>
                        #Attributes.URL#+'&id='+#Attributes.IdFromGrid#
                    <cfelse>
                        #Attributes.URL#+'?id='+#Attributes.IdFromGrid#
                    </cfif>
                </cfif>
                }); 
         
                _w.addCloseButton();                
            </cfdefaultcase>
 
        </cfswitch>
          
<cfelse> 
</cfif> 
</cfoutput>