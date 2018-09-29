Creator.Objects.cms_files =
	name: "cms_files"
	label: "文件"
	icon: "drafts"
	enable_search: true
	enable_api: true
	hidden: true
	fields:
		name:
			label: "名称"
			type: "text"
			searchable:true
			index:true
		description:
			label: "描述"
			type: "textarea"
		extention:
			label: "文件后缀"
			type: "text"
			disabled: true
		size:
			label: "文件大小"
			type: "filesize"
			disabled: true
		versions:
			label: "历史版本"
			type: "file"
			collection: "files"
			multiple: true
			omit: true
		parent:
			label: "起始版本"
			type: "lookup"
			omit: true
			reference_to: ()->
				return _.keys(Creator.Objects)

	list_views:
		all:
			columns: ["name", "size", "owner", "created", "modified"]
			extra_columns: ["versions"]
			order: [[4, "asc"]]
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
			modifyAllRecords: false
			viewAllRecords: true

	triggers:
		"before.remove.server.default":
			on: "server"
			when: "before.remove"
			todo: (userId, doc)->
				collection = cfs.files
				collection.remove {"metadata.parent": doc._id}

	actions:
		download:
			label: "下载"
			visible: true
			on: "record"
			todo: (object_name, record_id, fields)->
				file = Creator.getObjectRecord(object_name,record_id)
				fileId = file?.versions?[0]
				if fileId
					if Meteor.isCordova
						url = Steedos.absoluteUrl("/api/files/files/#{fileId}")
						filename = file.name
						rev = fileId
						length = file.size
						Steedos.cordovaDownload(url, filename, rev, length)
					else
						window.location = Steedos.absoluteUrl("/api/files/files/#{fileId}?download=true")
		new_version:
			label: "上传新版本"
			visible: true
			is_file: true
			on: "record"
			todo: (object_name, record_id, fields)->
		standard_delete:
			label: "删除"