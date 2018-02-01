# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $(".btn-rocket-tag").click (e)->
    inputTag(e)
  return

inputTag = (e) ->
  id = e.target.id
  if id == "rocket-user-tag"
    val = $("#rocket_user_tag").val()
  else if id == "rocket-product-tag"
    val = $("#rocket_product_tag").val()
  else if id == "rocket-instagram-tag"
    val = $("#rocket_instagram_tag").val()
  else
    val1 = $("#rocket_user_tag").val()
    val2 = $("#rocket_product_tag").val()
    val3 = $("#rocket_instagram_tag").val()

  $.ajax({
    method: "POST",
    url: "/rocket_regrams/tag",
    data: { type: id, val: val, val1: val1, val2: val2, val3: val3 },
    dataType: "json",
    success: (data) ->
      $("#rocket_regram_content").val($("#rocket_regram_content").val() + data.text)
      return
    ,
    error: ->
      alert("Failed")
      return
  })
  return

$ ->
  $(".btn-rocket-copy").click ->
    text = $("#rocket_regram_content").clone().find('br').prepend('\r\n').end().text()
    element = $('<textarea>').appendTo('body').val(text).select()
    document.execCommand('copy')
    element.remove()
    return

  $("#rocket_regram_rocket_member_id").change ->
    $("#rocket_user_name").val($(@).val())
    return

  $("#rocket_regram_date").change ->
    regram_day = $(@).val()
    start_day = $("#rocket_start_date").val()
    count_day = (new Date(regram_day) - new Date(start_day))/1000/60/60/24

    if count_day >= 0
      $("#rocket_count_day").val(count_day)
    else
      alert("로켓단 시작일 보다 이전 날짜를 선택하였습니다.")
      $("#rocket_regram_date").val($("#rocket_start_date").val())
    return

  return
