#### methods for drawing schematic representation of processes

## Constants ####
keys <- c("region", "year", "slice", "comm", "acomm",
          "value", "lab_par", "lab_txt",
          "tech", "group", "weather", "unit", "io", "parameter")

## draw.technology ####
#' Draw a schematic representation of a technology
#'
#' @param obj A technology object
#' @param ... Additional arguments, currently not used
#'
#' @return A draw of the technology
#' @export
#'
#' @examples
#' TECH01 <- newTechnology(
#'   "TECH01",
#'   desc = "Technology Description",
#'   input = data.frame(
#'     comm = c("COM1", "COM2", "COM5", "COM7", "COM8", "COM9"),
#'     group = c("1", "1", NA, "2", "2", "2"),
#'     unit = c("unit1", "unit2", "unit5", "unit7", "unit8", "unit9")
#'   ),
#'   output = data.frame(
#'     comm = c("COM3", "COM4", "COM6"),
#'     group = c("3", NA, "3"),
#'     unit = c("unit3", "unit4", "unit6")
#'   ),
#'   group = data.frame(
#'     group = c("1", "2", "3"),
#'     desc = c("Group1", "Group2", "Group3"),
#'     unit = "unit"
#'   ),
#'   aux = data.frame(
#'     acomm = c("AUX1", "AUX2", "AUX3", "AUX4"),
#'     unit = c("unit1", "unit2", "unit3", "unit4")
#'   ),
#'   region = c("R1", "R2", "R3"),
#'   geff = data.frame(
#'     group = c("1", "2"),
#'     ginp2use = c(0.12, 0.789)
#'   ),
#'   ceff = data.frame(
#'     comm = c("COM1", "COM2", "COM5", "COM7", "COM8", "COM9", "COM3", "COM4", "COM6"),
#'     cinp2ginp = c(.1, .2, NA, .7, .8, .9, rep(NA, 3)),
#'     cinp2use = c(NA, NA, .5, NA, NA, NA, rep(NA, 3)),
#'     use2cact = c(rep(NA, 6), .36, .4, .36),
#'     cact2cout = c(rep(NA, 6), .3, NA, .6),
#'     share.lo = c(.01, .02, NA, .07, .08, .0, .03, NA, .06),
#'     share.up = c(.91, .92, NA, .97, .98, 1, .83, NA, .96)
#'   ),
#'   aeff = data.frame(
#'     acomm = c("AUX1", "AUX2", "AUX3", "AUX4"),
#'     comm = c(NA, "COM1", NA, "COM3"),
#'     act2ainp = c(1, NA, NA, NA),
#'     cinp2aout = c(NA, 2, NA, NA),
#'     cap2aout = c(NA, NA, 3, NA),
#'     cout2aout = c(NA, NA, NA, 4)
#'   ),
#'   weather = data.frame(
#'     weather = "WEATHER_CF1",
#'     waf.up = .99
#'   )
#' )
#' draw(TECH01)
draw.technology <- function(obj, ...) {

  # browser()

  # key columns
  keys <- c("region", "year", "slice", "comm", "acomm",
            # "value",
            "lab_par", "lab_txt",
            "tech", "group", "weather", "unit", "io", "parameter")

  # com_tbl <- bind_rows(
  #   obj@input |>  mutate(io = "cinp", .before = 1),
  #   obj@output |> mutate(io = "cout", .before = 1)
  # ) |>
  com_inp <- obj@input |>
    mutate(io = "cinp", .before = 1) |>
    rowwise() |>
    mutate(
      lab_txt = make_label(
        comm,
        in_brackets = unit,
        two_lines = F
      )
    ) |>
  # add technology parameters
    left_join(obj@ceff, by = "comm") |>
    pivot_longer(
      cols = matches("2"), # non-grouped-comm-params have "2" in their names
      names_to = "parameter",
      values_to = "value"
    ) |>
    filter(!grepl("cact|out", parameter)) |>
    group_by(io, comm) |>
    filter(!is.na(value) | (all(is.na(value)) & row_number() == 1)) |>
    ungroup()

  com_out <- obj@output |>
    mutate(io = "cout", .before = 1) |>
    rowwise() |>
    mutate(
      lab_txt = make_label(
        comm,
        in_brackets = unit,
        two_lines = F
      )
    ) |>
    # add technology parameters
    left_join(obj@ceff, by = "comm") |>
    pivot_longer(
      cols = matches("2"), # non-grouped-comm-params have "2" in their names
      names_to = "parameter",
      values_to = "value"
    ) |>
    filter(grepl("cact|out", parameter)) |>
    group_by(io, comm) |>
    filter((!is.na(value)) |
             (all(is.na(value)) & row_number() == 1)) |>
    ungroup()

  com_par <- bind_rows(com_inp, com_out)

  # # add technology parameters
  # com_par <- com_tbl |>
  #   full_join(obj@ceff, by = "comm") |>
  #   pivot_longer(
  #     cols = matches("2"), # non-grouped-comm-params have "2" in their names
  #     names_to = "parameter",
  #     values_to = "value"
  #   ) |>
  #   group_by(io, comm) |>
  #   filter(!is.na(value) | (is.na(value) & row_number() == 1))

  # parameter-labels for grouped commodities
  # gcom_par <- com_par |> filter(!is.na(group))
  gcom_inp <- com_inp |> filter(!is.na(group))
  gcom_out <- com_out |> filter(!is.na(group))
  gcom_par <- bind_rows(gcom_inp, gcom_out)


  if (nrow(gcom_par) > 0) {

    gcom_par <- gcom_par |>
      group_by(across(any_of(c("comm", "acomm", "group", "unit", "io", "parameter")))) |>
      summarise(
        val_lbl = make_label(
          paste0(parameter, ":"),
          # in_brackets = prettyNum(value, digits = 2),
          in_brackets = format_number(value),
          two_lines = if_else(all(grepl("use2cact", parameter)), T, F),
          bracket_type = NULL
        ),
        share_lbl = paste0(
          # paste0(round(100 * min(share.lo, share.fx, na.rm = T), 2), "%,",
          #        round(100 * max(share.up, share.fx, na.rm = T), 2), "%")
          paste0(min(share.lo, share.fx, na.rm = T), ",",
                 max(share.up, share.fx, na.rm = T))
          ),
        lab_par = make_label(
          val_lbl,
          in_brackets = if_else(all(grepl("use2cact", parameter)),
                                NA,
                                share_lbl),
          two_lines = T,
          bracket_type = "square"
        ),
        # lab_use2cact = make_label(
        #   val_lbl,
        #   in_brackets = val_lbl,
        #   two_lines = F
        # ),
        .groups = "drop"
      ) |>
      rowwise() |>
      mutate(
        lab_par = if_else(
          grepl("use2cact", parameter),
          val_lbl,
          lab_par
        ),
        lab_txt = make_label(
          comm,
          in_brackets = unit,
          two_lines = F
        )
      ) |>
      select(-val_lbl, -share_lbl) |>
      select(-any_of(c("region", "year", "slice")))
      # as.data.table()
    gcom_par$lab_par
    gcom_par

  }

  # parameter-labels for non-grouped commodities
  ccom_par <- com_par |>
    filter(is.na(group)) |>
    group_by(across(
      any_of(keys)
      # any_of(c("io", "comm", "region", "year", "slice", "parameter"))
    )) |>
    summarise(
      lab_par = make_label(
        paste0(parameter, ":"),
        in_brackets = value,
        two_lines = F
      ),
      .groups = "drop"
    )|>
    select(-any_of(c("region", "year", "slice")))
  ccom_par

  # auxiliary inputs ####
  aux_tbl <- obj@aux |>
    full_join(obj@aeff, by = "acomm")

  ainp <- aux_tbl |>
    select(
      # any_of(c("acomm", "comm", "region", "year", "slice", "unit")),
      any_of(c(keys)),
      matches("ainp")
    ) |>
    rowwise() |>
    mutate(
      ainp = sum(abs(c_across(matches("ainp"))), na.rm = TRUE)
    ) |>
    filter(ainp != 0) |>
    # drop numeric columns columns with all NAs
    select(-where(~all(is.na(.)) & is.numeric(.)), -ainp) |>
    mutate(io = "ainp", .before = 1)
  ainp

  # aux outputs ####
  aout <- aux_tbl |>
    select(
      # any_of(c("acomm", "comm", "region", "year", "slice", "unit")),
      any_of(c(keys)),
      matches("aout")
    ) |>
    rowwise() |>
    mutate(
      aout = sum(abs(c_across(matches("aout"))), na.rm = TRUE)
    ) |>
    filter(aout != 0) |>
    # drop numeric columns columns with all NAs
    select(-where(~all(is.na(.)) & is.numeric(.)), -aout) |>
    mutate(io = "aout", .before = 1)
  aout

  # aux combined
  # browser()
  aux <- bind_rows(ainp, aout) 
  if (nrow(aux) > 0) {
    aux <- aux |>
      pivot_longer(
        # cols = -any_of(c("io", "acomm", "comm", "region", "year", "slice", "unit")),
        cols = -any_of(c(keys)),
        names_to = "parameter",
        values_to = "value"
      ) |>
      filter(!is.na(value)) |>
      group_by(io, acomm, comm, unit, parameter) |>
      summarise(
        lab_par = make_label(
          paste0(parameter, ":"),
          in_brackets = value,
          two_lines = F,
          bracket_type = "square"
        ),
        .groups = "keep"
      ) |>
      mutate(
        lab_txt = make_label(
          acomm,
          in_brackets = unit,
          two_lines = F
        ),
        lab_par = if_else(is.na(comm),
                          lab_par,
                          make_label(lab_par, in_brackets = comm, two_lines = T)
        )
      ) |>
      ungroup()
  }

  aux

  # weather factors
  wea <- obj@weather |>
    rowwise() |>
    mutate(
      lab_wafc = if_else(
        !is.na(wafc.fx),
        # create a label with the fixed value, ignore the lo and up values
        make_label("wafc.fx:", in_brackets = wafc.fx, two_lines = F),
        # "A",
        # create a label with the lo and up values
        # NA
        if_else(!is.na(wafc.lo) & !is.na(wafc.up),
                paste0("wafc.lo: ", wafc.lo, "\n", "wafc.up: ", wafc.up),
                if_else(!is.na(wafc.lo),
                        # create a label with the lo value
                        paste0("wafc.lo: ", wafc.lo),
                        # create a label with the up value
                        if_else(!is.na(wafc.up),
                                paste0("wafc.up: ", wafc.up),
                                # if all values are NA, return NA
                                NA_character_)
                        )
                )
        )
      ) |>
    select(-wafc.lo, -wafc.up, -wafc.fx) |>
    mutate(
      lab_waf = if_else(
        !is.na(waf.fx),
        make_label("waf.fx:", in_brackets = waf.fx, two_lines = F),
        if_else(!is.na(waf.lo) & !is.na(waf.up),
                paste0("waf.lo: ", waf.lo, "\n", "waf.up: ", waf.up),
                if_else(!is.na(waf.lo),
                        paste0("waf.lo: ", waf.lo),
                        if_else(!is.na(waf.up),
                                paste0("waf.up: ", waf.up),
                                NA_character_)
                        )
                )
        )
      ) |>
    select(-waf.lo, -waf.up, -waf.fx) |>
    mutate(
      lab_wafs = if_else(
        !is.na(wafs.fx),
        make_label("wafs.fx:", in_brackets = wafs.fx, two_lines = F),
        if_else(!is.na(wafs.lo) & !is.na(wafs.up),
                paste0("wafs.lo: ", wafs.lo, "\n", "wafs.up: ", wafs.up),
                if_else(!is.na(wafs.lo),
                        paste0("wafs.lo: ", wafs.lo),
                        if_else(!is.na(wafs.up),
                                paste0("wafs.up: ", wafs.up),
                                NA_character_)
                        )
                )
        )
      ) |>
    select(-wafs.lo, -wafs.up, -wafs.fx) |>
    rowwise() |>
    mutate(
      lab_txt = if_else(
        is.na(comm),
        weather,
        make_label(weather, in_brackets = comm, two_lines = F)),
      lab_par = if_else(
        all(is.na(c(lab_wafc, lab_waf, lab_wafs))),
        NA_character_,
        paste(na.omit(c(lab_wafc, lab_waf, lab_wafs)), collapse = "\n")
        )
      ) |>
    select(-lab_wafc, -lab_waf, -lab_wafs) |>
    mutate(
      io = "winp"
    )
    wea

  geff <- obj@geff |>
    pivot_longer(
      cols = ginp2use,
      names_to = "parameter",
      values_to = "value"
    ) |>
    filter(!is.na(value)) |>
    group_by(across(any_of(keys))) |>
    summarise(
      lab_par = make_label(
        paste0(parameter, ":"),
        # NULL,
        in_brackets = value,
        two_lines = T
      ),
      .groups = "drop"
    ) |>
    mutate(
      io = "ginp",
      lab_txt = NA_character_
    )
  geff


  # inputs to draw_process ####
  grouped_com_inputs <- gcom_par |>
    bind_rows(geff) |>
    filter(grepl("inp", io)) |>
    select(io, comm, group, parameter, lab_par) |>
    rename(ioname = comm, iotype = io) |>
    unique()


  single_com_inputs <- ccom_par |>
    filter(grepl("inp", io)) |>
    select(io, comm, parameter, lab_par) |>
    rename(ioname = comm, iotype = io) |>
    unique()

  aux_inputs <- aux |>
    filter(grepl("inp", io)) |>
    select(any_of(c(
      "io", "acomm", "parameter", "lab_par"
    ))) |>
    rename(ioname = acomm, iotype = io) |>
    unique()

  weather_factors <- wea |>
    select(io, weather, lab_par) |>
    rename(ioname = weather, iotype = io) |>
    unique()

  # outputs to draw_process ####
  grouped_com_outputs <- gcom_par |>
    filter(grepl("out", io)) |>
    select(any_of(c("comm", "value", "lab_txt", "lab_par", "group", "unit",
                    "io", "parameter", "lab_par"))) |>
    rename(ioname = comm, iotype = io) |>
    unique()

  single_com_outputs <- ccom_par |>
    select(any_of(c("comm", "value", "lab_txt", "lab_par", "group", "unit",
                    "io", "parameter", "lab_par"))) |>
    filter(grepl("out", io)) |>
    rename(ioname = comm, iotype = io) |>
    unique()

  aux_outputs <- aux |>
    filter(grepl("out", io)) |>
    select(any_of(c(
      "io", "acomm", "parameter", "lab_par"
    ))) |>
    rename(ioname = acomm, iotype = io) |>
    unique()


  # arrow_labels (all inputs and outputs) ####
  arrow_labels_tb <- data.table()
  if (nrow(gcom_par) > 0) {
    arrow_labels_tb <- rbindlist(list(
      arrow_labels_tb,
      gcom_par |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = comm)
    ),
    use.names = TRUE, fill = TRUE
    )
  }
  if (nrow(ccom_par) > 0) {
    arrow_labels_tb <- rbindlist(list(
      arrow_labels_tb,
      ccom_par |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = comm)
    ),
    use.names = TRUE, fill = TRUE
    )
  }
  if (nrow(aux) > 0) {
    arrow_labels_tb <- rbindlist(list(
      arrow_labels_tb,
      aux |> select(any_of(c("acomm", "lab_txt"))) |> unique() |> rename(ioname = acomm)
    ),
    use.names = TRUE, fill = TRUE
    )
  }
  if (nrow(wea) > 0) {
    arrow_labels_tb <- rbindlist(list(
      arrow_labels_tb,
      wea |> select(any_of(c("weather", "lab_txt"))) |> unique() |> rename(ioname = weather)
    ),
    use.names = TRUE, fill = TRUE
    )
  }

  # arrow_labels_tb <- rbindlist(list(
  #   gcom_par |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = comm),
  #   ccom_par |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = comm),
  #   aux |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = acomm),
  #   wea |> select(any_of(c("comm", "lab_txt"))) |> unique() |> rename(ioname = weather)
  # ), 
  # use.names = TRUE, fill = TRUE
  # )

  # cap2act ####
  cap2act_label <- paste0("cap2act: ", obj@cap2act)

  stopifnot(length(unique(arrow_labels_tb$ioname)) == nrow(arrow_labels_tb))
  arrow_labels <- arrow_labels_tb$lab_txt
  names(arrow_labels) <- arrow_labels_tb$ioname
  stopifnot(length(arrow_labels) == nrow(arrow_labels_tb))
  
  try(
    draw_process(
      process_name = obj@name,
      process_desc = obj@desc,
      grouped_com_inputs = grouped_com_inputs,
      single_com_inputs = single_com_inputs,
      aux_inputs = aux_inputs,
      weather_factors = weather_factors,
      grouped_com_outputs = grouped_com_outputs,
      single_com_outputs = single_com_outputs,
      # com_outputs = com_outputs,
      aux_outputs = aux_outputs,
      arrow_labels = arrow_labels,
      cap2act_label = cap2act_label
    )
  )


  # popViewport(0)

} # end of draw.technology

