<cfoutput>
    <cfdocument pagetype="a4" format="pdf" margintop="0.25" marginbottom="0" marginleft="0.4" marginright="0.4">
    <html>
    <head>
    <cfset bg = "##f0f8f1"/>
    <cfset brd_c = "##d6ebd9"/>
    <cfset brd_c2 = "##53a95a"/>
    <style type="text/css">
        html,body{padding:0; margin:0;font: 12px Tahoma;}
        .head_section td{font-size: 11px;padding:5px;}
        .head_section td.left{background-color:#bg#;border-left:#brd_c# 1px solid;}
        .head_section td.left,.head_section td.right{border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
        .head_section td.bottom{border-bottom:#brd_c# 1px solid;}
        .sub_head{font-size:11px; background-color:#bg#;border-top:#brd_c# 1px solid; padding:5px;}
        .content{font-size:11px;padding:5px;}
        .tbl{
        font-size: 11px;
    }
        .tbl th{font-weight: normal;background-color:#bg#;border-top:#brd_c2# 2px solid;border-right:#brd_c# 1px solid; text-align:left; padding:4px;}
        .tbl th.left{border-left:#brd_c# 1px solid;}
        .tbl td{
        padding: 3px 5px;
    border-top:#brd_c# 1px solid;border-right:#brd_c# 1px solid;}
        .tbl td.left{border-left:#brd_c# 1px solid;}
        .tbl tr.bottom td{border-bottom:#brd_c# 1px solid;}
        .tbl td.no-right{border-right:none;}
        .tbl td.cbg{background-color:#bg#;}
        .tbl td.no-bottom{border-bottom:none !important;}
        .a-right{text-align:right !important;}
        .gray{color:gray;}
        th{text-align:left !important;}
        small{font-size:7px;}
    </style>
    </head>
    <body>
    <!--- get asset --->
    <cfquery name="qA">
        SELECT 
            a.Description Asset, a.Class, a.Model, a.ModelNumber, a.Ownership,
            ac.Name Cat1,
            ac2.Name Cat2,
            ac3.Name Cat3,
            pa.Description ParentAsset
        FROM asset a
        INNER JOIN asset_category ac ON ac.AssetCategoryId = a.AssetCategoryId
        LEFT JOIN asset_category ac2 ON ac2.AssetCategoryId = ac.ParentAssetCategoryId
        LEFT JOIN asset_category ac3 ON ac3.AssetCategoryId = ac2.ParentAssetCategoryId
        LEFT JOIN asset pa ON pa.AssetId = a.ParentAssetId
        WHERE a.AssetId = #val(url.id)#
    </cfquery>
    <table width="100%">
    <cfdocumentitem type = "header">
    <cfset request.letterhead.title="ASSET JOB HSITORY REPORT"/>
    <cfset request.letterhead.Id="Asset ## #url.id#"/>
    <cfswitch expression="#qA.Class#">
        <cfcase value="Critical"><cfset sts = "<span style='color:green;'>CRITICAL</span>"/></cfcase>
        <cfcase value="Major"><cfset sts = "<span style='color:red;'>MAJOR</span>"/></cfcase>
        <cfdefaultcase><cfset sts = "<span style='color:gray;'>#qA.Class#</span>"/></cfdefaultcase>
    </cfswitch>
    <cfset request.letterhead.date = "Report Date : #dateformat(now(),'dd/mm/yyyy')#. #sts#"/>
    <cfinclude template="../../../include/letter_head.cfm"/>
    </cfdocumentitem>
    <tr>
    
    <td>
    <cfquery name="qTotal">
        SELECT 
            SUM(TotalCost) SumCost,
            SUM((SELECT sum(Hours) from labour where labour.WorkOrderId = work_order.WorkOrderId)) SumHours,
            Min(DateOpened) MinDate, Max(DateOpened) MaxDate
        FROM work_order
        WHERE AssetId = #url.id# AND WorkClassId NOT IN (12)
    </cfquery>
    <table width="100%" border="0">
      <tr>
        <td valign="top" width="54%" align="center">
            <table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
                <tr>
                    <td width="13%" valign="top" class="left">Asset</td>
                    <td width="87%" valign="top" class="right">#qA.Asset#</td>
                </tr>
                <cfif qA.ParentAsset neq "">
                    <tr>
                        <td valign="top" class="left">Parent Asset</td>
                        <td valign="top" class="right">#qA.ParentAsset#</td>
                    </tr>
                </cfif> 
                <tr>
                    <td valign="top" class="left bottom">Category</td>
                    <td valign="top" class="right bottom"><cfif qA.Cat3 neq ""> #qA.Cat3# ></cfif> <cfif qA.Cat2 neq ""> #qA.Cat2# ></cfif>&nbsp;#qA.Cat1#</td>
                </tr>
                <tr>
                    <td width="22%" valign="top" class="left bottom">Ownership</td>
                    <td width="78%" valign="top" class="right bottom">#qA.Ownership#</span></td>
                </tr>
            </table>
        </td>
        <td valign="top" width="46%" align="center">
            <table width="90%" border="0" cellpadding="0" cellspacing="0" class="head_section">
                <cfif qA.Model neq "">
                    <tr>
                        <td width="22%" valign="top" class="left">Model</td>
                        <td width="78%" valign="top" class="right">#qA.Model#</td>
                    </tr>
                </cfif>
                <cfif qA.ModelNumber neq "">
                    <tr>
                        <td width="22%" valign="top" class="left">Model ##</td>
                        <td width="78%" valign="top" class="right">#qA.ModelNumber#</span></td>
                    </tr>
                </cfif>
                
                <tr>
                    <td width="22%" valign="top" class="left bottom">Man-hours</td>
                    <td width="78%" valign="top" class="right bottom">#numberformat(qTotal.SumHours,'9,999.9')# hrs</td>
                </tr>
                <cfset bDt = CreateObject('component','assetgear.com.awaf.util.bDate').init()>
                <tr>
                    <td width="22%" valign="top" class="left bottom" nowrap>Period in Use</td>
                    <td width="78%" valign="top" class="right bottom">#bDt.timeAgo(qTotal.MinDate, qTotal.MaxDate,"")#</td>
                </tr>
            </table>
        </td>
      </tr>
    </table>
    <BR/><BR/>
    </td>
    </tr>
    <cfquery name="qAL">
        SELECT 
            al.Quantity, al.Status, al.AssetLocationId,
            l1.Name Loc1,
            l2.Name Loc2,
            l3.Name Loc3,
            l4.Name Loc4
        FROM asset_location al 
        INNER JOIN location l1 ON l1.LocationId = al.LocationId
        LEFT JOIN location l2 ON l2.LocationId = l1.ParentLocationId
        LEFT JOIN location l3 ON l3.LocationId = l2.ParentLocationId
        LEFT JOIN location l4 ON l4.LocationId = l3.ParentLocationId
        WHERE al.AssetId = #val(url.id)#
    </cfquery>
    <tr>
        <td>
            <cfloop query="qAL">
                <cfquery name="qW">
                    SELECT 
                        wo.WorkOrderId, wo.Description, wo.DateOpened, wo.TotalCost, wo.ManHours, wo.Status,
                        jc.Code JobType, jc.Class JobTypeName,
                        u1.Surname c_Surname, u1.OtherNames c_OtherNames
                    FROM work_order wo
                    INNER JOIN job_class jc ON jc.JobClassId = wo.WorkClassId
                    LEFT JOIN core_user u1 ON u1.UserId = wo.CreatedByUserId
                    WHERE 
                        wo.AssetId = #url.id# AND 
                        wo.AssetLocationIds IN ('#qAL.AssetLocationId#') AND 
                        wo.WorkClassId NOT IN (12) AND
                        wo.Status = "Close"
                    ORDER BY wo.DateOpened, wo.Description
                </cfquery>        
                <cfif qAL.currentrow neq 1>
                    <cfdocumentitem type="pagebreak"/>
                </cfif>
                <cfif qW.recordcount>
                    <small>Below are job associated with this asset in the #qAL.Loc1#</small>
                    <div class="sub_head">
                        #qA.Asset# in  
                        <cfif qAL.Loc4 neq "">#qAL.Loc4# > </cfif>
                        <cfif qAL.Loc3 neq "">#qAL.Loc3# > </cfif> 
                        <cfif qAL.Loc2 neq "">#qAL.Loc2# at the </cfif> #qAL.Loc1# <small> &mdash; #qAL.Status# </small> 
                    </div>
                    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
                        <tr>
                            <th class="left">WO ##</th>
                            <th>Date</th>
                            <th>Job Description</th>
                            <th>Location</th>
                            <th>Created by</th>
                            <th>Status</th>
                            <!---<th class="a-right">Hours</th>--->
                            <th class="a-right">Cost</th>
                        </tr>
                        <cfset tsum = tmh = 0/>
                        <cfloop query="qW">
                            <tr <cfif qW.Currentrow eq qW.Recordcount> class="bottom" </cfif>>
                                <td class="left" nowrap valign="top">#qW.WorkOrderId# <small><sup>(#qW.JobType#)</sup></small></td>
                                <td nowrap valign="top">#dateformat(qW.DateOpened,'dd-mmm-yy')#</td>
                                <td valign="top">#qW.Description#</td>
                                <td valign="top">#qAL.Loc1#</td>
                                <td valign="top">
                                    <cfif qW.c_Surname eq "" OR qW.c_OtherNames eq "">
                                        System Generated
                                    <cfelse>
                                        #qW.c_Surname# #qW.c_OtherNames#
                                    </cfif>
                                </td>
                                <td valign="top">#qW.Status#</td>
                                <!---<td valign="top" class="a-right">#numberformat(val(qW.ManHours),'9.9')#</td>--->
                                <cfset tcost = 0 />
                                <cfquery name="getlabourcost">
                                    SELECT SUM(Cost) AS ContractCost FROM `contract` WHERE WorkOrderId = #qW.WorkOrderId#
                                </cfquery>
                                <cfset tcost += val(getlabourcost.ContractCost) />
                                <cfquery name="getitemcost">
                                    SELECT
                                    sum(if(isnull(wo.ItemId) , wo.UnitPrice * wo.Quantity, if(wi.Currency = "USD",345 * wi.UnitPrice * wo.Quantity ,wi.UnitPrice * wo.Quantity ))) AS TCOST
                                    FROM
                                    work_order_item AS wo
                                    LEFT JOIN whs_item AS wi ON wo.ItemId = wi.ItemId
                                    WHERE wo.WorkOrderId = #qW.WorkOrderId#
                                </cfquery>
                                <cfquery name="qLab">
                                    SELECT sum(Hours) AS ManHours
                                    FROM labour
                                    WHERE WorkOrderId = #qW.WorkOrderId#
                                </cfquery>
                                <cfset tcost += val(getitemcost.TCOST) />
                                <td valign="top" class="a-right">#numberformat(tcost,'9,999.99')#</td>
                            </tr>
                            <cfset tsum = tsum + val(tCost)/>
                            <cfset tmh = tmh + val(qLab.ManHours)/>
                        </cfloop>
                        <tr>
                            <td colspan="8" class="no-bottom"></td>
                        <tr>
                        <tr class="bottom">
                            <td colspan="3" rowspan="2" class=" left bottom" align="center">
                                <!--- list of work class --->
                                <cfquery name="qW1" dbtype="query">
                                    SELECT
                                        COUNT(JobType) PMCount, JobType, JobTypeName
                                    FROM qW 
                                    GROUP BY JobType, JobTypeName
                                </cfquery>
                                <cfloop query="qW1">
                                    #qW1.PMCount# #qW1.JobTypeName#(#qW1.JobType#)<cfif qW1.recordcount neq qW1.currentrow>, </cfif> 
                                </cfloop><br/> 
                                <b>#qW.recordcount#</b> total maintenance task
                            </td>
                            <td align="right" class="no-bottom"></td>
                            <td align="right" colspan="2" class="cbg left" valign="top">Total Man hours</td>
                            <td align="right" colspan="2" class="cbg" valign="top">#NumberFormat(tmh, '9,999.9')# hrs</td>
                        </tr>
                        <tr class="bottom">
                            <td align="right" class="no-bottom"></td>                        
                            <td align="right" colspan="2" class="cbg left" valign="top">Total Cost</td>
                            <td align="right" colspan="2" class="cbg" valign="top">N #NumberFormat(tsum, '9,999.99')#</td>
                        </tr>
                    </table>
                </cfif>
            </cfloop>
        </td>
    </tr>
    
    
    <tr>
      <td>
      <!---div class="sub_head">MATERIALS NEEDED</div>
      <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tbl">
        <tr>
          <th class="left" width="1px">S/N</th>
          <th>Spare parts</th>
          <th>Purpose</th>
          <th colspan="2">Quantity</th>
          <th class="a-right">Unit Price</th>
          <th class="a-right">Subtotal</th>
        </tr>
        <cfset nstock =false/>
        <cfloop query="qWOI">
        <tr <cfif qWOI.Currentrow eq qWOI.Recordcount> class="bottom" </cfif>>
          <td valign="top" class="left">#qWOI.Currentrow#</td>
          <td valign="top"><cfif qWOI.Item eq "">* #qWOI.Description#<cfelse>[#qWOI.ItemId#] #qWOI.Item# #qWOI.VPN#</cfif></td>
          <td valign="top">#qWOI.Purpose#</td>
          <td align="right" valign="top" class="no-right">#qWOI.Quantity#</td>
          <td valign="top">#qWOI.UM#&nbsp;</td>
          <td align="right" valign="top">#Numberformat(qWOI.UnitPrice,'9,999.99')#</td>
          <td align="right" class="cbg" valign="top">
          <cfset qu = qWOI.Quantity*qWOI.UnitPrice/>
          <cfif qWOI.Item eq "">
              <cfset nstock =true/>
              <cfset tsum2 = tsum2 + qu/>
          </cfif>
    
            <cfset tsum = tsum + qu/>
            #NumberFormat(qu, '9,999.99')#</td>
        </tr>
        </cfloop>
        <tr class="bottom">
          <td colspan="6" class="no-bottom" style="font-size:8px;"><cfif nstock>Item(s) marked with * are non stocked items : total value #Numberformat(tsum2,'9,999.99')#</cfif></td>
          <td align="right" class="cbg" valign="top">#NumberFormat(tsum, '9,999.99')#</td>
        </tr>
      </table--->
    
      </td>
    </tr> 
     
     
    <tr>
      <td>&nbsp;</td>
    </tr>
    <cfdocumentitem type="footer">
     
    </cfdocumentitem>
    </table>
    </body>
    </html>
    </cfdocument>
     
    
    </cfoutput>
    