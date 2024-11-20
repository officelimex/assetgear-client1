<cfoutput>

    <cfparam default="0" name="url.id"/>

    <cfparam name="url.cid" default=""/>
    <cfparam name="url.r" default=""/>
    <cfset jrId = "__service_request_c_all_service_request#url.cid#" & url.id/>

    <cfimport taglib="../../../assets/awaf/tags/xForm_1001/" prefix="f" />

    <cfSet qSR = application.com.WorkOrder.GetServiceRequest(url.id)/>

    <cfquery name="qA">
        SELECT
          CONCAT(a.Description,' @ ',l.Name,' ',IFNULL(al.LocDescription,'')) Asset, CONCAT(a.AssetId,',',al.AssetLocationId) AssetId 
        FROM asset a
        LEFT JOIN asset_location al ON (al.AssetId = a.AssetId)
        INNER JOIN location l ON (l.LocationId = al.LocationId)
        WHERE a.AssetId = #val(qSR.AssetId)#
    </cfquery>
    <cfquery name="qWO">
        SELECT *  FROM work_order WHERE ServiceRequestId = #url.id#
    </cfquery>
    <cfquery name="qSRItems">
        SELECT *  FROM service_request_item WHERE ServiceRequestId = #url.id#
    </cfquery>
    <cfquery name="qComments">
        SELECT
            c.Comments ,
            CONCAT(cu.Surname,' ',cu.OtherNames) sender
        FROM
            core_comment c
        INNER JOIN core_user cu ON c.CommentByUserId = cu.UserId
        WHERE c.`Table` = "service_request" AND PK = #url.Id#
    </cfquery>

    <f:Form id="#jrId#frm" action="controllers/Settings.cfc?method=SaveComment">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <cfif qSR.ServiceType eq "JR">
                <td colspan="2"><f:label name="Service Request Type"  value="Job Request"/>&nbsp;</td>
            <cfelse>
                <td colspan="2"><f:label name="Service Request Type"  value="Material Request"/>&nbsp;</td>
            </cfif>
        </tr>
        <cfif qSR.ServiceType eq "JR">
            <tr>
                <td  colspan="2"><f:label name="Asset Description"  value="#qA.Asset#"/>&nbsp;</td>
            </tr>
            <tr colspan="2">
                <td colspan="2"><f:label name="Nature of work / Observation "  value="#qSR.Description#"/>&nbsp;</td>
            </tr>
            <tr>
                <td width="40%">
                    <f:label name="Created&nbsp;Date"  value="#DateFormat(qSR.Date,"dd-mmm-yyyy")#"/>
                    <cfswitch expression="qSR.Priority">
                        <cfcase value="h">
                            <cfset p="High"/>
                        </cfcase>
                        <cfcase value="m">
                            <cfset p="Medium"/>
                        </cfcase>
                        <cfdefaultcase>
                            <cfset p="Low"/>
                        </cfdefaultcase>
                    </cfswitch>
                    <f:label name="Priority"  value="#p#"/>
                </td>
                <td class="horz-div">
                    <table width="100%">
											<tr><td colspan="2"><f:label name="Requested By" value="#qSR.RequestBy#"/></td></tr>
											<tr>
												<td width="40%"><f:label name="W.O ##" value=""/></td>
												<td><a href="modules/maintenance/workorder/print_workorder.cfm?id=#qWO.WorkOrderId#" target="_blank">#qWO.WorkOrderId#</a></td>
											</tr>
											<tr><td colspan="2"><f:label name="Status" value="#qSR.Status#"/></td></tr>
                    </table>
                </td>
            </tr>
            
        <cfelse>
            <tr><td colspan="2"><f:label name="Reason For Request"  value="#qSR.ReasonForRequest#"/></td></tr>
            <tr>
                <td width="40%">
                    <f:label name="Date Needed"  value="#DateFormat(qSR.Date,"dd-mmm-yyyy")#"/>
                    <cfswitch expression="qSR.Priority">
                        <cfcase value="h">
                            <cfset p="High"/>
                        </cfcase>
                        <cfcase value="m">
                            <cfset p="Medium"/>
                        </cfcase>
                        <cfdefaultcase>
                            <cfset p="Low"/>
                        </cfdefaultcase>
                    </cfswitch>
                    <f:label name="Priority"  value="#p#"/>
                    
                    <cfif qSR.Category eq "m"> <f:label name="Category"  value="Material Related"/></cfif>
                    <cfif qSR.Category eq "s"> <f:label name="Category"  value="Service Related"/></cfif>
                       
                </td>
                <td class="horz-div">
                    <table width="100%">
                        <tr><td><f:label name="Requested By" value="#qSR.RequestBy#"/></td></tr>
                        <tr><td><f:label name="Status"  value="#qSR.Status#"/></td></tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <table width="85%" class="table table-bordered table-striped table-hover table-condensed">
                        <tr>
                            <td>##</td>
                            <td width="70%">Requested By</td>
                            <td width="15%">Unit Price</td>
                            <td width="15%">Qty</td>
                        </tr>
                        <cfset i = 0 />
                        <cfloop query="qSRItems">
                            <tr>
                                <td>#i++#</td>
                                <td>#Description#</td>
                                <td>#NumberFormat(UnitPrice,"9,999.99")#</td>
                                <td>#NumberFormat(Quantity,"9,999.99")#</td>
                            </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
        </cfif>
      <tr>
        <td colspan="2" class="vert-div">&nbsp; <br></td>
      </tr>
        <tr>
            <td width="60%"  valign="top">
                <br>
                
                <div class="span11">
									<cfloop query="qComments">
										<blockquote>
											<p style="font-size:14px">#Comments#</p>
											<small>#sender#</small>
										</blockquote>
									</cfloop>
                </div>
                
            </td>
            <td valign="top" style="font-size: 14px; padding-left: 10px !important ">
							
							Place a comment
							<f:TextArea showlabel="No" name="Comments" label="Comment" required value="" class="span12" rows="4"/>
							<f:TextBox type="hidden" showlabel="No"  name="Table" label="" value="service_request"/>
							<f:TextBox type="hidden"  name="Pk" label="" showlable="No" value="#url.id#" hint=""/>
								
            </td>
        </tr>    
      
        <cfif url.id neq 0>
					<div style="right: 100px;position: absolute;bottom: 4px;">
						<f:ButtonGroup>
							<f:Button id="yy" beforeSave="submitval()" value="Save Comments" class="btn-primary" IsSave/>
						</f:ButtonGroup>
					</div>
        </cfif>
    </table>
    </f:Form>
        
    <script>
      function submitval(){
        var x = document.getElementsByName("Comments")[0].value;
        if (x == "") {
        alert("Add a comment or click the close button to close the form.")
        return True
        }
        
        if (!confirm('Ensure you preview your comment before saving.')) return True
      }
    </script>
</cfoutput>
    
