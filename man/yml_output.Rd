% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yml_output.R
\name{yml_output}
\alias{yml_output}
\title{Capture, validate, and write output YAML}
\usage{
yml_output(.yml, ...)
}
\arguments{
\item{.yml}{a \code{yml} object created by \code{yml()}, \code{as_yml()}, or returned by
a \verb{yml_*()} function}

\item{...}{valid R code calling functions that return objects of class
\code{rmarkdown_output_format}, such as the \verb{*_document()} functions in
rmarkdown.}
}
\value{
a \code{yml} object
}
\description{
\code{yml_output()} writes valid YAML for the \code{output} field of R Markdown YAML.
\code{yml_output()} captures the actual output functions, such as
\code{pdf_document()}, and translates them to YAML. This function accepts multiple
output formats (separated by commas) and validates each by evaluating the
function internally. The YAML fields in under \code{output} come from arguments in
their respective R functions. If you wanted to see the available fields in
\code{pdf_document()}, for instance, you would read the documentation for that
function using \code{?pdf_document}.
}
\examples{
\donttest{
yml() \%>\%
  yml_output(html_document())

yml() \%>\%
  yml_output(
    pdf_document(keep_tex = TRUE, includes = includes2(after_body = "footer.tex")),
    bookdown::html_document2()
  )
}
}
\seealso{
Other yml: 
\code{\link{asis_yaml_output}()},
\code{\link{bib2yml}()},
\code{\link{draw_yml_tree}()},
\code{\link{has_field}()},
\code{\link{read_json}()},
\code{\link{use_yml_defaults}()},
\code{\link{use_yml_file}()},
\code{\link{use_yml}()},
\code{\link{yml_author}()},
\code{\link{yml_blogdown_opts}()},
\code{\link{yml_bookdown_opts}()},
\code{\link{yml_citations}()},
\code{\link{yml_clean}()},
\code{\link{yml_distill_opts}()},
\code{\link{yml_latex_opts}()},
\code{\link{yml_pagedown_opts}()},
\code{\link{yml_params}()},
\code{\link{yml_pkgdown}()},
\code{\link{yml_reference}()},
\code{\link{yml_replace}()},
\code{\link{yml_resource_files}()},
\code{\link{yml_rsconnect_email}()},
\code{\link{yml_rticles_opts}()},
\code{\link{yml_runtime}()},
\code{\link{yml_site_opts}()},
\code{\link{yml_toc}()},
\code{\link{yml_vignette}()}
}
\concept{yml}
