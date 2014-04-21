
localizeDates = () ->
    $.map $('.local-date'), (ee) ->
        date = new Date($(ee).text())
        text = date.toDateString()
        if text == "Invalid Date"
          text = "None"
        $(ee).text(text)

$(localizeDates)

