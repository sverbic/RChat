library(Microsoft365R)
library(htm2txt)

# You should be logged to office.com to get Teams messages
# this way. Probably, you'll need administration privileges too.
# Also, you need to be member of the team.
team <- get_team('Statistika i analiza podataka (P23)')
# get list of team members
lim <- team$list_members()
nms <- vector(mode="character",length(lim))
for (i in 1:length(lim)) {
  nms[i] <- lim[[i]]$properties$displayName
}
# make two data frames for snippets and their indexes
snippets <- data.frame(names=nms)
msgID <- data.frame(names=nms)

# my channel is named Rcode
chan <- team$get_channel('Rcode')
# By default, function retrieves only the 50 most recent messages.
msgs <- chan$list_messages(n=Inf)
# We'll write down all plain-text messages to a file.
sink("Rcode.txt")
myname <- "Srđan Verbić" # My snippets shouldn't be evaluated.
for (ind in length(msgs):1) {
  nm <- msgs[[ind]]$properties$from$user$displayName
  if (is.null(nm)) next   # go for the next if name is null
  if (nm==myname) next  # next if it is my message
  tm <- msgs[[ind]]$properties$createdDateTime
  ht <- msgs[[ind]]$properties$body$content
  text <- htm2txt(ht) #convert to plain text
  # There are some obsolete signs in snippets that should be removed.
  zws1 <- "\u200B" # "zero width space" (PC & Mac)
  nbs2 <- "\u00A0{2}" # 2-fold "no-break space" (Mac) 
  zws5 <- "\u200B{5}" # 5-fold "zero width space" (PC)
  text <- gsub(nbs2,"\n",text) # substitute zws2 w/ break
  text <- gsub(zws1,"",text) # remove zws5
  text <- gsub("\n\n","\n",text) # remove double breaks
  cat(tm,"\t",nm,"\n",text,"\n")

  # extract function name (characters left of " ", "<" or "=")
  clm <- strsplit(text,"[<= ]")[[1]][1]
  if (clm %in% colnames(snippets)) {
    snippets[snippets$names==nm,which(clm==colnames(snippets))] <- text
    msgID[snippets$names==nm,which(clm==colnames(snippets))] <- ind
  } else {
    nextcol <- dim(snippets)[2]+1
    snippets[snippets$names==nm,nextcol] <- text
    msgID[snippets$names==nm,nextcol] <- ind
    colnames(snippets)[nextcol] <- clm
    colnames(msgID)[nextcol] <- clm
  }
  # print(clm)
}
sink()

# write down snippets' data frames
save(snippets,file="snippets.RData")
save(msgID,file="msgID.RData")
