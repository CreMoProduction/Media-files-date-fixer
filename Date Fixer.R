packages <- c(
  "exifr",
  "progress", 
  "svDialogs"
)
install.packages(setdiff(packages, rownames(installed.packages())))
#-----------
lapply(packages, require, character.only = TRUE)

# Set the directory path
dir_path <- choose.dir(default = "", caption = "Select folder")
extesnion_list <- c("jpg","png","mp4", "mov", "OTHER")
extension <- menu(extesnion_list, graphics=TRUE, title="Choose extension")
extension= extesnion_list[extension]
if(extension=="OTHER") {
  extension <- readline(prompt="To continue, please enter file extension here manually: ")
} else {}
print(extension)
file_list <- list.files(file.path(dir_path,"Init", fsep="\\"), pattern = paste("\\.",extension,"$", sep=""), full.names = TRUE)
#выбираю параметр exif
read_exif(file_list[1])
sorted_exif_propties = sort(colnames(exif))
print(sorted_exif_propties)
# Prompt the user to enter a numeric value
exif_property <- select.list(choices = c(sorted_exif_propties), 
                            title = "Select an exif property",
                            graphics = TRUE)
cat("You selected:", exif_property)

i=1
pb <- progress_bar$new(total = length(file_list))
for (i in 100:length(file_list)) {
  exif <- read_exif(file_list[i])
  media_created <- exif[exif_property]
  media_created <- sub(":", "-", media_created, fixed = TRUE)
  media_created <- sub(":", "-", media_created, fixed = TRUE)
  file_name_output <- basename(file_list[i])
  file_output= paste(dir_path, "Output/", file_name_output, sep="")
  file_info <- file.info(file_output)
  file_info$ctime <- as.POSIXct(media_created, format = "%Y-%m-%d %H:%M:%S")
  Sys.setFileTime(file_output, media_created)
  #pb$tick()
  #Sys.sleep(1 / 100)
  print(paste(i, basename(file_list[i]), sep=" "))
}




