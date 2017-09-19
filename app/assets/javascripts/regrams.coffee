# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
inputTag = (e) ->
  id = e.target.id
  if id == "user-tag"
    val = $("#user_tag").val()
  else if id == "product-tag"
    val = $("#product_tag").val()
  else
    val = $("#instagram_tag").val()

  $.ajax({
    method: "POST",
    url: "/regrams/tag",
    data: { type: id, val: val },
    dataType: "json",
    success: (data) ->
      console.log(data.text)
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
    $temp = $("<input>")
    $("body").append($temp)
    $temp.val($("#regram_content").text()).select()
    document.execCommand("copy")
    $temp.remove()
    return
  return

$ ->
  $(document).on 'change', 'input#regram_img', (event)->
    preview = $(".preview")
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

