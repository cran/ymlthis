## ---- include = FALSE----------------------------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  message = FALSE,
  collapse = TRUE,
  comment = ""
)

## ----pandoc_check, echo=FALSE--------------------------------------------
if (!rmarkdown::pandoc_available()) {
  cat("pandoc is required to use ymlthis. Please visit https://pandoc.org/ for more information.")
  knitr::knit_exit()
}

## ----roxygen_check, echo=FALSE-------------------------------------------
if (!requireNamespace("roxygen2")) {
  cat("roxygen2 is required to render this vignette: `install.packages('roxygen2'`")
  knitr::knit_exit()
}

## ----setup---------------------------------------------------------------
library(ymlthis)
oldoption <- options(devtools.name = "Malcolm Barrett")

function_name <- function(x) {
  function_call <- as.character(attr(x, "call"))
  ifelse(rlang::has_length(function_call), function_call[[2]], NA)
}

get_doc_name <- function(x) {
  doc_name <- x[["rdname"]]
  if (is.null(doc_name)) doc_name <- function_name(x)
  doc_name
}

get_params <- function(x) {
  param_lists <- which(names(x) == "param")
  f <- get_doc_name(x)
  if (!rlang::has_length(param_lists) || is.na(f)) return(data.frame())
  
  params_desc <- x[param_lists] %>% 
    purrr::map(as.data.frame, stringsAsFactors = FALSE) %>% 
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
  glue::glue("<a href='https://r-lib.github.io/ymlthis/reference/{x}.html'>{x}</a>")
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

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_author|yml_runtime|yml_clean|yml_toc", caption = "Basic YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("latex", caption = "LaTeX/PDF Options")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("site|navbar|vignette", caption = "R Markdown Websites")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("citations", caption = "Citations")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_blogdown_opts", caption = "blogdown YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("bookdown", caption = "bookdown YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("yml_pkgdown", caption = "pkgdown YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("pagedown", caption = "pagedown YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("distill", caption = "distill YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("rticles", caption = "rticles YAML")

## ------------------------------------------------------------------------
fields_df %>% 
  filter_kable("rsconnect", caption = "RStudio Connect Scheduled Email YAML")

## ---- include=FALSE------------------------------------------------------
options(oldoption)

