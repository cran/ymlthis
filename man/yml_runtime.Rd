% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/yml_rmarkdown.R
\name{yml_runtime}
\alias{yml_runtime}
\title{Activate Shiny in R Markdown}
\usage{
yml_runtime(.yml, runtime = c("static", "shiny", "shiny_prerendered"))
}
\arguments{
\item{.yml}{a \code{yml} object created by \code{yml()}, \code{as_yml()}, or returned by
a \verb{yml_*()} function}

\item{runtime}{The runtime target for rendering. \code{static}, the default,
renders static documents; \code{shiny} allows you to include use Shiny in your
document. \code{shiny_prerendered} is a subset of the \code{shiny} runtime that
allows pre-rendering of app components (see the \href{https://rmarkdown.rstudio.com/authoring_shiny_prerendered.html}{R Markdown site} for
more)}
}
\value{
a \code{yml} object
}
\description{
The \code{runtime} field lets you use Shiny in your R Markdown document, making it
interactive. See the \href{https://bookdown.org/yihui/rmarkdown/interactive-documents.html}{R Markdown book} for
examples.
}
\examples{

yml() \%>\%
  yml_runtime("shiny")

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
\code{\link{yml_output}()},
\code{\link{yml_pagedown_opts}()},
\code{\link{yml_params}()},
\code{\link{yml_pkgdown}()},
\code{\link{yml_reference}()},
\code{\link{yml_replace}()},
\code{\link{yml_resource_files}()},
\code{\link{yml_rsconnect_email}()},
\code{\link{yml_rticles_opts}()},
\code{\link{yml_site_opts}()},
\code{\link{yml_toc}()},
\code{\link{yml_vignette}()}

Other R Markdown: 
\code{\link{yml_clean}()},
\code{\link{yml_params}()},
\code{\link{yml_site_opts}()},
\code{\link{yml_vignette}()}

Other shiny: 
\code{\link{yml_params}()}
}
\concept{R Markdown}
\concept{shiny}
\concept{yml}
