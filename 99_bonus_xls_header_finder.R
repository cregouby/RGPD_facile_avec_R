library(tidyverse)
library(readxl)
library(furrr)
library(progressr)
plan(multisession, workers = 4)


xls_files_raw <- list.files("data", pattern = "\\.(xls|XLS)\\w?$", recursive=T, full.names = T)
xls_files <- xls_files_raw %>% str_subset("original")

# debug and investigation
# xls_files <- xls_files %>% sample(size = 10)
# path <- xls_files[[1]]
# sheet <- excel_sheets(path)[[1]]

### first line of each sheet as header
# read_xls_colnames <- function(path, skip=0) {
#   filename %>% excel_sheets %>% set_names %>% map(~suppressMessages(read_excel(sheet=.x, path=path, skip=skip, n_max = 1)) %>% colnames)
# }
### maximising the number of string beeing colnqmes
get_best_header <- function(path, sheet, n_max=12) {
  xls <- suppressMessages(read_excel(path=path, n_max = n_max, sheet = sheet,col_names = FALSE) )
  # TODO we could prefer to maximize non-na non-numeric only over whqtever non_na content
  # get first line having the maximum on non-na content
  if (nrow(xls)<1) {
    return(NA_character_)
  }
  non_na <-rowSums(!is.na(xls))
  best_header <- xls[which(max(non_na)==non_na),] %>% first() %>% as.character()
  return(best_header)
}
read_xls_colnames <- function(filename, skip=0) {
  filename %>% excel_sheets %>% set_names %>% map(~get_best_header(filename, .x))
}
find_xls_sheet_header <- function(xls_files) {
  p <- progressor(steps = length(xls_files))
  future_map(xls_files, ~{
    p()
    # possibly(read_xls_colnames(.x), otherwise = list(NA_character_))
    read_xls_colnames(.x)
    })
  
}
with_progress({
  sheet_cols <- find_xls_sheet_header(xls_files)
})

xls_columns <- tibble(
  path = map_chr(xls_files, dirname),
  file = map_chr(xls_files, basename),
  sheet_cols = sheet_cols
) %>% 
  mutate(nb_sheet = map_int(.$sheet_cols, length))

saveRDS(xls_columns, "data/processed/EUSES_all_xls_colnames.rds")

