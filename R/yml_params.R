#' Parameterize an R Markdown report using Shiny components
#'
#' R Markdown lets you add dynamic parameters to your report using the `params`
#' YAML field (see the [R Markdown
#' book](https://bookdown.org/yihui/rmarkdown/parameterized-reports.html) for
#' examples); parameterized reports are also used in RStudio Connect. The values
#' of these variables can be called inside your R Markdown document using
#' `params$field_name`. [There are several ways to change the values of the
#' parameters](https://bookdown.org/yihui/rmarkdown/params-knit.html): manually
#' change the YAML, use the `params` argument in `rmarkdown::render()`, or knit
#' with parameters, which launches a Shiny app to select values for each.
#' `yml_params()` accepts any number of named R objects to set as YAML fields.
#' You can also pass arguments to the underlying Shiny functions using YAML. To
#' set a shiny component, use the `shiny_*()` helper functions. `shiny_params()`
#' captures a Shiny output function and transforms it to YAML. However, R
#' Markdown supports only a limited number of components; each of these is
#' included as a function starting with `shiny_*()`, e.g. `shiny_checkbox()`
#'
#' @template describe_yml_param
#' @param .shiny a Shiny function call to capture and convert to YAML
#' @param width	The width of the input, e.g. '400px', or '100%'; see
#'   [shiny::validateCssUnit()]
#' @template describe_dots_param
#' @template describe_yml_output
#' @export
#'
#' @examples
#'
#' yml() %>%
#'   yml_params(
#'     z = "z",
#'     x = shiny_numeric("Starting value", 23),
#'     no = shiny_checkbox("No option?"),
#'     y = shiny_slider("Data range", 0, 1, .5, round = TRUE)
#'   )
#'
#' @family R Markdown
#' @family shiny
#' @seealso [`yml_params_code()`]
yml_params <- function(.yml, ...) {
  warn_if_duplicate_fields(.yml, list(params = ""))
  .yml$params <- list(...)

  .yml
}

#' @export
#' @rdname yml_params
shiny_params <- function(.shiny) {
  x <- rlang::enquo(.shiny)
  args <- rlang::call_args(x)
  arg_names <- names(args)
  args <- purrr::map(args, rlang::eval_tidy)
  names(args) <- arg_names

  function_name <- rlang::call_name(x)
  function_namspace <- rlang::call_ns(x)
  function_name <- ifelse(
    !is.null(function_namspace),
    paste0(function_namspace, "::", function_name),
    function_name
  )

  validate_shiny_yml(function_name, args)

  parse_shiny_yml(args, switch_shiny_param(function_name))
}

switch_shiny_param <- function(x) {
  switch(
    x,
    checkboxInput = "checkbox",
    numericInput = "numeric",
    sliderInput = "slider",
    dateInput = "date",
    textInput = "text",
    fileInput = "file",
    radioButtons = "radio",
    selectInput = "select",
    passwordInput = "password",
    "shiny::checkboxInput" = "checkbox",
    "shiny::numericInput" = "numeric",
    "shiny::sliderInput" = "slider",
    "shiny::dateInput" = "date",
    "shiny::textInput" = "text",
    "shiny::fileInput" = "file",
    "shiny::radioButtons" = "radio",
    "shiny::selectInput" = "select",
    "shiny::passwordInput" = "password"
  )
}

parse_shiny_yml <- function(args, function_name) {
  yml_list <- purrr::map_if(args, rlang::is_call, rlang::eval_tidy)
  input_type <- list(input = function_name)
  yml_list <- c(input_type, yml_list)

  #  drop `inputId` argument if needed
  .keep <- names(yml_list) != "inputId"
  yml_list[.keep]
}

stop_yml_eval_shiny <- function(e, x) {
  stop(
    "Invalid argument in YAML Shiny parameter function ",
    paste0(x, "()"),
    "\n",
    as.character(e),
    call. = FALSE
  )
}

eval_tidy_shiny_yml <- function(.function_call, .function_name) {
  out <- rlang::catch_cnd(
    .function_call()
  )

  if (!is.null(out)) stop_yml_eval_shiny(out, .function_name)

  out
}

validate_shiny_yml <- function(.function_name, .args) {
  stop_if_not_shiny_param(.function_name)

  #  parse & evaluate string "pkg::func" to retrieve actual function object
  .f <- rlang::parse_expr(.function_name) %>%
    rlang::eval_tidy()

  #  create a call using `purrr::partial` to set arguments
  .function_call <- purrr::partial(
    .f,
    inputId = "inputId",
    !!!.args
  )
  .function_call <- eval_tidy_shiny_yml(.function_call, .function_name)
  invisible(.function_call)
}

stop_if_not_shiny_param <- function(.function_name) {
  valid_fs <- c(
    "checkboxInput",
    "numericInput",
    "sliderInput",
    "dateInput",
    "textInput",
    "fileInput",
    "radioButtons",
    "selectInput",
    "passwordInput"
  )

  valid_functions <- c(valid_fs, paste0("shiny::", valid_fs))

  if (!(.function_name %in% valid_functions)) {
    valid_functions <- valid_fs %>%
      paste0("()") %>%
      glue::glue_collapse(sep = ", ", last = ", or ")

    stop(
      "Invalid Shiny function ",
      .function_name,
      "\n",
      "Must be one of: ",
      valid_functions,
      call. = FALSE
    )
  }

  invisible(.function_name)
}


