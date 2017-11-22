(function (window, $, undefined) {
	
	var community = window.community = window.community || { model : {} , data : {}},
	extend = $.extend,
	Model = kendo.data.Model;
	
	community.model.User = Model.define({ 
		id : "userId",
		fields: { 			
			userId: { type: "number", defaultValue: 0 },			
			username: { type: "string", defaultValue: "" },			
			name: { type: "string", defaultValue: "" },			
			nameVisible: { type: "boolean", defaultValue: false },	
			firstName: { type: "string", defaultValue: "" },
			lastName: { type: "string", defaultValue: "" },
			email: { type: "string", defaultValue: "" },			
			emailVisible: { type: "boolean", defaultValue: false },					
			anonymous: { type: "boolean", defaultValue: true },			
			enabled: { type: "boolean", defaultValue: false },
			creationDate:{ type: "date" },			
			modifiedDate:{ type: "date"},
			properties: { type: "object", defaultValue : {} },
			roles: { type: "object", defaultValue: [] }
		},
		hasRole : function ( role ) {
			if( typeof( this.roles ) != "undefined" && $.inArray( role, this.roles ) >= 0 )
				return true
			else 
				return false;    	
	    },
	    copy : function ( target ){
		    	target.userId = this.get("userId");
		    	target.set("username", this.get("username"));
		    	target.set("name", this.get("name"));
		    	target.set("email", this.get("email"));
		    	target.set("creationDate", this.get("creationDate"));
		    	target.set("modifiedDate", this.get("modifiedDate"));
		    	target.set("enabled", this.get("enabled"));
		    	target.set("nameVisible", this.get("nameVisible"));
		    	target.set("emailVisible", this.get("emailVisible"));
		    	target.set("anonymous", this.get("anonymous"));
		    	if( typeof this.get("roles") === 'object' )
		    		target.set("roles", this.get("roles") );	
		    	if( typeof this.get("properties") === 'object' )
		    		target.set("properties", this.get("properties"));	    	
		}
	});
	
	
	community.model.Board = Model.define({ });

	
	community.model.Message = Model.define({ 		
		id: "messageId",
		fields: { 	
			user: { type: "object" , defaultValue : new community.model.User()},
			objectType: { type: "number", defaultValue: 0 },			
			objectId: { type: "number", defaultValue: 0 },			
			threadId: { type: "number", defaultValue: 0 },			
			messageId: { type: "number", defaultValue: 0 },			
			parentMessageId: { type: "number", defaultValue: 0 },			
			subject:{ type: "string", defaultValue: "" },			
			body:{type: "string", defaultValue: "" },			
			replyCount:{ type: "number", defaultValue: 0 },	
			creationDate:{ type: "date" },			
			modifiedDate:{ type: "date" }
		}
	});
	
	community.model.Thread = Model.define({ 
		id : "threadId",
		fields: { 	
			threadId: { type: "number", defaultValue: 0 },		
			objectType: { type: "number", defaultValue: 0 },		
			objectId: { type: "number", defaultValue: 0 },		
			latestMessage :{ type: "object", defaultValue: new community.model.Message() },	
			rootMessage	: { type: "object", defaultValue: new community.model.Message() },	
			messageCount: { type: "number", defaultValue: 0 },	
			viewCount: { type: "number", defaultValue: 0 },	
			creationDate: { type: "date" },			
			modifiedDate: { type: "date" }
		}
	});
	
	
	function getUserProfileImage ( user ) {
		var imageSrc = "/images/no-avatar.png";
		return imageSrc;
	}
	
	
	function getUserDisplayName (user){
		var displayName = "익명";
		if( user != null && !user.anonymous ){
			if( user.nameVisible )
			{
				displayName = user.name;
			}else{
				displayName = "**";
			}
		}
		return displayName ;
	}
	
	extend(community.data, {	
		getUserDisplayName : getUserDisplayName ,
		getUserProfileImage : getUserProfileImage
	});
	
	console.log("community.data initialized.");
	
}(window, jQuery));

