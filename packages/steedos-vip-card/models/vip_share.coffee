Creator.Objects.vip_share =
	name: "vip_share"
	label: "分享"
	icon: "omni_supervisor"
	fields:
		name:
			label:'分享人'
			type:'text'
			#owner.name
		#分享人就是owner
		product:
			label: "商品"
			type: "lookup"
			reference_to: 'vip_product'
			index:true
		post:
			label: "动态"
			type: "lookup"
			reference_to: 'post'
			index:true
		other:#记录URL值
			label: "其他"
			type: "text"
			index:true
	list_views:
		all:
			label: "所有"
			columns: ["name", "product","created"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		member:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		guest:
			allowCreate: true
			allowDelete: false
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true

	triggers:
		"before.insert.server.vip_share":
			on: "server"
			when: "before.insert"
			todo: (userId, doc)->
				share = Creator.getCollection("vip_share").findOne({other:'love', owner:userId},{fields:{name:1}})
				if share
					throw new Meteor.Error 'repeat', "不能重复添加share记录"




