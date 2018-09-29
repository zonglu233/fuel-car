Creator.Objects.contracts = 
	name: "contracts"
	label: "合同"
	icon: "contract"
	enable_files: true
	enable_search: true
	enable_tasks: true
	enable_notes: true
	enable_api: true
	fields:
		name: 
			label: "名称"
			type: "text"
			required: true
			searchable: true
			index: true
		amount:
			label: "金额"
			type: "currency"
			required: true
			sortable: true
		signed_date:
			label: "签订日期" 
			type: "date"
			sortable: true
		owner:
			label: "责任人"
			omit: false
			sortable: true
		account:
			label: "对方单位"
			type: "master_detail"
			reference_to: "accounts"
		customer_contact:
			label: "联系人"
			type: "master_detail"
			reference_to: "contacts"
		start_date:
			label: "开始日期"
			type: "date"
			sortable: true
		end_date: 
			label: "结束日期"
			type: "date"
			sortable: true
		description: 
			label: "备注"
			type: "textarea"
			is_wide: true


	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "所有合同"
			columns: ["name", "amount", "signed_date", "account", "owner"]
			filter_scope: "space"
		mine:
			label: "我的合同"
			filter_scope: "mine"

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