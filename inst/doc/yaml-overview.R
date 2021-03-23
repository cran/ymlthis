## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  echo = FALSE,
  message = FALSE,
  collapse = TRUE,
  comment = "", 
  warning = FALSE
)

## ----setup--------------------------------------------------------------------
library(ymlthis)
oldoption <- options(devtools.name = "Malcolm Barrett")

## ----pandoc_check, echo=FALSE-------------------------------------------------
if (!rmarkdown::pandoc_available()) {
  cat("pandoc is required to use ymlthis. Please visit https://pandoc.org/ for more information.")
  knitr::knit_exit()
}

## -----------------------------------------------------------------------------
yml(date = FALSE) %>% 
  asis_yaml_output()

## ---- warning = FALSE---------------------------------------------------------
yml_empty() %>% 
  yml_output(pdf_document(toc = TRUE)) %>% 
  asis_yaml_output()

## ---- warning = FALSE---------------------------------------------------------
yml_empty() %>% 
  yml_output(pdf_document(toc = TRUE)) %>% 
  draw_yml_tree()

## -----------------------------------------------------------------------------
list(output = list(pdf_document = NULL), toc = TRUE) %>% 
  as_yml() %>% 
  draw_yml_tree()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_output(html_document()) %>% 
  asis_yaml_output()

## ---- warning = FALSE---------------------------------------------------------
yml_empty() %>% 
  yml_output(html_document(), pdf_document(toc = TRUE)) %>% 
  asis_yaml_output()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_category(c("R", "Reprodicible Research")) %>% 
  asis_yaml_output()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_params(
    list(a = 1, input = "numeric"), 
    list(data = "data.csv", input = "text")
  ) %>% 
  asis_yaml_output()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_params(
    list(a = 1, input = "numeric"), 
    list(data = "data.csv", input = "text")
  ) %>% 
  draw_yml_tree()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_title("R Markdown: An Introduction") %>% 
  asis_yaml_output()

## -----------------------------------------------------------------------------
yml_empty() %>% 
  yml_params(x = "yes") %>% 
  asis_yaml_output()

## ---- include=FALSE-----------------------------------------------------------
options(oldoption)

