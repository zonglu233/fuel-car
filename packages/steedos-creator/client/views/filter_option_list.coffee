Template.filter_option_list.helpers Creator.helpers

Template.filter_option_list.helpers 
	filterItems: ()->
		return Template.instance()?.filterItems.get()
	
	filterScope: ()->
		scope = Session.get("filter_scope")
		if scope == "space"
			return "All"
		else if scope == "mine"
			return "My"
	
	relatedObject: ()->
		object_name = Template.instance().data?.object_name
		return Creator.getObject(object_name)

	filter_logic: ()->
		return Session.get("filter_logic")

	isFilterLogicEmpty: ()->
		return Session.get("filter_logic") == undefined or Session.get("filter_logic") == null

Template.filter_option_list.events 
	'click .btn-filter-scope': (event, template)->
		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		top = $(event.currentTarget).closest("li").offset().top
		offsetLeft = $(event.currentTarget).closest(".filter-list-wraper").offset().left
		offsetTop = $(event.currentTarget).closest(".filter-list-wraper").offset().top
		contentHeight = $(event.currentTarget).closest("li").height()

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 170/2 + contentHeight/2

		if template.optionbox
			Blaze.remove template.optionbox
		Meteor.defer ->
			object_name = template.data?.object_name
			data = 
				top: "#{top}px"
				left: "#{left}px"
				is_edit_scope: true
				object_name: object_name
			template.optionbox = Blaze.renderWithData(Template.filter_option, data, $(".filter-option-box")[0])

	'click .filter-option-item': (event, template)->
		index = $(event.currentTarget).closest(".filter-item").index()
		if index < 0
			index = 0

		left = $(event.currentTarget).closest(".filter-list-container").offset().left
		top = $(event.currentTarget).closest("li").offset().top
		contentHeight = $(event.currentTarget).closest("li").height()

		offsetLeft = $(event.currentTarget).closest(".filter-list-wraper").offset().left
		offsetTop = $(event.currentTarget).closest(".filter-list-wraper").offset().top

		# 弹出框的高度和宽度写死
		left = left - offsetLeft - 400 - 6
		top = top - offsetTop - 336/2 + contentHeight/2

		# 计算弹出框是否超出屏幕底部，导致出现滚动条，如果超出，调整top位置
		# 计算方式：屏幕高度 - 弹出框的绝对定位 - 弹出框的高度 - 弹出框父容器position:relative的offsetTop - 弹出框距离屏幕底部10px
		# 如果计算得出值小于0，则调整top，相应上调超出的高度
		windowHeight = $(window).height()
		windowOffset = $(window).height() - top - 336 - offsetTop - 10

		if windowOffset < 0
			top = top + windowOffset

		if template.optionbox
			Blaze.remove template.optionbox
		Meteor.defer ->
			filter_items = Session.get("filter_items")
			if index > -1 and filter_items
				filterItem = filter_items[index]
			object_name = template.data?.object_name
			data = 
				top: "#{top}px"
				left: "#{left}px"
				index: index
				filter_item: filterItem
				is_edit_scope: false
				object_name: object_name
			template.optionbox = Blaze.renderWithData(Template.filter_option, data, $(".filter-option-box")[0])

	'click .removeFilter': (event, template)->
		index = $(event.currentTarget).closest(".filter-item").index()
		if index < 0
			index = 0
		filter_items = Session.get("filter_items")
		filter_items.splice(index, 1)
		Session.set("filter_items", filter_items)

	'click .add-filter': (event, template)->
		filter_items = Session.get("filter_items")
		unless filter_items
			filter_items = []
		filter_items.push({})
		Session.set("filter_items", filter_items)
		Meteor.defer ->
			template.$(".filter-option-item:last").click()

	'click .remove-all-filters': (event, template)->
		Session.set("filter_items", [])

	'click .add_filter_logic': (e, t)->
		filter_items = Session.get "filter_items"
		arr = []
		i = 0
		while i < filter_items.length
			arr.push(i + 1)
			i++

		val = arr.join(" AND ")
		console.log "val", val
		Session.set("filter_logic", val)
		

	'click .remove_filter_logic': (e, t)->
		Session.set("filter_logic", undefined)

	'keyup #filter-logic': (e, t)->
		val = $(e.currentTarget).val()
		Session.set("filter_logic", val)


Template.filter_option_list.onCreated ->
	self = this
	unless this.data?.object_name
		this.data.object_name = Session.get("object_name")
	self.destroyOptionbox = ()->
		if self.optionbox and !self.optionbox.isDestroyed and $(self.optionbox.firstNode()).find(event.target).length == 0
			Blaze.remove self.optionbox
	
	#绑定事件从document委托到.wrapper中是为了避免过虑器中选人控件会解决该事件
	$(document).on "click",".content-wrapper, .oneHeader", self.destroyOptionbox

	self.filterItems = new ReactiveVar()
	self.autorun -> 
		list_view_obj = Creator.Collections.object_listviews.findOne(Session.get("list_view_id"))
		if list_view_obj and list_view_obj.filter_logic
			Session.set("filter_logic", list_view_obj.filter_logic)

	self.autorun ->
		if Session.get("filter_items")
			filters = Session.get("filter_items")
			self.filterItems.set(filters)
			object_name = Template.instance().data?.object_name
			fields = Creator.getObject(object_name)?.fields
			unless fields
				return
			filters?.forEach (filter) ->
				filter.fieldlabel = fields[filter.field]?.label
				filter.valuelabel = filter?.value
				field = fields[filter.field]
				if field?.type == 'lookup' or field?.type =='master_detail' or field?.type=='select'
					reference_to_objects = []
					if field?.reference_to
						if field.reference_to.constructor == Array
							reference_to_objects = field.reference_to
						else
							reference_to_objects.push field.reference_to
						reference_to_objects.forEach (reference_to_object)->
							name_field = Creator.getObject(reference_to_object).NAME_FIELD_KEY
							Meteor.call 'getValueLable',reference_to_object,name_field,filter.value,
								(error,result)->
									if result
										filter.valuelabel = result
										self.filterItems.set(filters)
					if field?.optionsFunction or field?.options
						if field.optionsFunction
							options = field?.optionsFunction()
						else
							options = field.options
						options_labels = []
						_.each options,(option)->
							if filter?.value
								if _.indexOf(filter.value,option.value)>-1
									options_labels.push option.label
						filter.valuelabel = options_labels
				else
					self.filterItems.set(filters)	

Template.filter_option_list.onRendered ->
	$("#info_popover").dxPopover({
		target: "#logic_logic",
		showEvent: "mouseenter",
		hideEvent: "mouseleave",
		position: "top",
		width: 300,
		animation: { 
			show: {
				type: "pop",
				from: {  scale: 0 },
				to: { scale: 1 }
			},
			hide: {
				type: "fade",
				from: 1,
				to: 0
			}
		}
	});

Template.filter_option_list.onDestroyed ->
	$(document).off "click", ".wrapper", self.destroyOptionbox
	