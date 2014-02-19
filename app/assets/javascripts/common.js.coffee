
localizeDates = () ->
    $.map $('.local-date'), (ee) ->
        date = new Date($(ee).text())
        $(ee).text(date.toDateString())

$(localizeDates)

