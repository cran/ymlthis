## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  message = FALSE,
  collapse = TRUE,
  comment = "", 
  warning = FALSE
)

## ----pandoc_check, echo=FALSE-------------------------------------------------
if (!rmarkdown::pandoc_available()) {
  cat("pandoc is required to use ymlthis. Please visit https://pandoc.org/ for more information.")
  knitr::knit_exit()
}

## ----roxygen_check, echo=FALSE------------------------------------------------
if (!requireNamespace("roxygen2")) {
  cat("roxygen2 is required to render this vignette: `install.packages('roxygen2'`")
  knitr::knit_exit()
}

## ----setup--------------------------------------------------------------------
library(ymlthis)
oldoption <- options(devtools.name = "Malcolm Barrett")

function_name <- function(x) {
  function_call <- x$call
  ifelse(rlang::has_length(function_call), as.character(function_call[[2]]), NA)
}

block_names <- function(x) x$tags %>% purrr::map_chr(~.x$tag)

get_doc_name <- function(x) {
  tags <- block_names(x)
  rdname_index <- which(tags == "rdname")
  if (purrr::is_empty(rdname_index)) return(function_name(x))
  
  x$tags[[rdname_index]]$val
}

get_params <- function(x) {
  param_lists <- which(block_names(x) == "param")
  f <- get_doc_name(x)
  if (!rlang::has_length(param_lists) || is.na(f)) return(data.frame())
  
  params_desc <- x$tags[param_lists] %>% 
    purrr::map(~as.data.frame(.x$val, stringsAsFactors = FALSE)) %>% 
     do.call(rbind, .)
  
  params_desc$description <- stringr::str_replace_all(
    params_desc$description, 
    "\n", 
    " "
  )
  
  params_desc$name <- params_desc$name %>% 
    stringr::str_split(",") %>% 
    purrr::map_chr(
      ~paste0("`", .x, "`") %>% paste(collapse = ", ")
    )
  
  cbind(func = f, params_desc, stringsAsFactors = FALSE)
}

link_help_page <- function(x) {
  url <- "https://ymlthis.r-lib.org/"
  glue::glue("<a href='{url}/reference/{x}.html'>{x}</a>")
} 

filter_kable <- function(.tbl, .pattern = NULL, caption = NULL) {
  if (!is.null(.pattern)) {
    index <- stringr::str_detect(.tbl$func, .pattern)
    .tbl <- .tbl[index, ]
  }
  .tbl$func <- link_help_page(.tbl$func)
  
  knitr::kable(
    .tbl, 
    col.names = c("Help Page", "Argument", "Description"), 
    row.names = FALSE, 
    caption = caption
  )
}

fields_df <- roxygen2::parse_package("../") %>% 
  purrr::map(get_params) %>% 
  do.call(rbind, .)

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_author|yml_runtime|yml_clean|yml_toc", caption = "Basic YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("latex", caption = "LaTeX/PDF Options")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("site|navbar|vignette", caption = "R Markdown Websites")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("citations", caption = "Citations")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_blogdown_opts", caption = "blogdown YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("bookdown", caption = "bookdown YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_pkgdown", caption = "pkgdown YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("pagedown", caption = "pagedown YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("distill", caption = "distill YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("rticles", caption = "rticles YAML")

## -----------------------------------------------------------------------------
fields_df %>% 
  filter_kable("rsconnect", caption = "RStudio Connect Scheduled Email YAML")

## ---- include=FALSE-----------------------------------------------------------
options(oldoption)