#' @inheritParams shiny::checkboxInput
#' @export
#' @rdname yml_params
shiny_checkbox <- function(label, value = FALSE, width = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::checkboxInput(inputId = "id", label = !!label, value = !!value, width = !!width)
  )

  remove_default_values(param_list, shiny::checkboxInput)
}


#' @inheritParams shiny::numericInput
#' @export
#' @rdname yml_params
shiny_numeric <- function(label, value, min = NA, max = NA, step = NA,  width = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::numericInput(
      inputId = "id",
      label = !!label,
      value = !!value,
      min = !!min,
      max = !!max,
      step = !!step,
      width = !!width
    )
  )

  remove_default_values(param_list, shiny::numericInput)
}

#' @inheritParams shiny::sliderInput
#' @param animate `TRUE` to show simple animation controls with default
#'   settings; `FALSE` not to; or a custom settings list, such as those created
#'   using [shiny::animationOptions()]
#' @export
#' @rdname yml_params
shiny_slider <- function(label, min, max, value, step = NULL,
                         round = FALSE, format = NULL, ticks = TRUE,
                         animate = FALSE, width = NULL, sep = ",", pre = NULL,
                         post = NULL, timeFormat = NULL, timezone = NULL,
                         dragRange = TRUE) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::sliderInput(
      inputId = "id",
      label = !!label,
      min = !!min,
      max = !!max,
      value = !!value,
      step = !!step,
      round = !!round,
      ticks = !!ticks,
      animate = !!animate,
      width = !!width,
      sep = !!sep,
      pre = !!pre,
      post = !!post,
      timeFormat = !!timeFormat,
      timezone = !!timezone,
      dragRange = !!dragRange
    )
  )

  remove_default_values(param_list, shiny::sliderInput)
}

#' @inheritParams shiny::dateInput
#' @export
#' @rdname yml_params
shiny_date <- function(label, value = NULL, min = NULL, max = NULL,
                       format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                       language = "en", width = NULL, autoclose = TRUE,
                       datesdisabled = NULL, daysofweekdisabled = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::dateInput(
      inputId = "id",
      label = !!label,
      value = !!value,
      min = !!min,
      max = !!max,
      format = !!format,
      startview = !!startview,
      weekstart = !!weekstart,
      language = !!language,
      width = !!width,
      autoclose = !!autoclose,
      datesdisabled = !!datesdisabled,
      daysofweekdisabled = !!daysofweekdisabled
    )
  )

  remove_default_values(param_list, shiny::dateInput)
}

#' @inheritParams shiny::textInput
#' @export
#' @rdname yml_params
shiny_text <- function(label, value = "", width = NULL, placeholder = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::textInput(
      inputId = "id",
      label = !!label,
      value = !!value,
      width = !!width,
      placeholder = !!placeholder
    )
  )

  remove_default_values(param_list, shiny::textInput)
}

#' @inheritParams shiny::fileInput
#' @export
#' @rdname yml_params
shiny_file <- function(label, multiple = FALSE, accept = NULL, width = NULL,
                       buttonLabel = "Browse...",  placeholder = "No file selected") {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::fileInput(
      inputId = "id",
      label = !!label,
      multiple = !!multiple,
      accept = !!accept,
      width = !!width,
      buttonLabel = !!buttonLabel,
      placeholder = !!placeholder
    )
  )

  remove_default_values(param_list, shiny::fileInput)
}

#' @inheritParams shiny::radioButtons
#' @export
#' @rdname yml_params
shiny_radio <- function(label, choices = NULL, selected = NULL,  inline = FALSE,
                        width = NULL, choiceNames = NULL, choiceValues = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::radioButtons(
      inputId = "id",
      label = !!label,
      choices = !!choices,
      selected = !!selected,
      inline = !!inline,
      width = !!width,
      choiceNames = !!choiceNames,
      choiceValues = !!choiceValues
    )
  )

  remove_default_values(param_list, shiny::radioButtons)
}

#' @inheritParams shiny::selectInput
#' @export
#' @rdname yml_params
shiny_select <- function(label, choices, selected = NULL, multiple = FALSE,
                         selectize = TRUE, width = NULL, size = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::selectInput(
      inputId = "id",
      label = !!label,
      choices = !!choices,
      selected = !!selected,
      multiple = !!multiple,
      selectize = !!selectize,
      width = !!width,
      size = !!size
    )
  )

  remove_default_values(param_list, shiny::selectInput)
}

#' @inheritParams shiny::passwordInput
#' @export
#' @rdname yml_params
shiny_password <- function(label, value = "", width = NULL, placeholder = NULL) {
  stop_if_shiny_not_installed()

  param_list <- shiny_params(
    shiny::passwordInput(
      inputId = "id",
      label = !!label,
      value = !!value,
      width = !!width,
      placeholder = !!placeholder
    )
  )

  remove_default_values(param_list, shiny::passwordInput)
}

remove_default_values <- function(args, .f) {
  fmls <- as.list(formals(.f))

  # The first argument (input/inputId) is required, so always include it
  result <- args[1]

  for (nm in names(args)[-1]) {
    if (!nm %in% names(fmls)) {
      stop(
        "The following arguments don't exist in the function that they're",
        " trying to be used in: ", nm,
        call. = FALSE
      )
    }
    if (!identical(args[nm], fmls[nm])) {
      result <- c(result, args[nm])
    }
  }

  result
}
