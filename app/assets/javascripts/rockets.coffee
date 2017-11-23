# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $("input#rocket_start_date, select#rocket_term").on "change", ->
    term = $("select#rocket_term").val()
    start_date = $("input#rocket_start_date").val()

    # start_date
    parts = start_date.split("-")
    start_date = new Date(parts[0], parts[1] - 1, parts[2])

    # end_date
    end_date = new Date(start_date.getTime() + term*24*60*60*1000)

    year = end_date.getFullYear()
    month = end_date.getMonth() + 1
    day = end_date.getDate()

    month = '0' + month if month.toString().length < 2
    day = '0' + day if day.toString().length < 2

    end_date = [year, month, day].join('-')

    $("input#rocket_end_date").val(end_date)
    return

  $(".rocket-link").on "click", ->
    rocket = $("#rocket_id").val()
    id = window.location.toString().split('/')[4]
    new_url = window.location.toString().replace(id, rocket)
    window.location.replace(new_url)
    return

  $(".attend-btn").on "click", ->
    status = $(@).attr('id').split('-')[2]
    date1 = $("#attend_date_1i").val()
    date2 = $("#attend_date_2i").val()
    date3 = $("#attend_date_3i").val()
    id = $(@).attr('id').split('-')[0]
    rocket_id = $("#rocket_id").val()
    $.ajax({
      method: "POST",
      url: "/rockets/" + id + "/check",
      data: { status: status, date1: date1, date2: date2, date3: date3, rocket_id: rocket_id },
      dataType: "json",
      success: (data) ->
        $("div.attend-btn-wrapper.wrapper-" + data.id + " span").removeClass("status")
        $("span#" + data.id + "-attend-" + data.status).addClass("status")
        return
      ,
      error: ->
        alert("Failed")
        return
    })
    return
  return
