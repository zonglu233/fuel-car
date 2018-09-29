Creator.Objects.vip_coupon =
	name: "vip_coupon"
	label: "优惠券"
	icon: "product_required"
	fields:
		name:
			label:'标题'
			type:'text'
		quota:
			label:'面值'
			type:'currency'
		min_consumption:
			label:'最低消费'
			type:'currency'
		total_count:
			label:'发行数量'
			type:'number'
		remain_count:
			label:'剩余'
			type:'number'
			omit:true
		received_count:
			label:'已领取'
			type:'number'
			omit:true
		used_count:
			label:'已使用'
			type:'number'
			omit:true
		start_time:
			label:'开始时间'
			type:'datetime'
		end_time:
			label:'结束时间'
			type:'datetime'
		limit_count:
			label:'每人限领'
			type:'select'
			options:[
				{label:'无限制',value:'无限制'},
				{label:'1张',value:'1张'},
				{label:'2张',value:'2张'},
				{label:'3张',value:'3张'}
			]
		enable_fission:
			label:'允许裂变'
			type:'boolean'
			defaultValue:true
		fission_count:
			label:'每次领取后，可裂变成'
			type:'select'
			options:[
				{label:'5张',value:'5张'},
				{label:'10张',value:'10张'},
				{label:'15张',value:'15张'},
				{label:'20张',value:'20张'}
			]
		apply_stores:
			label:'可用门店'
			type:'master_detail'
			multiple:true
			reference_to:'vip_store'
		card_ids:
			label:'会员卡'
			type:'master_detail'
			multiple:true
			reference_to:'vip_card'
		expire_reminder:
			label:'到期提醒'
			type:'select'
			options:[
				{label:'到期前一周',value:"-P7D"},
				{label:'到期前5天',value:"-P5D"},
				{label:'到期前4天',value:"-P4D"},
				{label:'到期前3天',value:"-P3D"}
			]   
		description:
			label:'说明'
			type:'textarea'
			is_wide:true
	list_views:
		all:
			label: "所有"
			columns: ["name", "quota", "apply_stores","remain_count","total_count","received_count","used_count"]
			filter_scope: "space"
	permission_set:
		user:
			allowCreate: false
			allowDelete: false
			allowEdit: false
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
		guest:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true
		member:
			allowCreate: false
			allowDelete: false
			allowEdit: false
			allowRead: true
			modifyAllRecords: false
			viewAllRecords: true