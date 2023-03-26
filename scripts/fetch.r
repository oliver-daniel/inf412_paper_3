if (!exists("DEBUG")) {
    DEBUG <- FALSE
}
library(tidyverse)

FILEPATH <- "data/bikeshares_2021.zip"

if (!file.exists(FILEPATH)) {
    download.file(
        "https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/7e876c24-177c-4605-9cef-e50dd74c617f/resource/ddc039f6-07fa-47a3-a707-0121ade3b307/download/bikeshare-ridership-2021.zip",
        FILEPATH
    )
}

zipped_files <- unzip(FILEPATH, list = TRUE)

if (!exists("data.all")) {
    files <- `if`(
        !DEBUG,
        zipped_files,
        zipped_files[1, ]
    )
    data.all <- do.call(rbind, lapply(files$Name, function(file) {
        parsed_file <- read_csv(unz(FILEPATH, file), show_col_types = FALSE) |>
            mutate(
                user_type = `User Type`,
                start = parse_datetime(`Start Time`, format = "%m/%d/%Y %R"),
            ) |>
            select(c(user_type, start))
        if (DEBUG) {
            sample_n(parsed_file, 5)
        } else {
            parsed_file
        }
    }))
}
