# make sure you do not have an old copy of the package
remove.packages("escapeR")
# install the newest version of escapeR from github
# if you have never done so
# this requires you install the "remotes" package first
# if so, run this commented line of code below first
# install.packages("remotes")
# now you install escapeR
remotes::install_github("TiagoAMarques/escapeR")
# and now you start the "Ecologia Numérica" escape room
# replace "Tiago" with your name, unless your name happens to be Tiago :)
library(escapeR)
escape(player = "Tiago", escape = "en2026")
# have fun and help me test the new escape room for EN students
# send me all the comments you might have!
