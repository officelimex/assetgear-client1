/*!
 * AWAF JS Library 0.0.0.1
 * Copyright(c) 2011 Adexfe Systems Ltd.
 * http://awaf.adexfe.com/license
 */

/**
 * @class ContainerLayout
 * A class that create ContainerLayout
 */
var aContainerLayout = new Class({
    
    Implements: [Events, Options], 
	
    options: { 
    },

	Id : '', 
    
    /** 
	 * Class constructor, create the tab container.
     * @param {String}	the Id of the entire tab.
     * @param {Object}	(optional) Optoions as defined by the user 
	 **/	
    initialize : function(id, options) {
        this.Id = id;
		this.setOptions(options); 
    }  
 
});