# text extraction functions
btab_text_ext <- \(file, regexpr = c("Letting No:(\\s*)(\\d+)", 
                                 "Contract ID:(\\s*)(\\D+)(\\d+)",
                                 "Letting Date:(\\s*)(\\D+)(\\s*)(\\d+),(\\s)(\\d+)",
                                 "Counties:(\\s*).*",
                                 "Contract Time:(\\s*)[0-9/\\.]+",
                                 "Contract Description:(.|\n)+"), print = FALSE){
  
  # pdf text second page
  pdf_text <- pdftools::pdf_text(file)[2]
  
  # get text based information
  tmp <- sapply(regexpr[-length(regexpr)], \(x){
    
    # extrct
    extr <-  stringr::str_extract(pdf_text, x)
    
    if(is.na(extr)) return(NA) else{

      # split by :
      stringr::str_trim(unlist(stringr::str_split(extr, ":"))[[2]])
      
    }
  
  })
  
  # Description
  descr <- stringr::str_split(stringr::str_extract(pdf_text, tail(regexpr, 1)),
                              "Percent Of")
  
  # add
  tmp <- c(tmp, unlist(descr)[[1]])
  
  # names
  tmp <- tmp |> setNames(c("Letting No", "Contract ID", "Letting Date", "Counties",
                    "Contract Time", "Contract Description"))
  
  # return
  if(print) print(tmp)
  return(tmp)
}
