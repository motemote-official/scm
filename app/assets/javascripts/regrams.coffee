# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
inputTag = (e) ->
  id = e.target.id
  if id == "user-tag"
    val = $("#user_tag").val()
  else if id == "product-tag"
    val = $("#product_tag").val()
  else if id == "instagram-tag"
    val = $("#instagram_tag").val()
  else
    val1 = $("#user_tag").val()
    val2 = $("#product_tag").val()
    val3 = $("#instagram_tag").val()

  $.ajax({
    method: "POST",
    url: "/regrams/tag",
    data: { type: id, val: val, val1: val1, val2: val2, val3: val3 },
    dataType: "json",
    success: (data) ->
      $("#regram_content").val($("#regram_content").val() + data.text)
      return
    ,
    error: ->
      alert("Failed")
      return
  })
  return

$ ->
  $(".btn-copy").click ->
    text = $("#regram_content").clone().find('br').prepend('\r\n').end().text()
    element = $('<textarea>').appendTo('body').val(text).select()
    document.execCommand('copy')
    element.remove()
    return
  return

$ ->
  $(document).on 'change', '.input-file-field', (event)->
    index = $(@).data 'index-no'
    preview = $(".img_label img#preview#{index}")
    input = $(event.currentTarget)
    file = input[0].files[0]
    reader = new FileReader()
    reader.onload = (e) =>
      image_base64 = e.target.result
      preview.attr("src", image_base64)
      return
    reader.readAsDataURL(file)
    preview.attr("style", "opacity:1;")
    return
  return

$ ->
  $(".btn-tag").click (e)->
    inputTag(e)
  return

maxPicsCount = 20
minPicsCount = 1

$ ->
  $addLink_pic = $('#pics')

  togglePicsLink = ->
    picsCount = $('.img_label:visible').length
    $addLink_pic.toggle(picsCount < maxPicsCount)
    $('.remove_pics').toggle(picsCount > minPicsCount)
    return

  $(document).on 'click', '#pics', ->
    togglePicsLink()
    return
  $(document).on 'click', '.remove_pics', ->
    togglePicsLink()
    return

  if $('.img_label')?
    togglePicsLink()
    return

$ ->
  $(document).on 'change', '#regram_member_id', ->
    $("#user_name").val($(@).val())
    return

  return
