<cfoutput>
<style>
    .cancel_btn {
        border-radius: 10px;
        padding-left: 2px;
        padding-right: 2px;
        padding-top: 0;
        padding-bottom: 0;
    }
    .cancel_btn i {margin-top: -1px;}
</style>
<cfif ThisTag.ExecutionMode EQ "Start">
    <cfparam name="Attributes.TagName" type="string" default="UploadFile"/>
    <cfparam name="Attributes.id" type="string"/>  
    <cfparam name="Attributes.accept" type="string" default=""/> <!--- images/* --->
    <cfparam name="Attributes.tempFolder" type="string" default="_#left(CreateUUID(),8)#"/>
    <cfparam name="Attributes.height" type="string" default="280px"/>
    <cfparam name="Attributes.createdby" type="numeric" default="#request.userinfo.userid#"/>
    
    <!--- display ---->
    <cfparam name="Attributes.table" type="string" default=""/>
    <cfparam name="Attributes.pk" type="numeric" default="0"/>

    <input type="hidden" name="#Attributes.id#" value="#Attributes.tempFolder#"/>
    <input type="hidden" name="#Attributes.id#Source" value="#ExpandPath('../../../assets/awaf/tags/xUploader_1000/temp/')#"/>
    

<div style="max-height:#Attributes.height#;overflow-y:auto;overflow-x:hidden;" id="#Attributes.tempFolder#">

<cfset dphoto = "photo,picture,image,photos,pictures,images"/>


    <cfswitch expression="#Attributes.accept#">
        <cfcase value="#dphoto#" delimiters=",">
			<cfset _type = "p"/> 
            <cfparam name="Attributes.destination" type="string" default="../../../doc/photo/"/>
        	<cfparam name="Attributes.column" type="numeric" default="6"/>
        </cfcase>
        <cfdefaultcase>
			<cfset _type = "a"/> 
            <cfparam name="Attributes.destination" type="string" default="../../../doc/attachment/"/>
            <cfparam name="Attributes.column" type="numeric" default="4"/>
        </cfdefaultcase>
    </cfswitch>
    
    <input type="hidden" name="#Attributes.id#Destination" value="#ExpandPath('#Attributes.destination#')#"/>
<Cfif Attributes.pk>    
    <cfquery name="qF">
        SELECT * FROM `file`
        WHERE `Table` = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.table#"/>
            AND `PK` = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.pk#"/>
                AND `Type` = <cfqueryparam cfsqltype="cf_sql_char" maxlength="1" value="#_type#"/>
    </cfquery>
    <!--- display for already uploaded files--->
    <cfif qF.recordcount>
    <div class="row-fluid __upload_xtag_tool">
        <div class="span12">
            <cfset row = Ceiling(qF.recordcount/Attributes.column)/>
            <cfset i=0/>
            <cfloop from="1" to="#row#" index="r">
            <div class="row-fluid" style="border-bottom:1px ##ddd solid; padding:10px 0px;">
                <cfset span_size = Ceiling(12/Attributes.column)/>
                <cfloop from="1" to="#Attributes.column#" index="c">
                	<cfset i++/>
                    <div class="span#span_size# thumb_#qF.FileId[i]#">
                        <cfset ext = listlast(qF.File[i],'.')/>
                        <cfset flname = replacenocase(lcase(qF.File[i]),'.#ext#','')/>
                        <cfif _type eq "a">
                            <cfif flname neq "">
                                <a href="doc/attachment/#Attributes.table#/#Attributes.pk#/#qF.File[i]#" target="_blank">
                                    <cfswitch expression="#ext#">
                                        <cfcase value="pdf"><img src="assets/awaf/tags/xUploader_1000/img/#ext#.png" align="left"/></cfcase>
                                        <cfcase value="xls,xlsx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/xls.png" align="left"/></cfcase>
                                        <cfcase value="doc,docx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/doc.png" align="left"/></cfcase>
                                        <cfcase value="txt"><img src="assets/awaf/tags/xUploader_1000/img/txt.png" align="left"/></cfcase>
                                        <cfcase value="ppt,pptx" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/txt.png" align="left"/></cfcase>
                                        <cfcase value="htm,html" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/htm.png" align="left"/></cfcase>
                                        <cfcase value="zip,7z,rar" delimiters=","><img src="assets/awaf/tags/xUploader_1000/img/zip.png" align="left"/></cfcase>
                                        <cfdefaultcase><img src="assets/awaf/tags/xUploader_1000/img/na.png" align="left"/></cfdefaultcase>
                                    </cfswitch>
                                </a>
                                <a href="doc/attachment/#Attributes.table#/#Attributes.pk#/#qF.File[i]#" target="_blank">#flname#</a><br/><span style="color:gray; font-size:11px">#ConvertByte(qF.Size[i])#</span> 
                                <cfif qF.CreatedByUserId[i] eq Attributes.createdby>
                                    <a rel="#qF.FileId[i]#" class="btn btn-small btn-danger cancel_btn" title="Delete File"><i class="icon-white icon-remove"></i></a>
                                </cfif>
                            </cfif>			
                        <cfelse>
                            <cfif flname neq "">
                                <img src="#replace(Attributes.destination,'../','','all')##Attributes.table#/#Attributes.pk#/#qF.File[i]#"/><br />
                                #flname# <span style="color:gray; font-size:11px">#ConvertByte(qF.Size[i])#</span> 
                                <cfif qF.CreatedByUserId[i] eq Attributes.createdby>                              
                                    <a rel="#qF.FileId[i]#" class="btn btn-small btn-danger cancel_btn" title="Delete File"><i class="icon-white icon-remove"></i></a>
                                </cfif>
                            </cfif>
                        </cfif>
                    </div>
                </cfloop>
            </div>
            </cfloop>
        </div>
    </div><br />
    </cfif>
</Cfif>

<script type="text/javascript">
window.addEvent('domready', function()	{		
	var af = new aFileUploader('#Attributes.tempFolder#',{
        'height': '#Attributes.height#',
        'tempfolder':'#Attributes.tempfolder#',
		<cfswitch expression="#Attributes.accept#">
			<cfcase value="#dphoto#" delimiters=",">'accept':'image/*'</cfcase>
			<cfdefaultcase>'accept':'*/*'</cfdefaultcase>
		</cfswitch>
			
    });
    /* add 1 upload slot */
	af.addUploadSection();
    
    // delete 

    $$('.__upload_xtag_tool a.cancel_btn').addEvent('click', function(e) {
        //alert('a');
        //console.log(e.target.parentElement);
        if (e.target.match('a')) {
            var _field_id = e.target.getAttribute('rel');
        }
        else    {
            var _field_id = e.target.parentElement.getAttribute('rel');
        }    
        if (confirm('Are you sure you want to delete this file?')) {
            new Request({
                url : "assets/awaf/tags/xUploader_1000/delete_server_file.cfm?id=" + _field_id,
                method : 'get',
                //onRequest: function(){)},
                onComplete : function (rt) {
                    $$('.thumb_'+_field_id).destroy();
                }
            }).send();
        }

    });
});
</script>

 
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