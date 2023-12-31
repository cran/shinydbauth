

#' @importFrom R6 R6Class
#' @importFrom openssl sha256 rand_bytes
.tokens <- R6::R6Class(
  classname = "shinydbauth_tokens",
  public = list(
    initialize = function() {
      invisible(self)
    },
    generate = function(user) {
      sha256(paste0(user, Sys.time()), key = rand_bytes(32))
    },
    add = function(token, ...) {
      args <- list(...)
      if(length(args) > 0){
        args[[1]]$shinydbauth_datetime <- Sys.time()
      } else {
        args <- list(list(shinydbauth_datetime = Sys.time()))
      }
      private$tokens <- union(private$tokens, token)
      if (length(args) > 0) {
        private$tokens_user <- append(
          x = private$tokens_user,
          values = setNames(
            object = args,
            nm = token
          )
        )
      }
      invisible(self)
    },
    is_valid_timeout = function(token, update = TRUE) {
      datetime <- private$tokens_user[[token]]$shinydbauth_datetime
      if(!is.null(datetime) && private$timeout  > 0){
        valid <- difftime(Sys.time(), datetime, units = "mins") <= private$timeout
      } else {
        valid <- TRUE
      }
      if(valid && update) private$tokens_user[[token]]$shinydbauth_datetime <- Sys.time()
      valid
    },
    get_user = function(token) {
      private$usernames[[token]]$user
    },
    set_user = function(token, user) {
      private$usernames[[token]]$user = user
    },
    is_valid = function(token) {
      valid <- token %in% private$tokens
      count <- sum(private$tokens_count %in% token, na.rm = TRUE)
      private$tokens_count <- c(private$tokens_count, token)
      isTRUE(valid) & isTRUE(count < 1)
    },
    is_valid_server = function(token) {
      isTRUE(token %in% private$tokens)
    },
    get = function(token) {
      info <- private$tokens_user[[token]]
      if("shinydbauth_datetime" %in% names(info)) info$shinydbauth_datetime <- NULL
      info
    },
    remove = function(token) {
      if (private$length() == 0) return(NULL)
      private$tokens <- setdiff(private$tokens, token)
      invisible()
    },
    reset_count = function(token) {
      private$tokens_count <- setdiff(private$tokens_count, token)
    },
    set_sqlite_path = function(path) {
      private$sqlite_path <- path
      invisible(private$sqlite_path)
    },
    get_sqlite_path = function() {
      private$sqlite_path
    },
    set_passphrase = function(passphrase) {
      private$passphrase <- passphrase
      invisible()
    },
    get_passphrase = function() {
      private$passphrase
    },
    set_timeout = function(timeout) {
      private$timeout <- timeout
      invisible()
    },
    get_timeout = function() {
      private$timeout
    }
  ),
  private = list(
    tokens = character(0),
    tokens_count = character(0),
    tokens_user = list(),
    usernames = list(),
    sqlite_path = NULL,
    passphrase = NULL,
    sql_config_db = NULL,
    timeout = 0,
    length = function() base::length(private$tokens)
  )
)
.tok <- .tokens$new()

