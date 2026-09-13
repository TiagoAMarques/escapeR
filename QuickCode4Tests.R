# make sure you do not have an old copy of the package
remove.packages("escapeR")
# install the newest version
remotes::install_github("TiagoAMarques/escapeR")
# replace with your names
escape(player = "Tiago", escape = "en2026")
# have fun and help me test the new escape room for EN students