# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".apply-btn").on "click", ->
    id = $(@).attr('id').split('-')[0]
    pass = $(@).attr('id').split('-')[2]
    rocket_id = $("#rocket_id").val()

    $.ajax({
      method: "POST",
      url: "/rocket_apply/" + id + "/pass",
      data: { pass: pass, rocket_id: rocket_id },
      dataType: "json",
      success: (data) ->
        $("div.attend-btn-wrapper.wrapper-" + data.id + " span").removeClass("active")
        $("span#" + data.id + "-apply-" + data.pass).addClass("active")
        return
      ,
      error: ->
        alert("Failed")
        return
    })
    return

  $(".table-apply-td").on "click", ->
    id = $(@).attr('id').split('-')[0]
    pass = $(@).attr('id').split('-')[1]
    rocket_id = $("#rocket_id").val()

    $.ajax({
      method: "POST",
      url: "/rocket_apply/" + id + "/pass",
      data: { pass: pass, rocket_id: rocket_id },
      dataType: "json",
      success: (data) ->
        $("tr.apply-tr-" + data.id + " td.table-apply-td").removeClass("active")
        $("td#" + data.id + "-" + data.pass).addClass("active")
        return
      ,
      error: ->
        alert("Failed")
        return
    })
    return
  return
