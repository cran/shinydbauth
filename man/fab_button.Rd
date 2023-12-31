% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fab_button.R
\name{fab_button}
\alias{fab_button}
\title{Create a FAB button}
\usage{
fab_button(
  ...,
  position = c("bottom-right", "top-right", "bottom-left", "top-left", "none"),
  animation = c("slidein", "slidein-spring", "fountain", "zoomin"),
  toggle = c("hover", "click"),
  inputId = NULL,
  label = NULL
)
}
\arguments{
\item{...}{\code{actionButton}s to be used as floating buttons.}

\item{position}{Position for the button.}

\item{animation}{Animation when displaying floating buttons.}

\item{toggle}{Display floating buttons when main button is clicked or hovered.}

\item{inputId}{Id for the FAB button (act like an \code{actionButton}).}

\item{label}{Label for main button.}
}
\description{
Create a fixed button in page corner with additional button(s) in it
}
