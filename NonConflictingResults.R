##removes conflicting data where same gene has both positive and negative effect.size results

## Group By: 'Gene'
## Comparing By: 'effect.size'

filename = file.choose()         #prompt user for filename/location
info = read.delim(filename)      #read file into dataframe

info$Gene_upper <- toupper(info$Gene)   #create new row of Genes in uppercase to allow comparison

info_aggMin = aggregate(effect.size ~ Gene_upper, info, function(x) min(x))    #calculate min per gene
info_aggMax = aggregate(effect.size ~ Gene_upper, info, function(x) max(x))    #calculate max per gene
info$diff_index <- match(info$Gene_upper, info_aggMin$Gene_upper)              #add index of min/max to dataframe

info$diff = info_aggMin$effect.size[info$diff_index] * info_aggMax$effect.size[info$diff_index]   #calculate diff using index

info_results <- info[info$diff > 0, 1:8]    #(diff will always be positive if +/- match)... extract original columns only

write.table(info_results, "cleaned_data.txt", sep="\t", row.names=FALSE)   #write to file
