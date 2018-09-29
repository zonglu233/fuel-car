request = Npm.require("request")
base64 = Npm.require('base-64');
fs = Npm.require 'fs'

# getAccessToken = (appId,secret,cb)->
# 	request.get {
# 		url:"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appId}&secret=#{secret}"
# 	},(err,httpResponse,body)->
# 		cb err, httpResponse, body
# 		if err
# 			console.error('get access_token failed:', err)
# 			return
# 		if httpResponse.statusCode ==200
# 			return body['access_token']

# getAccessTokenAsync = Meteor.wrapAsync(getAccessToken);

WebApp.connectHandlers.use '/api/steedos/weixin/code', (req, res, next) ->
	try
		appId = req.query.appid
		userId = Steedos.getUserIdFromAuthToken(req, res)
		secret = Meteor.settings.weixin.appSecret[appId]
		scene = req.query.scene or req.query.store_id
		page = req.query.page
		width = parseInt(req.query.width) || 430
		if req.query.line_color
			line_color = JSON.parse(req.query.line_color)
		else
			line_color = {"r":"35","g":"35","b":"35"}
		if req.query.is_hyaline == 'true'
			is_hyaline = true
		else
			is_hyaline = false
		if !secret
			throw new Meteor.Error(500, "无效的appId #{appId}")
		wxToken = WXMini.getNewAccessTokenSync appId, secret
		# console.log (resData)
		# wxToken = JSON.parse(resData.body)
		if wxToken
			formData = {
				page: page,
				scene:scene,
				width: width,
				line_color:line_color,
				is_hyaline:is_hyaline
			}
			requestSettings = {
				url: "https://api.weixin.qq.com/wxa/getwxacodeunlimit?access_token=",
				method: 'POST',
				encoding: null,
				qs: { access_token: wxToken },
				form: false,
				body: JSON.stringify(formData)
			}

			request requestSettings, Meteor.bindEnvironment((error, response, body) ->
				if error
					console.error error
					res.end()
					return
				res.setHeader('Content-type', 'image/jpeg')
				res.end(body)
			)
	catch e
		console.error e.stack
		JsonRoutes.sendResult res, {
			code: e.error
			data: {errors: e.reason || e.message}
		}
