# load list of examples of input and output for all functions
load("primeri.RDat")
# If there are new examples, add them here.
# Order of examples doesn't matter.
# 1st element of the list is input, 2nd is output
primeri$minduv <- list(0.4, 2400)
# save updated list
#save(primeri,file="primeri.RDat")

# function evaluates received code snippet
codeevaluation <- function(snip){
  # extracting function name from snippet
  fname <- strsplit(snip,"[<= ]")[[1]][1]
  if (fname %in% names(primeri)) {
    # check if the syntax is correct
    expr <- tryCatch(parse(text=snip),error=function(e){
      fdbck <- "There is a syntax error in the snippet."
      return(fdbck)
      stop()
    })
    eval(expr)
    # take input example for this function 
    ulaz <- primeri[[fname]][[1]]
    izlaz <- tryCatch(eval(parse(text=paste0(fname,"(ulaz)"))),
                      error=function(e){
                        fdbck <- "Function failed."
                        return(fdbck)
                        stop()
                      })
    # check if the output is equal to what we expected
    izlaz0 <- primeri[[fname]][[2]]
    if (!is.null(izlaz) & all(format(izlaz,digits=5) ==format(izlaz0,digits=5))) {
      fdbck <- "Test example successfully passed."
    } else {
      fdbck <- "Test example failed."
    }
  } else {
    fdbck <- "Function name is not recognized."
  }
  return(fdbck)
}

# name the task which needs feedback
task <- "koevari"
# print feedback for yourself
for (i in 1:dim(snippets)[1]) {
  s <- snippets[i,task]
  if (!is.na(s)) cat(snippets$names[i],"\t",codeevaluation(s),"\n") 
}
# reply to students' messages
for (i in 1:dim(snippets)[1]) {
  s <- snippets[i,task]
  if (!is.na(s)) msgs[[msgID[i,task]]]$send_reply(codeevaluation(s))
}

