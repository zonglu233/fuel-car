Creator.Objects.object_recent_viewed = 
	name: "object_recent_viewed"
	label: "最近查看"
	icon: "forecasts"
	fields: 
#		record_id:
#			type: "text"
#		object_name:
#			type: "text"
#			searchable:true
#			index:true
		record:
			type: "lookup"
			label:"记录"
			omit: true
			is_name: true
			reference_to: ()->
				return _.keys(Creator.Objects)
		space:
			type: "text",
			omit: true
	permission_set:
		user:
			allowCreate: true
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: false 
		admin:
			allowCreate: true
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true

	list_views:
		all:
			columns: ["record", "space", "modified"]

if Meteor.isServer
	Meteor.publish "object_recent_viewed", (object_name)->
		collection = Creator.Collections["object_recent_viewed"]
		return collection.find({object_name: object_name, created_by: this.userId}, {fields: {record_id: 1, object_name: 1}, sort: {modified: -1}, limit: 20})

