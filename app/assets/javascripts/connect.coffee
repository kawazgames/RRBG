###
# app/assets/javascripts/connect.js
# connect wrapper
###

class Connect
  constructor: (f) ->
    @error = []
    options =
      type: "get"
      url: "/game/new"
      data: null
      success: f
    @request options
  
  request: (options) ->
    $.ajax
      type: options.type
      url: options.url
      data: options.data
      cache: false
      dataType: "json"
      success: ->
        options.success?()
      error: (error) =>
        @error.push error
        if confirm "通信エラー。再試行しますか？"
          @request options
  
  next_turn: (data, f) ->
    options =
      type: "post"
      url: "/game/next_turn"
      data: data
      success: f
    @request options

# Usage
# connect = new Connect (res) ->
# connect.next_turn req, (res) ->

