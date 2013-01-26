###
# app/assets/javascripts/connect.js
# connect wrapper
###

class Connect
  constructor: () ->
    @error = []
    options =
      type: "get"
      url: "/game/new"
      data: null
      success: (@data) =>
      error: (error) =>
        @error.push error
        if confirm "通信エラー。再試行しますか？"
          @request options
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
      error: ->
        options.error?()
  
  next_turn: (options) ->
    @request options

# Usage
# connect = new Connect (data) ->
# connect.next_turn options