# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('select.mission-type').on "change", ->
    value = $(@).val()
    rocket_id = $(@).attr('id').split('-')[1]
    mission_id = $(@).attr('id').split('-')[3]
    rocket_member_id = $(@).attr('id').split('-')[5]
    $.ajax({
      method: "POST",
      url: "/rockets/" + rocket_id + "/mission_checks/change",
      data: { mission_id: mission_id, rocket_member_id: rocket_member_id, value: value },
      success: (data) ->
        return
      ,
      error: ->
        alert("fail")
        return
    })
    return
  return
