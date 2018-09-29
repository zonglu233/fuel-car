Creator.Objects.contract_payments = 
	name: "contract_payments"
	label: "付款"
	icon: "orders"
	fields:
		name: 
			label: "名称"
			type: "text"
			required: true
			searchable:true
			is_wide: true
		amount:
			label: "金额"
			type: "currency"
			required: true
			sortable: true
		due_date:
			label: "计划付款日期"
			type: "date"
			sortable: true
		contract:
			label: "合同"
			type: "master_detail"
			reference_to: "contracts"
			required: true
			sortable: true
		account:
			label: "单位"
			type: "master_detail"
			reference_to: "accounts"
			sortable: true
		is_closed:
			label: "已付款"
			type: "boolean"
		close_date:
			label: "实际付款日期"
			type: "date"
			sortable: true
		billing_date:
			label: "发票日期"
			type: "date"
			sortable: true
		billing_no:
			label: "发票号"
			type: "text"
		description: 
			label: "备注"
			type: "textarea"
			is_wide: true

	list_views:
		recent:
			label: "最近查看"
			filter_scope: "space"
		all:
			label: "所有"
			columns: ["name", "amount", "contract", "due_date", "is_closed"]
			filter_scope: "space"

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