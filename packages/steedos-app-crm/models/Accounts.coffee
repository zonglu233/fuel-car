Creator.Objects.accounts = 
	name: "accounts"
	label: "单位"
	icon: "account"
	enable_files: true
	enable_search: true
	enable_tasks: true
	enable_notes: false
	enable_api: true
	enable_share: true
	fields:
		owner:
			label: "所有人"
			omit: false
			readonly: true
		priority:
			label: "优先级"
			type: "select"
			sortable: true
			options: [
				{label: "高", value: "high"},
				{label: "中", value: "normal"},
				{label: "低", value: "low"}
			]
		name: 
			label: "名称"
			type: "text"
			defaultValue: ""
			description: ""
			inlineHelpText: ""
			searchable:true
			required: true
			sortable: true
		website: 
			type: "text"
			label: "网址"
		phone:
			type: "text"
			label: "电话"
			defaultValue: ""
		fax:
			type: "text"
			label: "传真"
		description: 
			label: "描述"
			type: "textarea"
			is_wide: true

	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "所有单位"
			columns: ["name", "priority", "owner", "modified"]
			filter_scope: "space"
		mine:
			label: "我的单位"
			filter_scope: "mine"

	actions: 
		export:
			label: "导出"
			visible: false
		print:
			label: "打印"
			on: "record"
			only_detail: true
			visible: false
			todo: ()->
				alert("you clicked on print button") 

	permission_set:
		user:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		admin:
			allowCreate: true
			allowDelete: true
			allowEdit: true
			allowRead: true
			modifyAllRecords: true
			viewAllRecords: true
