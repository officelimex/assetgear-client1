<cfoutput>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="FileView"/> 
    <cfparam name="Attributes.type" />
    <cfparam name="Attributes.height" type="string" default="315px"/>
    <cfparam name="Attributes.source" type="string"/>
    <!--- display ---->
    <cfparam name="Attributes.table" type="string" default=""/>
    <cfparam name="Attributes.pk" type="numeric" default="0"/>
 
<div style="max-height:#Attributes.height#;overflow-y:auto;overflow-x:hidden; width:400px; padding-right:5px;">


    <cfswitch expression="#Attributes.type#">
        <cfcase value="a">
        	<cfparam name="Attributes.column" type="numeric" default="4"/>
            <cfparam name="Attributes.span" type="numeric" default="12"/>
        </cfcase>
        <cfdefaultcase>
            <cfparam name="Attributes.column" type="numeric" default="12"/>
            <cfparam name="Attributes.span" type="numeric" default="12"/>
        </cfdefaultcase>
    </cfswitch>
    <cfquery name="qF">
        SELECT * FROM `file`
        WHERE `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.table#"/>
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.pk#"/>
                AND `Type` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="1" value="#Attributes.type#"/>
    </cfquery>

    <cfif qF.recordcount>
    <div class="row-fluid">
        <div class="span#Attributes.span#">
            <cfset row = Ceiling(qF.recordcount/Attributes.column)/>
            <cfset i=0/>
            <cfloop from="1" to="#row#" index="r">
            <div class="row-fluid" style="border-bottom:1px ##ddd solid; padding:10px 0px;">
                <cfset span_size = Ceiling(#Attributes.span#/Attributes.column)/>
                <cfloop from="1" to="#Attributes.column#" index="c">
                	<cfset i++/>
                    <div class="span#span_size#">
                    <!--- <cfset s_flname = EncodeForURL(qF.File[i])/> --->
                    <cfset s_flname = URLEncodedFormat(qF.File[i])/>
                    <cfset s_flname = replace(s_flname, '+', '%20','all')/>
					<cfset ext = listlast(qF.File[i],'.')/>
                    <cfset flname = replacenocase(lcase(qF.File[i]),'.#ext#','')/>
                    <cfif len(flname)>                    	
						<cfif Attributes.type eq "a">
                            <cfswitch expression="#ext#">
                                <cfcase value="pdf"><img src="assets/awaf/tags/xUploader_1000/img/#ext#.png" align="left"/></cfcase>
                                <cfcase value="xls,xlsx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/xls.png" align="left"/></cfcase>
                                <cfcase value="doc,docx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/doc.png" align="left"/></cfcase>
                                <cfcase value="txt"><img src="assets/awaf/tags/xUploader_1000/img/txt.png" align="left"/></cfcase>
                                <cfcase value="ppt,pptx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/txt.png" align="left"/></cfcase>
                                <cfdefaultcase><img src="assets/awaf/tags/xUploader_1000/img/na.png" align="left"/></cfdefaultcase>
                            </cfswitch>
                            <a target="_blank" href="#Attributes.source##Attributes.table#/#Attributes.pk#/#s_flname#">#flname#.#ext#</a><br/><span style="color:gray; font-size:11px">#ConvertByte(qF.Size[i])#</span>
                        <cfelse>
                            <img src="#replace(Attributes.source,'../','','all')##Attributes.table#/#Attributes.pk#/#qF.File[i]#"/><br />
                            <a target="_blank" href="#Attributes.source##Attributes.table#/#Attributes.pk#/#s_flname#">#flname#</a> <span style="color:gray; font-size:11px">#ConvertByte(qF.Size[i])#</span>
                        </cfif>
                    </cfif>
                    </div>
                </cfloop>
            </div>
            </cfloop>
        </div>
    </div>
    <cfelse>
    <div class="row-fluid">
        <div class="span#Attributes.span#">
            <cfset row = 1/>
            <cfset i=0/>
            <cfloop from="1" to="#row#" index="r">
            <div class="row-fluid" style="border-bottom:1px ##ddd solid; padding:10px 0px;">
                <cfset span_size = Ceiling(#Attributes.span#/Attributes.column)/>
                <cfloop from="1" to="1" index="c">
                	<cfset i++/>
                    <div class="span#span_size#" align="center"> 
                    	<img src="assets/awaf/tags/xUtil/img/asset-pic.jpg"/>					               	
                    </div>
                </cfloop>
            </div>
            </cfloop>
        </div>
    </div>
    </cfif>
 
<cfelse>
	
</cfif>
</div> 
</cfoutput>

<cffunction name="ConvertByte" access="public" returntype="string">
    <cfargument name="b" required="true" type="string">
    
    <cfset arguments.b = val(arguments.b)/>    
    
    <cfset temp = NumberFormat(arguments.b,'9,999.9') & "B">
    <cfset nte = replace(ListFirst(temp,'B'),',','','all')>
    <cfif nte gt 99.99 and nte lt 999999>
        <cfset temp = NumberFormat(arguments.b/1024,'9,999.9') & "KB">
    <Cfelseif nte gt 1000000>
        <cfset temp = NumberFormat(arguments.b/(1024^2),'9,999.99') & "MB">
    </cfif>
    <cfreturn temp>
</cffunction>