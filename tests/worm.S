






#         DNA = 'feature and flanking sequences',
#         DUMP = 'DUMP',
         #species = 'elegans',

x = postForm('http://www.wormbase.org/db/searches/advanced/dumper',
         species="briggsae",
         list="",
         flank3="0",
         flank5="0",
         feature="Gene Models",
         dump = "Plain TEXT",
         orientation = "Relative to feature",
         relative = "Chromsome",
         DNA ="flanking sequences only",
         .cgifields = paste(c("feature", "orientation", "DNA", "dump", "relative"), collapse=", "))

print(x)