## draw.storage ####


## draw.supply ####


## draw.demand ####


## draw.export ####

#' Draw a schematic representation of an export process
#'
#' @param obj An export object
#' @param ... Additional arguments to be passed to draw_process
#'
#' @method draw export
#' @family draw export
#' @return
#' A figure with a schematic representation of the export process.
#' @export
#' @examples
#'EXPOIL <- newExport(
#'   name = "EXPOIL", # used in sets
#'   desc = "Oil export from the model to RoW", # for own reference
#'   commodity = "OIL", # must match the commodity name in the model
#'   unit = "Mtoe", # for own reference
#'   exp = data.frame(
#'     region = rep(c("R1", "R2"), each = 2), # export region(s)
#'     year = rep(c(2020, 2050)), # export years
#'     price = 500, # export price in MUSD/Mtoe (USD/t),
#'     exp.up = rep(c(1e3, 1e4), each = 2), # upper bound for export in each year
#'     exp.lo = rep(c(5e2, 0), each = 2) # lower bound for export in each year
#'   )
#' )
#' draw(EXPOIL)
draw.export <- function(
    obj,
    ...
) {
  # browser()

  # key columns

  # export parameters
  exp_par <-
    obj@exp |>
    pivot_longer(
      cols = matches("exp|price"),
      names_to = "parameter",
      values_to = "value"
    ) |>
    filter(!is.na(value)) |>
    group_by(parameter) |>
    summarize(
      lab_par = make_label(
        paste0(unique(parameter), ":"),
        in_brackets = value,
        # in_brackets = format_number(value),
        two_lines = F,
        bracket_type = "square"
      ),
      .groups = "drop"
    ) |>
    # mutate(
    #   lab_par = if_else(
    #     is.na(lab_regions),
    #     lab_par,
    #     paste(lab_par, lab_regions, sep = " ")
    #   ),
    #   lab_par = if_else(
    #     is.na(lab_years),
    #     lab_par,
    #     paste(lab_par, lab_years, sep = " ")
    #   )
    # ) |>
    # select(-lab_regions, -lab_years) |>
    mutate(
      iotype = "cinp",
      ioname = obj@commodity,
      group = NA_character_,
    ) |>
    group_by(ioname, iotype, group) |>
    summarize(
      lab_par = paste0(lab_par, collapse = "\n"),
    #   lab_regions = if_else(
    #     all(is.na(region)),
    #     NA_character_,
    #     paste0(
    #       # "{R(", length(unique(obj@exp$region)), "):",
    #       "Regions: {",
    #       shorten_string(
    #         paste0(sort(unique(obj@exp$region)), collapse = ","),
    #         n = 15, add_number = length(unique(obj@exp$region))),
    #       "}")
    #   ),
    #   lab_years = if_else(
    #     all(is.na(year)),
    #     NA_character_,
    #     paste0(
    #       "Years: [",
    #       shorten_string(
    #         paste0(range(obj@exp$year, na.rm = T), collapse = ","),
    #         15),
    #       "]")
    #   ),
      .groups = "drop"
    ) |>
    mutate(
      lab_txt = make_label(
        ioname,
        in_brackets = obj@unit,
        two_lines = F
      ),
      parameter = "exp"
    )
  exp_par


  # arrow_label ####
  arrow_labels <- make_label(
    obj@commodity,
    in_brackets = obj@unit,
    two_lines = F
  )
  names(arrow_labels) <- obj@commodity

  draw_process(
    process_name = obj@name,
    process_desc = obj@desc,
    single_com_inputs = exp_par,
    arrow_labels = arrow_labels,
    show_inputs = TRUE,
    show_outputs = FALSE,
    # show_aux = FALSE,
    show_use_bar = FALSE,
    show_act_bar = FALSE,
    show_iuao_labels = FALSE,
    box_width = 0.2,
    box_height = .4 * 1.5
  )

}

