<cfoutput>
<style>
	tr.tt td{border-bottom: 1px solid ##fff !important;}
	tr.slm > td{padding:0px !important;border-top: 1px solid ##fff !important;}
	td.gddl{padding:0px;text-align:right;vertical-align:top;width:48px;background:url(assets/awaf/UI/img/grid_ddl.gif) no-repeat left top !important;}
</style>
<cfset astId = '__asset_c'/>
<cfimport taglib="../../assets/awaf/tags/xNav_1000/" prefix="n" />

<cfinclude template="asset/all_asset.cfm"/>

<div class="container-fluid">
    <div class="row-fluid">
        <div class="span2" style="position:fixed;">
            <n:Nav renderTo="#astId#">
				<n:NavItem type="header" title="Asset"/>
					<cfif (request.userinfo.role == "HT") || (request.userinfo.role == "MS") || (request.userinfo.role == "WH") || (request.userinfo.email == "james_oladele@outlook.com")>
						<n:NavItem title="<strong>New Asset</strong>" url="modules/maintenance/asset/save_asset.cfm" id="new_asset"/>
					</cfif>
				<n:NavItem title="All Asset" isactive url="modules/maintenance/asset/all_asset.cfm" id="all_asset"/>
				<n:NavItem title="Offline Asset" url="modules/maintenance/asset/all_asset.cfm?status=off" id="all_assetoff"/>
				<n:NavItem title="Decommitioned Asset" url="modules/maintenance/asset/all_asset.cfm?status=decom" id="all_assetdecom"/>
				<n:NavItem type="header" title="Asset By Classification"/>
				
				<cfloop list="Minor,Major,Critical" index="c">
					<n:NavItem title="&nbsp;&nbsp;&nbsp;&nbsp;#c# Assets" url="modules/maintenance/asset/all_asset.cfm?cl=#c#" id="all_asset#c#"/>
        </cfloop>
				<cfif (request.userinfo.role eq "HT") or (request.userinfo.role eq "MS") or (request.userinfo.role eq "FS")>
					<n:NavItem title="Equipment Availibility" url="modules/maintenance/asset/view_downtime.cfm" id="downtime"/>  
					<n:NavItem title="Meter Readings" url="modules/maintenance/asset/view_meter_reading.cfm" id="meter_reading"/>
        </cfif>
				
				<n:NavItem type="divider"/>
				
				<n:NavItem type="header" title="Failure Report (F.R.)"/>
				<n:NavItem title="New F.R." url="modules/maintenance/asset/new_failure_report.cfm" id="new_fr"/>
                <n:NavItem title="Open F.R." url="modules/maintenance/asset/view_failure_report.cfm?s=1" id="failure_report1"/>                
                <n:NavItem title="Closed F.R." url="modules/maintenance/asset/view_failure_report.cfm?s=0" id="failure_report0"/>
				<n:NavItem title="Awaiting Your Approval" url="modules/maintenance/asset/appro.cfm" id="awaiting"/>
				<n:NavItem type="divider"/>
				
                <n:NavItem title="Offline Assets" url="modules/maintenance/asset/all_asset.cfm?status=Offline" id="all_assetOffline"/>
                <n:NavItem type="divider"/>                
                <n:NavItem title="Asset Category" url="modules/maintenance/asset/asset_category.cfm" id="asset_category"/>
                <n:NavItem type="header" title="Reports"/>
            </n:Nav>
        </div>

        <div class="span10" style="float:right;">
            <div id="#astId#_grid">
            	<div class="sub_page all_asset" id="#astId#_all_asset"></div>
            </div>
        </div>
    </div>
</div>
</cfoutput>