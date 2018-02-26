/**
 * COMMUNITY UI PROFESSIONAL
 * dependency : kendoui professional (commercial edition)
 */
 
 (function (window, $, undefined) {		
 
		var community = window.community = window.community || { ui : {}, model : {} , data : {}},
		extend = $.extend,
		handleAjaxError = community.ui.handleAjaxError ;
		 		
		function treelist_datasource( options ){
			options = options || {} ;
			var settings = extend(true, {}, { error:handleAjaxError } , options ); 
			return new kendo.data.TreeListDataSource(settings);
		}
		
		function treelist( renderTo, options){		
			if(!renderTo.data("kendoTreeList")){			
				 renderTo.kendoTreeList(options);
			}		
			return renderTo.data("kendoTreeList");
		}		
		
		extend( community.ui , {	
			treelist : treelist,
			treelist_datasource : treelist_datasource		
		});		
    	
		console.log("community.ui.professional components initialized.");
		
    }(window, jQuery));		