#' @family draw export
#' @method draw export
#' @export
setMethod("draw", "export", draw.export)

## draw.import ####
#' Draw a schematic representation of an import process
#'
#' @param obj An import object
#' @param ... Additional arguments to be passed to draw_process
#'
#' @return
#' A figure with a schematic representation of the import process.
#' @export
#'
#' @examples
#' IMPOIL <- newImport(
#'   name = "IMPOIL", # used in sets
#'   desc = "Oil import to the model to RoW", # for own reference
#'   commodity = "OIL", # must match the commodity name in the model
#'   unit = "Mtoe", # for own reference
#'   imp = data.frame(
#'     region = rep(c("R1", "R2"), each = 2), # import region(s)
#'     year = rep(c(2020, 2050)), # import years
#'     price = 600, # import price in MUSD/Mtoe (USD/t),
#'     imp.up = rep(c(1e4, 1e6), each = 2), # upper bound for import in each year
#'     imp.lo = rep(c(1e4, 1e5), each = 2) # lower bound for import in each year
#'   )
#' )
#' draw(IMPOIL)
draw.import <- function(
    obj,
    ...
) {
  # browser()

  # key columns

  # import parameters
  imp_par <-
    obj@imp |>
    pivot_longer(
      cols = matches("imp|price"),
      names_to = "parameter",
      values_to = "value"
    ) |>
    filter(!is.na(value)) |>
    group_by(parameter) |>
    summarize(
      lab_par = make_label(
        paste0(unique(parameter), ":"),
        in_brackets = value,
        # in_brackets = format_number(value),
        two_lines = F,
        bracket_type = "square"
      ),
      .groups = "drop"
    ) |>
    # mutate(
    #   lab_par = if_else(
    #     is.na(lab_regions),
    #     lab_par,
    #     paste(lab_par, lab_regions, sep = " ")
    #   ),
    #   lab_par = if_else(
    #     is.na(lab_years),
    #     lab_par,
    #     paste(lab_par, lab_years, sep = " ")
    #   )
    # ) |>
    # select(-lab_regions, -lab_years) |>
    mutate(
      iotype = "cout",
      ioname = obj@commodity,
      group = NA_character_,
    ) |>
    group_by(ioname, iotype, group) |>
    summarize(
      lab_par = paste0(lab_par, collapse = "\n"),
      #   lab_regions = if_else(
      #     all(is.na(region)),
      #     NA_character_,
      #     paste0(
      #       # "{R(", length(unique(obj@imp$region)), "):",
      #       "Regions: {",
      #       shorten_string(
      #         paste0(sort(unique(obj@imp$region)), collapse = ","),
      #         n = 15, add_number = length(unique(obj@imp$region))),
      #       "}")
      #   ),
      #   lab_years = if_else(
      #     all(is.na(year)),
      #     NA_character_,
      #     paste0(
      #       "Years: [",
      #       shorten_string(
      #         paste0(range(obj@imp$year, na.rm = T), collapse = ","),
      #         15),
      #       "]")
      #   ),
      .groups = "drop"
    ) |>
    mutate(
      lab_txt = make_label(
        ioname,
        in_brackets = obj@unit,
        two_lines = F
      ),
      parameter = "imp"
    )
  imp_par


  # arrow_label ####
  arrow_labels <- make_label(
    obj@commodity,
    in_brackets = obj@unit,
    two_lines = F
  )
  names(arrow_labels) <- obj@commodity

  draw_process(
    process_name = obj@name,
    process_desc = obj@desc,
    single_com_outputs = imp_par,
    arrow_labels = arrow_labels,
    show_inputs = FALSE,
    show_outputs = TRUE,
    # show_aux = FALSE,
    show_use_bar = FALSE,
    show_act_bar = FALSE,

    box_width = 0.2,
    box_height = 0.2 * 1.5 * 2
  )

}

