\name{NEWS}
\title{News for package \pkg{RCurl}}
\section{Changes in version 1.98-1.20 (2026-08-21)}{\itemize{
  \item Replace the \code{.Names} argument with \code{names} in the call
  to \code{structure()}, addressing the NOTE introduced in R-devel
  r90251.
  \item Minor documentation fixes.
}}
\section{Changes in version 1.98-1.19 (2026-06-03)}{\itemize{
  \item Remove \verb{omegahat.net} from URL checks and network-accessing
  examples, since it's unclear whether the new domain owner can be
  trusted. Offline references still remain.
  \item Harden the examples against network access problems. Impose a
  limit of 20 redirects in \code{url.check()}, but rely more on
  \code{tryCatch}.
  \item Silence an \code{rchk} warning.
}}
