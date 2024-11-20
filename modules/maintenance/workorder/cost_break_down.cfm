<cfoutput>
	<cfquery name="qWO">
        SELECT
        wo.WorkOrderId,
        wo.Description,
        Sum(if(w.Currency = "USD",wi.Quantity*w.UnitPrice,0)) AS USD,
        Sum(if(w.Currency = "NGN",wi.Quantity*w.UnitPrice,0)) AS NGN1,
        Sum(if(wi.ItemId IS NULL,wi.Quantity*wi.UnitPrice,0)) AS NGN2,
        Sum(if(c.Currency = "USD",c.Cost,0)) AS ContractINUSD,
        Sum(if(c.Currency = "NGN",c.Cost,0)) AS ContractINNGN,
        DATE_FORMAT(wo.DateOpened,'%b - %y') AS Months,
        jc.Class,
        CONCAT(NULLIF(core_user.Surname,''),' ',NULLIF(core_user.OtherNames,'')) AS CreatedBy
        FROM
        work_order_item AS wi
        LEFT JOIN whs_item AS w ON wi.ItemId = w.ItemId
        LEFT JOIN work_order AS wo ON wi.WorkOrderId = wo.WorkOrderId
        INNER JOIN job_class AS jc ON wo.WorkClassId = jc.JobClassId
        LEFT JOIN core_user ON wo.CreatedByUserId = core_user.UserId
        LEFT JOIN contract AS c ON c.WorkOrderId = wi.WorkOrderId
        WHERE wo.UnitId IN (1,2,3,4,5) AND DATE_FORMAT(wo.DateOpened,'%b - %y') = "#url.m#"
        AND wo.Status = 'Close'
        GROUP BY wo.WorkOrderId        
    </cfquery>
    
<!DOCTYPE html>
<html >
  <head>
    	<meta charset="UTF-8">
    	<title>All </title>
        <link rel="stylesheet" type="text/css" href="../../../assets/bootstrap/css/normalize.css">
        <link rel="stylesheet" type="text/css" href="../../../assets/bootstrap/css/bootstrap.min.css">

        <style type="text/css">
			h2 {
			  text-align: center;
			}
			
			table caption {
				padding: .5em 0;
			}
			
			@media screen and (max-width: 767px) {
			  table caption {
				border-bottom: 1px solid ##ddd;
			  }
			}
			
			.p {
			  text-align: center;
			  padding-top: 140px;
			  font-size: 14px;
			}		
		</style>
    
  </head>
<body>
    <h2>Break Down Details For #url.m# At &##8358;#url.r# per Dollar</h2>

    <div class="container">
      <div class="row">
        <div class="col-xs-12">
          <div class="table-responsive">
            <table summary="" class="table table-bordered table-hover" style="font-size:11px">
              <caption class="text-center"></caption>
              <thead>
                <tr>
                  <th>WO ##</th>
                  <th>Work Description</th>
                  <th>Created By</th>
                  <th colspan="2">
                  	<table width="100%">
                    	<tr>
                        	<td colspan="2" align="center" style="border-bottom:solid 1px ##ddd">Material Cost</td>
                        </tr>
                    	<tr>
                        	<td>USD</td>
                        	<td align="right">NGN</td>
                        </tr>
                    </table>
                  </th>
                  
                  <th colspan="2">
                  	<table width="100%">
                    	<tr>
                        	<td colspan="2" align="center" style="border-bottom:solid 1px ##ddd">Contractor Cost</td>
                        </tr>
                    	<tr>
                        	<td>USD</td>
                        	<td align="right">NGN</td>
                        </tr>
                    </table>
                  </th>
                  <th>Work Class</th>
                </tr>
              </thead>
              <tbody>
                <cfset tngn = 0/>
                <cfset tusd = 0/>
                <cfset tcusd = 0/>
                <cfset tcngn = 0/>
                <cfloop query="qWO">
                <tr>
                  <td>#WorkOrderId#</td>
                  <td>#Description#</td>
                  <td>
                  	<cfif CreatedBy eq "">System Generated<cfelse>#CreatedBy#</cfif>
                  </td>
                  <td align="right" nowrap>#numberformat(USD,"9,999.99")#</td>
                  <td align="right" nowrap>
                  	<cfset ngn = NGN1 + NGN2/>
                    <cfset tngn = tngn + ngn/>
                    <cfset tusd = tusd + usd/>
                    <cfset tcusd = tcusd + ContractINUSD/>
                    <cfset tcngn = tcngn + ContractINNGN/>
                    #numberformat(ngn,"9,999.99")#
                  </td>
                  <td align="right">#numberformat(ContractINUSD,"9,999.99")#</td>
                  <td align="right">#numberformat(ContractINNGN,"9,999.99")#</td>
                  <td>#Class#</td>
                </tr>
                </cfloop>
              </tbody>
              <tfoot>
                <tr>
                  <td colspan="3" class="text-center">SUB-TOTAL</td>
                  <td class="text-center">#numberformat(tusd,"$9,999.99")#</td>
                  <td class="text-center">&##8358;#numberformat(tngn,"9,999.99")#</td>
                  <td class="text-center">#numberformat(tcusd,"$9,999.99")#</td>
                  <td class="text-center">&##8358;#numberformat(tcngn,"9,999.99")#</td>
                  <td class="text-center"></td>
                </tr>
                <tr>
                  <td colspan="3" class="text-center">SUM TOTAL</td>
                  <td class="text-center">#numberformat(tusd + tcusd,"$9,999.99")#</td>
                  <td class="text-center">&##8358;#numberformat(tngn + tcngn,"9,999.99")#</td>
                  <td colspan="2" class="text-center">NGN TO USD</td>
                  <td class="text-center">#numberformat(((tngn + tcngn)/url.r )+tusd + tcusd,"$9,999.99")#</td>
                </tr>
              </tfoot>
            </table>
          </div><!--end of .table-responsive-->
        </div>
      </div>
    </div>
    
    <p class="p">Demo by George Martsoukos. <a href="http://www.sitepoint.com/responsive-data-tables-comprehensive-list-solutions" target="_blank">See article</a>.</p>
    
        <script src="js/index.js"></script>

    
    
    
  </body>
  
</html>
    
</cfoutput>