#' @family draw import
#' @method draw import
#' @export
setMethod("draw", "import", draw.import)


## draw.trade ####


## draw.weather ####


if (F) {
  # Examples ####
  dev.off()
  draw.technology(tech)
  draw(TECH01)
  draw(EXPOIL)

}

#' An internal function to create a character string with a label
#'
#' @param name A character string with the name as the first part of the label
#' @param in_brackets A character string with the content to put in brackets
#' @param make_range A logical value to indicate if the content should be
#' formatted as a range
#' @param two_lines A logical value to indicate if the label should be in
#' two lines
#' @param bracket_type A character string with the type of brackets to use,
#'  one of "round", "square", "curly", "angle", or NULL
#' @noRd
#' @return A character string with the label
make_label <- function(
    name,
    in_brackets = NULL,
    make_range = TRUE,
    two_lines = FALSE,
    bracket_type = "round", # "round", "square", "curly", "angle", or NULL
    comma = ","
) {
  # browser()

  # if (all(is.na(in_brackets))) return(NA)

  if (is.null(bracket_type)) {
    bracket <- c("", "")
  } else {
    bracket <- switch(
      bracket_type,
      "round" = c("(", ")"),
      "square" = c("[", "]"),
      "curly" = c("{", "}"),
      "angle" = c("<", ">")
    )
  }
  in_brackets <- in_brackets[!is.na(in_brackets)]
  if (is_empty(in_brackets)) return("")
  if (is.numeric(in_brackets)) {
    if (length(unique(in_brackets)) > 1) {
      in_brackets <- paste0(bracket[1], min(in_brackets),
                            comma,
                            max(in_brackets), bracket[2]) |>
        # format_number()
        prettyNum(digits = 2, big.mark = "")
    } else {
      in_brackets <- unique(in_brackets)
    }
  } else {
    in_brackets <- unique(in_brackets)
    if (length(in_brackets) > 1) browser()
    # stopifnot(length(in_brackets) == 1)
    if (is.null(in_brackets) || is.na(in_brackets)) {
      in_brackets <- NULL
    } else {
      in_brackets <- paste0(bracket[1], in_brackets, bracket[2])
    }
  }

  if (two_lines) {
    label <- paste0(name, "\n", in_brackets)
  } else {
    label <- paste0(name, " ", in_brackets)
  }
  label
}



