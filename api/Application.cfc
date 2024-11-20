component output="true"  {

	this.name	 			= 'api'
	this.datasource = 'energia_ams'

	public boolean function onApplicationStart() {

		application.site.url = "http://localhost/assetgear-energia/"

		return true;
	}

}