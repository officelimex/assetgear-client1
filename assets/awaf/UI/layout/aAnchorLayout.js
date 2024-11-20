/*!
 * AWAF JS Library 0.0.0.1
 * Copyright(c) 2011 Adexfe Systems Ltd.
 * http://awaf.adexfe.com/license
 */

/**
 * @class aAnchorLayout
 * A class that create ContainerLayout
 */
var aAnchorLayout = new Class({
    
    Extends: aContainerLayout,
	
    options: { 
    },

	Id : '', 
    
    /** 
	 * Class constructor, create the tab container.
     * @param {String}	the Id of the entire tab.
     * @param {Object}	(optional) Optoions as defined by the user 
	 **/	
    initialize : function(id, options) {
        this.parent(id, options);
		
		
    }  
 
});