#' Drafted function to convert an S4 object to a data frame
#'
#' @param obj An S4 object
#' @param sets A character vector with the names of the sets,
#' colnames to create in the resulting data frame.
#' Default is c("region", "year", "slice", "comm", "acomm")
#' @param verbose A logical value if to print messages
#' @noRd
en_obj2df <- function(obj, sets = NULL, verbose = FALSE) {
  # browser()
  if (!isS4(obj)) {
    stop("Object must be an S4 class")
  }

  if (is.null(sets)) {
    sets <- c("region", "year", "slice", "comm", "acomm")
  }

  # obj <- tech
  slots <- slotNames(obj)

  ll <- list()
  for (s in slots) {

    if (verbose) cat("Processing slot: ", s, "\n")

    if (inherits(slot(obj, s), "data.frame")) {

      ll[[s]] <- slot(obj, s) |>
        pivot_by_type(sets = sets, slot_name = s)

    } else if (inherits(slot(obj, s), c("character", "numeric", "logical"))) {
      ll[[s]] <- data.frame(
        parameter = if (is_empty(slot(obj, s))) NA else slot(obj, s)
      ) |>
        pivot_by_type(sets = sets, slot_name = s)
    } else if (inherits(slot(obj, s), "list")) {
      if (length(slot(obj, s)) > 0) {
        message("Skipping list slot: ", s)
      }
      # ll2 <-
    } else {
      message("Skipping slot: ", s, " of class: ", class(slot(obj, s)))
    }

  }
  ll |> rbindlist(use.names = TRUE, fill = TRUE) |>
    select(matches(c("slot", "parameter", sets)),
           "character_val", "logical_val", "numeric_val", everything()) |>
    # filter(slot != "name") |>
    mutate(
      class = class(obj),
      name = obj@name,
      .before = 1
    )
  # !!! ToDO: add status column (T/F coercion success)
  # !!! ToDO: process list slots (1st level at least)
}

if (F) {
  x <- en_obj2df(TECH01)
}

#' An internal function to pivot a data frame by column type
#'
#' @param x data frame to pivot
#' @param sets character vector with the names of the sets, keys to keep.
#' Default is c("region", "year", "slice", "comm", "acomm")
#' @param slot_name character string with the name of the slot,
#' where the data frame comes from to add to the resulting data frame.
#' @noRd
#' @return A data frame with the pivoted data
pivot_by_type <- function(x, sets = NULL, slot_name = NULL) {
  # browser()
  if (is.null(sets)) {
    sets <- c("region", "year", "slice", "comm", "acomm")
  }

  df <- data.frame()

  # pivot_longer for character columns
  char_df <- x |> select(any_of(sets), where(is.character))
  cond <- any(sapply(select(char_df, -any_of(sets)), is.character))
  if (ncol(char_df) > 0 && cond) {
    char_df <- char_df |>
      pivot_longer(
        cols = -any_of(sets),
        names_to = "parameter",
        values_to = "character_val"
      ) |>
      filter(!is.na(character_val))
    # merge with existing df
    if (nrow(char_df) > 0) {
      if (nrow(df) > 0) {
        df <- full_join(df, char_df, by = intersect(names(df), names(char_df)))
      } else {
        df <- char_df
      }
    }
  } else {
    char_df <- data.frame()
  }

  # pivot_longer for numeric columns
  num_df <- x |> select(any_of(sets), where(is.numeric))
  cond <- any(sapply(select(num_df, -any_of(sets)), is.numeric))
  if (ncol(num_df) > 0 && cond) {
    num_df <- num_df |>
      pivot_longer(
        cols = -any_of(sets),
        names_to = "parameter",
        values_to = "numeric_val"
      ) |>
      filter(!is.na(numeric_val))
    # merge with existing df
    if (nrow(num_df) > 0) {
      if (nrow(df) > 0) {
        df <- full_join(df, num_df, by = intersect(names(df), names(num_df)))
      } else {
        df <- num_df
      }
    }
  } else {
    num_df <- data.frame()
  }

  # pivot_longer for logical columns
  logical_df <- x |> select(any_of(sets), where(is.logical))
  cond <- any(sapply(select(logical_df, -any_of(sets)), is.logical))
  if (ncol(logical_df) > 0 && cond) {
    logical_df <- logical_df |>
      pivot_longer(
        cols = -any_of(sets),
        names_to = "parameter",
        values_to = "logical_val"
      ) |>
      filter(!is.na(logical_val))
    # merge with existing df
    if (nrow(logical_df) > 0) {
      if (nrow(df) > 0) {
        df <- full_join(df, logical_df, by = intersect(names(df), names(logical_df)))
      } else {
        df <- logical_df
      }
    }
  } else {
    logical_df <- data.frame()
  }

  x <- list(char_df, num_df, logical_df) |>
    rbindlist(use.names = TRUE, fill = TRUE)
  if (!is.null(slot_name)) {
    x <- mutate(x, slot = slot_name, .before = 1)
  }
  return(x)
}

if (F) {
  pivot_by_type(tech@ceff)
}

# draw_process ####

