## ----setup, echo=FALSE--------------------------------------------------------
library(ymlthis)
oldoption <- options(devtools.name = "Malcolm Barrett")
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

check <- function() "<span style='color:green'>\u2713</span>"
cross <- function() "<span style='color:red'>\u2717</span>"
knit_print.yml <- function(x, ...) {
  ymlthis::asis_yaml_output(x)
}

## ----pandoc_check, echo=FALSE-------------------------------------------------
if (!rmarkdown::pandoc_available()) {
  cat("pandoc is required to use ymlthis. Please visit https://pandoc.org/ for more information.")
  knitr::knit_exit()
}

## -----------------------------------------------------------------------------
yml()

## -----------------------------------------------------------------------------
yml() %>% 
  yml_title("An introduction to ymlthis")

## -----------------------------------------------------------------------------
yml() %>% 
  yml_output(pdf_document())

## -----------------------------------------------------------------------------
yml() %>% 
  yml_output(pdf_document(toc = TRUE))

## -----------------------------------------------------------------------------
yml() %>% 
  yml_output(
    pdf_document(toc = TRUE),
    html_document()
  )

## -----------------------------------------------------------------------------
yml() %>%
  yml_author(
    c("Yihui Xie", "Hadley Wickham"),
    affiliation = "RStudio"
  ) %>%
  yml_date("07/04/2019") %>%
  yml_title("Reproducible Research in R") %>% 
  yml_category(c("r", "reprodicibility")) %>% 
  yml_output(
    pdf_document(
      keep_tex = TRUE,
      includes = includes2(after_body = "footer.tex")
    )
  ) %>%
  yml_latex_opts(biblio_style = "apalike")

## -----------------------------------------------------------------------------
yml() %>% 
  yml_params(country = "Turkey")

## -----------------------------------------------------------------------------
yml() %>%
  yml_params(
    data = shiny_file("Upload Data (.csv)"),
    n = shiny_numeric("n to sample", 10),
    date = shiny_date("Date"),
    show_plot = shiny_checkbox("Plot the data?", TRUE)
  )

## -----------------------------------------------------------------------------
yml() %>% 
  yml_citations(bibliography = "refs.bib")

## -----------------------------------------------------------------------------
ref <- reference(
  id = "fenner2012a",
  title = "One-click science marketing",
  author = list(
    family = "Fenner",
    given = "Martin"
  ),
  `container-title` = "Nature Materials",
  volume = 11L,
  URL = "http://dx.doi.org/10.1038/nmat3283",
  DOI = "10.1038/nmat3283",
  issue = 4L,
  publisher = "Nature Publishing Group",
  page = "261-263",
  type = "article-journal",
  issued = list(
    year = 2012,
    month = 3
  )
)

yml() %>%
  yml_reference(ref)

## -----------------------------------------------------------------------------
yml() %>%
  yml_reference(.bibentry = citation("purrr"))

## -----------------------------------------------------------------------------
yml() %>% 
  yml_title("Presentation Ninja") %>% 
  yml_subtitle("with xaringan") %>% 
  yml_output(
    xaringan::moon_reader(
      lib_dir = "libs",
      nature = list(
        highlightStyle = "github",
        highlightLines = TRUE,
        countIncrementalSlides = FALSE
      )
    )
  )

## -----------------------------------------------------------------------------
navbar_yaml <- yml_empty() %>%
  yml_site_opts(
    name = "my-website",
    output_dir =  "_site",
    include = "demo.R",
    exclude = c("docs.txt", "*.csv")
  ) %>%
  yml_navbar(
    title = "My Website",
    left = list(
      navbar_page("Home", href = "index.html"),
      navbar_page(navbar_separator(), href = "about.html")
    )
  ) %>%
  yml_output(html_document(toc = TRUE, highlight = "textmate"))

# save to temporary directory since this is not interactive
path <- tempfile()
fs::dir_create(path)

use_navbar_yml(navbar_yaml, path = path)

## -----------------------------------------------------------------------------
old <- options(
  ymlthis.default_yml = "author: Malcolm Barrett
date: '`r format(Sys.Date())`'
output: bookdown::pdf_document2",
  ymlthis.rmd_body = c(
    "",
    ymlthis::setup_chunk(),
    "",
    ymlthis::code_chunk(
      library(ymlthis)
    )
  )
)

#  use temporary path set above
use_rmarkdown(path = file.path(path, "analysis.Rmd"))

# reset previous option defaults
options(old)

## -----------------------------------------------------------------------------
x <- 
  yml() %>%
  yml_author(
    c("Yihui Xie", "Hadley Wickham"),
    affiliation = "RStudio"
  ) %>%
  yml_date("07/04/2019") %>%
  yml_title("Reproducible Research in R") %>% 
  yml_category(c("r", "reprodicibility")) %>% 
  yml_output(
    pdf_document(
      keep_tex = TRUE,
      includes = includes2(after_body = "footer.tex")
    ),
    html_document()
  ) %>%
  yml_latex_opts(biblio_style = "apalike")

## ----echo=FALSE---------------------------------------------------------------
x %>% ymlthis::asis_yaml_output()

## -----------------------------------------------------------------------------
x %>% 
  yml_discard("category")

## -----------------------------------------------------------------------------
x %>% 
  yml_discard(~ length(.x) > 1)

## -----------------------------------------------------------------------------
x %>% 
  yml_pluck("output", "pdf_document")

## ---- include=FALSE-----------------------------------------------------------
options(oldoption)

