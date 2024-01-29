import Dates
function elapsed_time(start_time::Dates.DateTime, print_line = false)
    end_time = Dates.now()
    time_diff = end_time - start_time

    total_seconds = round(Int, Dates.value(time_diff) / 1000)

    hours = div(total_seconds, 3600)
    minutes = div(mod(total_seconds, 3600), 60)
    seconds = mod(total_seconds, 60)

    formatted_time_diff = "$(hours)h $(minutes)m $(seconds)s"

    if print_line
        println("Time elapsed: ", formatted_time_diff)
    end

    return formatted_time_diff  # Return end_time without printing it
end
start_time = Dates.now()
elapsed_time(start_time)