#' An internal function to draw a process
#'
#' @param process_name A character string with the name of the process
#' @param process_desc A character string with the description of the process
#' @param grouped_com_inputs A data frame with the grouped commodity inputs' labels
#' @param single_com_inputs A data frame with the single commodity inputs' labels
#' @param aux_inputs A data frame with the auxiliary inputs' labels
#' @param weather_factors A data frame with the weather factors' labels
#' @param grouped_com_outputs A data frame with the grouped commodity outputs' labels
#' @param single_com_outputs A data frame with the single commodity outputs' labels
#' @param arrow_weather_color A character string with the color of the weather arrows
#' @param arrow_labels A named character vector with the labels of the arrows
#' @param cap2act_label A character string with the label of the cap2act arrow
#' @param box_width A numeric value with the width of the process box
#' @param box_height A numeric value with the height of the process box
#' @param box_fill A character string with the fill color of the process box
#' @param box_border A character string with the border color of the process box
#' @param box_lwd A numeric value with the line width of the process box
#' @param process_name_fontsize A numeric value with the font size of the process name
#' @param process_desc_fontsize A numeric value with the font size of the process description
#' @param arrow_comm_color A character string with the color of the commodity arrows
#' @param arrow_aux_color A character string with the color of the auxiliary arrows
#'
#' @noRd
draw_process <- function(
    process_name = "Process",
    process_desc = "Process Description",

    # inputs
    grouped_com_inputs = NULL,
    single_com_inputs = NULL,
    aux_inputs = NULL,
    weather_factors = NULL,
    # ginp2use = NULL,
    # cap2act = NULL,

    # outputs
    grouped_com_outputs = NULL,
    single_com_outputs = NULL,
    # com_outputs = NULL,
    aux_outputs = NULL,

    # labels
    arrow_labels = NULL,
    cap2act_label = NULL,

    show_inputs = any(!is.null(c(grouped_com_inputs, single_com_inputs,
                                 aux_inputs, weather_factors)),
                      na.rm = T),
    show_outputs = any(!is.null(c(grouped_com_outputs, single_com_outputs)),
                       na.rm = T),
    show_use_bar = any(!is.null(c(grouped_com_inputs, single_com_inputs,
                                  aux_inputs, weather_factors)),
                       na.rm = T),
    show_act_bar = any(!is.null(c(grouped_com_outputs, single_com_outputs)),
                       na.rm = T),

    show_iuao_labels = NULL,
    show_all = NULL,

    # draw parameters
    box_width = 0.4,
    box_height = box_width * 1.5,
    arrow_length = 0.175,
    box_fill = rgb(220 / 255, 230 / 255, 242 / 255),
    box_border = "royalblue4",
    box_lwd = 3,

    process_name_fontsize = 14,
    process_desc_fontsize = 10,
    font_spacing = .06,

    arrow_comm_color = "red3",
    arrow_aux_color = "royalblue4",
    arrow_weather_color = "forestgreen"

) {

result <- tryCatch({
  # browser()

  # try(dev.off())

  grid::grid.newpage()
  # Set a viewport
  vp <- grid::viewport(
    width = unit(1, "npc"),
    height = unit(1, "npc"),
    just = "center")
  grid::pushViewport(vp)
  on.exit(grid::popViewport(0))

  font_in_npc <- function(fontsize) {
    # vp_height_in <- grid::convertUnit(unit(1, "npc"), "in", valueOnly = TRUE)
    # fontsize / 72 / vp_height_in * 2
    font_spacing
  }

  spacing_bw_titles <- 0.2 * font_in_npc(
    max(process_name_fontsize, process_desc_fontsize)
  )

  # Process box
  grid::grid.rect(
    x = 0.5, y = 0.5,
    width = box_width,
    height = box_height,
    gp = gpar(fill = box_fill, col = box_border, lty = "solid", lwd = box_lwd)
  )

  # Process description subtitle
  if (!is.null(process_desc) && process_desc != "") {
    txt_x <- 0.5 + box_height / 2 + spacing_bw_titles +
      font_in_npc(process_desc_fontsize)/2
    # txt_x <- 0.5 + box_height / 2 + .05
    grid::grid.text(
      process_desc,
      x = 0.5,
      y = txt_x,
      gp = gpar(fontsize = process_desc_fontsize, just = c("center", "bottom"))
    )
  } else {
    txt_x <- 0.5 + box_height / 2
  }

  # Process label
  grid::grid.text(
    process_name,
    x = 0.5,
    y = txt_x + spacing_bw_titles *
      max(process_name_fontsize, process_desc_fontsize) /
      min(process_name_fontsize, process_desc_fontsize) +
      font_in_npc(process_desc_fontsize) / 2,
    gp = gpar(fontsize = process_name_fontsize)
  )

  # # Process label
  # grid::grid.text(
  #   process_name,
  #   x = 0.5,
  #   y = 0.5 + box_height / 2 +
  #     1.1 * font_in_npc(process_name_fontsize) / 2 +
  #     1.2 * font_in_npc(process_desc_fontsize),
  #   gp = gpar(fontsize = process_name_fontsize)
  # )
  #

  y_inp_use_act <- 0.5 + box_height / 2 - 0.03

  # Inputs ####

  if (show_inputs) {

    # combine all inputs
    inputs <- bind_rows(
      grouped_com_inputs,
      single_com_inputs,
      aux_inputs,
      weather_factors
    )

    # arrow colors
    inputs <- inputs |>
      filter(!is.na(ioname)) |>
      mutate(
        arrow_color = case_when(
          grepl("cinp", iotype) ~ arrow_comm_color,
          grepl("ainp", iotype) ~ arrow_aux_color,
          grepl("winp", iotype) ~ arrow_weather_color
        ),
        order = ifelse(grepl("winp", iotype), 1,
                       ifelse(grepl("ainp", iotype), 2,
                              ifelse(is.na(group), 3, 4)))
      ) |>
      arrange(order, desc(group),  desc(ioname))
    # inputs

    if (is.null(inputs[["label_hjust"]])) inputs$label_hjust <- 0
    if (is.null(inputs[["label_vjust"]])) inputs$label_vjust <- 0
    if (is.null(inputs[["label_font"]])) inputs$label_font <- 6
    if (is.null(inputs[["x"]])) inputs$x <- NA
    if (is.null(inputs[["y"]])) inputs$y <- NA

    n_inputs <- nrow(inputs)
    inp_coords <- list()  # Store coordinates where arrows touch the box

    if (length(n_inputs) > 0) {
      # Add 'inp' label
      grid::grid.text(
        label = "inp",
        x = 0.5 - box_width / 2 + 0.02,
        # y = y_end + 0.02,
        y = y_inp_use_act,
        just = "bottom",
        gp = gpar(fontsize = 8)
      )

      for (i in seq_len(n_inputs)) {

        # x and y position of the input on the process box
        x_pos <- 0.5 - box_width * 0.5
        y_pos <- 0.5 + (i - (n_inputs + 1) / 2) * (box_height / (n_inputs + 1))
        inputs$x[i] <- x_pos
        inputs$y[i] <- y_pos

        # draw arrow i
        grid::grid.lines(
          x = c(0.5 - 0.5 * box_width - arrow_length, x_pos),
          y = c(y_pos, y_pos),
          arrow = arrow(
            type = "closed", angle = 15,
            length = unit(0.15, "inches"),
            ends = "last"
          ),
          gp = gpar(col = inputs$arrow_color[i], lwd = 2)
        )

        # Add label over the arrow
        grid::grid.text(
          arrow_labels[inputs$ioname[i]],
          x = 0.5 - box_width * 0.5 - .03,
          y = y_pos + font_in_npc(10) / 2,
          gp=gpar(fontsize = 10), #, col = "grey"
          just = "right"
        )

        # combustion point
        # grid::grid.points(
        #   x = x_pos,
        #   y = y_pos, pch = 16,
        #   gp = gpar(col = inputs$arrow_color[i], cex = 0.1)
        # )

        # Add label near the dot, inside the box
        grid::grid.text(
          inputs$lab_par[i],
          x = 0.5 - box_width * 0.48 + inputs$label_hjust[i],
          y = y_pos + inputs$label_vjust[i] + .00,
          just = "left",
          gp = gpar(fontsize = inputs$label_font[i])
        )

      } # end for (i in seq_len(n_inputs))

      inp_arrow_spacing <- diff(inputs$y) |> mean(na.rm = T)
      if (is.nan(inp_arrow_spacing) | is.na(inp_arrow_spacing)) {
        inp_arrow_spacing <- 0.1
      }

      # Draw grouping brackets for inputs
      ginp <- inputs |> filter(!is.na(group))

      if (nrow(ginp) > 1) {

        for (g in unique(ginp$group)) {

          ii <- which(ginp$group == g)
          if (length(ii) == 1) {
            warning("Group with only one input", ginp$ioname[ii])
            next
          }

          y1 <- min(ginp$y[ii]) - .4 * inp_arrow_spacing
          y2 <- max(ginp$y[ii]) + .4 * inp_arrow_spacing
          bracket_x <- 0.5 - box_width * 0.23

          # group bracket ####
          grid::grid.lines(
            x = c(bracket_x,
                  bracket_x),
            y = c(y1, y2),
            gp = gpar(lwd = 1.25, col = "red3")
          )

          grid::grid.lines(
            x = c(bracket_x - box_width * 0.02,
                  bracket_x),
            y = c(y1, y1),
            gp = gpar(lwd = 1.25, col = "red3")
          )
          grid::grid.lines(
            x = c(bracket_x - box_width * 0.02,
                  bracket_x),
            y = c(y2, y2),
            gp = gpar(lwd = 1.25, col = "red3")
          )

          # group circle ####
          circle_y <- (y1 + y2) / 2
          circle_x <- bracket_x
          grid::grid.circle(
            x = circle_x, y = circle_y, r = unit(0.07, "inches"),
            gp = gpar(fill = "white", col = "red3", lwd = 1.0)
          )
          # group number ####
          grid::grid.text(
            label = g,
            x = circle_x,
            y = circle_y,
            gp = gpar(fontsize = 8)
          )

          # ginp2use ####
          # stop()
          ginp2use <- grouped_com_inputs |>
            filter(group == g, parameter == "ginp2use")
          if (nrow(ginp2use) == 1) {
            grid::grid.text(
              label = ginp2use$lab_par,
              x = circle_x + 0.048,
              y = circle_y,
              just = "center",
              gp = gpar(fontsize = 6)
            )
          } else if (nrow(ginp2use) > 1) {
            stop("More than one ginp2use labels for group", g)
          }

        } # end for (g in unique(ginp$group))
        # Add 'ginp' label
        grid::grid.text(
          label = "ginp",
          x = bracket_x,
          # y = y_end + 0.02,
          y = y_inp_use_act,
          just = "bottom",
          gp = gpar(fontsize = 8)
        )

      } # end of groups

      ## "use" bracket #####
      if (show_use_bar){
        cinp <- inputs |> filter(grepl("cinp", iotype))
        y_use <- range(cinp$y, na.rm = T) + 0.4 * inp_arrow_spacing * c(-1, 1)

        use_x <- 0.5 - box_width * 0.00
        grid::grid.lines(
          x = c(use_x, use_x),
          y = y_use,
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )
        grid::grid.lines(
          x = c(use_x - box_width * 0.02, use_x),
          y = c(y_use[1], y_use[1]),
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )
        grid::grid.lines(
          x = c(use_x - box_width * 0.02, use_x),
          y = c(y_use[2], y_use[2]),
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )

        ## "use" label ####
        grid::grid.text(
          label = "use",
          x = use_x,
          y = y_inp_use_act,
          just = "bottom",
          gp = gpar(fontsize = 8)
        )
      }

    } # end of (length(n_inputs) > 0)
  } # end of show_inputs

  # Outputs ####
  if (show_outputs) {
    # browser()
    # combine all outputs
    outputs <- bind_rows(
      grouped_com_outputs,
      single_com_outputs,
      aux_outputs
    )

    # arrow colors
    outputs <- outputs |>
      filter(!is.na(ioname)) |>
      mutate(
        arrow_color = case_when(
          grepl("cout", iotype) ~ arrow_comm_color,
          grepl("aout", iotype) ~ arrow_aux_color
        ),
        order = ifelse(grepl("aout", iotype), 1,
                       if_else(is.na(group), 2, 3))
      ) |>
      arrange(order, desc(group), desc(ioname))

    if (is.null(outputs[["label_hjust"]])) outputs$label_hjust <- 0
    if (is.null(outputs[["label_vjust"]])) outputs$label_vjust <- 0
    if (is.null(outputs[["label_font"]])) outputs$label_font <- 6
    if (is.null(outputs[["x"]])) outputs$x <- NA
    if (is.null(outputs[["y"]])) outputs$y <- NA

    out_coms <- outputs$ioname |> unique()
    out_pars <- outputs |>
      filter(grepl("out", parameter) |
               (is.na(group) & grepl("cinp2use|use2cact|imp", parameter)))
    n_outputs <- length(out_coms)

    # browser()

    if (length(n_outputs) > 0) {
      stopifnot(n_outputs == length(unique(out_pars$ioname)))

      if (show_act_bar) {
        # Add 'out' label
        grid::grid.text(
          label = "out",
          x = 0.5 + box_width / 2 - 0.02,
          y = y_inp_use_act,
          just = "bottom",
          gp = gpar(fontsize = 8)
        )

        # add 'act' label
        grid::grid.text(
          label = "act",
          x = 0.5 + box_width * 0.22,
          y = y_inp_use_act,
          just = "bottom",
          gp = gpar(fontsize = 8)
        )
      }

      for (i in 1:nrow(out_pars)) {

        ii <- which(outputs$ioname == out_coms[i]) # can be several parameters

        # x and y position of the output on the process box
        x_pos <- 0.5 + box_width * 0.5
        y_pos <- 0.5 + (i - (n_outputs + 1) / 2) * (box_height / (n_outputs + 1))
        outputs$x[ii] <- x_pos
        outputs$y[ii] <- y_pos

        # draw arrow o
        # browser()
        grid::grid.lines(
          x = c(x_pos, 0.5 + 0.5 * box_width + arrow_length),
          y = c(y_pos, y_pos),
          arrow = arrow(
            type = "closed", angle = 15,
            length = unit(0.15, "inches"),
            ends = "last"
          ),
          gp = gpar(col = out_pars$arrow_color[i], lwd = 2)
        )

        # Add label over the arrow
        grid::grid.text(
          arrow_labels[out_pars$ioname[i]],
          x = 0.5 + box_width * 0.5 + .02,
          y = y_pos + font_in_npc(10) / 2,
          gp=gpar(fontsize = 10), #, col = "grey"
          just = "left"
        )

        # Add label near the dot, inside the box
        grid::grid.text(
          out_pars$lab_par[i],
          x = 0.5 + box_width * 0.48 + out_pars$label_hjust[i],
          y = y_pos + out_pars$label_vjust[i] + .00,
          just = "right",
          gp = gpar(fontsize = out_pars$label_font[i])
        )

      } # end for (i in seq_len(n_outputs))

      out_arrow_spacing <- diff(unique(outputs$y)) |> mean(na.rm = T)

      # Draw grouping brackets for outputs
      gout <- outputs |>
        filter(!is.na(group)) |>
        select(group, ioname, y, lab_txt, x, y)

      if (nrow(gout) > 1) {

        for (g in unique(gout$group)) {

          ii <- which(gout$group == g)
          if (length(ii) == 1) {
            warning("Group with only one output", gout$ioname[ii])
            next
          }

          y1 <- min(gout$y[ii], na.rm = T) - .4 * out_arrow_spacing
          y2 <- max(gout$y[ii], na.rm = T) + .4 * out_arrow_spacing
          bracket_x <- 0.5 + box_width * 0.25

          # group bracket ####
          grid::grid.lines(
            x = c(bracket_x,
                  bracket_x),
            y = c(y1, y2),
            gp = gpar(lwd = 1.25, col = "red3")
          )

          grid::grid.lines(
            x = c(bracket_x + box_width * 0.02,
                  bracket_x),
            y = c(y1, y1),
            gp = gpar(lwd = 1.25, col = "red3")
          )
          grid::grid.lines(
            x = c(bracket_x + box_width * 0.02,
                  bracket_x),
            y = c(y2, y2),
            gp = gpar(lwd = 1.25, col = "red3")
          )

          # group circle ####
          circle_y <- (y1 + y2) / 2
          circle_x <- bracket_x
          grid::grid.circle(
            x = circle_x, y = circle_y, r = unit(0.07, "inches"),
            gp = gpar(fill = "white", col = "red3", lwd = 1.0)
          )
          # group number ####
          grid::grid.text(
            label = g,
            x = circle_x,
            y = circle_y,
            gp = gpar(fontsize = 8)
          )
        }
      } # end of groups

      ## "act" bracket ####
      if (show_act_bar) {
        cout <- outputs |>
          filter(grepl("cout", iotype))
        y_act <- range(cout$y, na.rm = T) + 0.42 * out_arrow_spacing * c(-1, 1)
        act_x <- 0.5 + box_width * 0.2

        grid::grid.lines(
          x = c(act_x, act_x),
          y = y_act,
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )
        grid::grid.lines(
          x = c(act_x + box_width * 0.02, act_x),
          y = c(y_act[1], y_act[1]),
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )
        grid::grid.lines(
          x = c(act_x + box_width * 0.02, act_x),
          y = c(y_act[2], y_act[2]),
          gp = gpar(lwd = 1.25, col = "red3", lty = "solid")
        )
      } # end of show_act_bar

      ## use2cact labels ####
      # browser()
      if (show_act_bar && show_use_bar &&
          any(grepl("use2cact", outputs$parameter))) {

        use2cact <- outputs |>
          filter(grepl("use2cact", parameter)) |>
          filter(!is.na(group))

        use2cact_x <- (act_x + use_x) / 2

        if (nrow(use2cact) > 0) {
          for (com in unique(use2cact$ioname)) {
            ii <- which(use2cact$ioname == com)

            grid::grid.text(
              label = use2cact$lab_par[ii],
              x = use2cact_x,
              y = use2cact$y[ii],
              just = "center",
              gp = gpar(fontsize = 6)
            )
          } # end of for loop
        } # end of (nrow(use2cact) > 0)
      } # end of show_act_bar && show_use_bar
    } # end of (length(n_outputs) > 0)
  } # end of show_outputs

  # cap2act ####
  if (!is.null(cap2act_label)) {
    grid::grid.text(
      label = cap2act_label,
      x = 0.5,
      y = 0.5 - box_height / 2 + 0.05,
      just = "center",
      gp = gpar(fontsize = 6)
    )

  } # end of cap2act

  # popViewport()

  return(invisible(TRUE))
}, error = function(e) {
  message("Error in draw_process: ", e)
  try(popViewport(0), silent = T)
  return(invisible(FALSE))
})
}# end of draw_process

# # dev.off()
# if (F) {
#   "#DCE6F2"
#   "#F0FFF0"
#   "#E6E6FA"
#   "#F0F8FF"
#   "#228B22"
#   "#FFD700"
#   "#556B2F" # Dark Olive Green
#   "#6B8E23"
#   "#808000"
#   "#556B2F"
#   "#B8860B" # Dark Goldenrod
#   "#DAA520"
#   "#708090"
#   "#2F4F4F"
#   "#FF6347"
#   "#FF4500"
#   "#FFA07A"
#   "#FFA500"
#   "#FFD700"
#   "#FF8C00"
# }



# Function to shorten a string
shorten_string <- function(string, n, add_number = NULL) {
  if (nchar(string) > n) {
    # Subtract 2 from n to account for the ".."
    shortened <- substr(string, 1, n)
    if (nchar(string) > n) {
      if (!is.null(add_number)) {
        shortened <- paste0(shortened, "..(", add_number, ")")
      } else {
        shortened <- paste0(shortened, "..")
      }
    }
    return(shortened)
  } else {
    return(string)
  }
}

format_number <- function(x) {
  # browser()
  # if (length(x) > 1) {
  #   return(sapply(x, format_number))
  # }
  # Use scientific notation if the number is larger than 100 or smaller than 0.01 (positive or negative)
  if (any(abs(x) > 100) || any(abs(x) < 0.01)) {
    return(prettyNum(format(x, scientific = TRUE), big.mark = ","))
  } else {
    return(prettyNum(format(x, nsmall = 2), big.mark = ","))
  }
}

# Example usage
# numbers <- c(45.678, 12345.678, -12345.678, 0.1234, 0.009, -0.008, 1e8)

# sapply(numbers, format_number)
# print(formatted_numbers)
