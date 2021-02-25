# # load('c:/tmp/1.rdata')
# # 
# # approxim$ry <- approxim$rys[, -3]
# # approxim$ry <- approxim$ry[!duplicated(approxim$ry), ]
# # 
# # 
# # app = tech
# # 
# # slt = app@stock
# # dtf = approxim$ry
# # par = 'stock'
# # res <- obj@parameters$pTechStock
# 
# # simpleInterpolation(tech@stock, 'stock', obj@parameters[['pTechStock']], approxim, 'tech', tech@name)
# 
# interpolation_dtf <- function(slt, par, res, dtf, add_set_name = NULL, add_set_value = NULL, respName = 'value') {
#   # assign('slt', slt, globalenv())
#   # assign('par', par, globalenv())
#   # assign('res', res, globalenv())
#   # assign('dtf', dtf, globalenv())
#   # assign('add_set_name', add_set_name, globalenv())
#   # assign('add_set_value', add_set_value, globalenv())
#   true_col <- c(add_set_name, colnames(slt))
#   add_col <- function(dtf) {
#     colnames(dtf)[colnames(dtf) == par] <- respName
#     if (is.null(add_set_name)) return(dtf)
#     cln <- colnames(dtf)
#     for (i in seq_along(add_set_name)) {
#       dtf[[add_set_name[i]]] <- add_set_value[[i]]
#     }
#     return(dtf[, true_col, drop = FALSE])
#   }
#   defVal = res@defVal
#   rule = res@interpolation
#   # Function
#   slt <- slt[!is.na(slt[, par]), c(colnames(dtf), par), drop = FALSE]
#   
#   if (anyDuplicated(slt[, -ncol(slt)])) {
#     slt <- slt[!duplicated(slt[, -ncol(slt)]),, drop = FALSE]
#     warning("there are duplicates in the data, use findDuplicates function to get more information")
#   }
#   na_val <- is.na(slt[, -ncol(slt)])
#   # Check if ther is not data
#   if (nrow(slt) == 0) {
#     dtf[[par]] <- defVal
#     return(add_col(dtf))
#   }
#   # Check if set only one value for all
#   if (nrow(slt) == 1 && all(na_val)) {
#     dtf[[par]] <- slt[1, par]
#     return(add_col(dtf))
#   }
#   # Check if possible simple interpolation
#   f1 <- apply(na_val, 2, all)
#   f2 <- apply(na_val, 2, any)
#   if (all(f1 == f2)) { # There are only NA and not NA column & Could be small appr
#     slt2 <- merge(dtf, slt[, c(!f1, TRUE), drop = FALSE], by = colnames(dtf)[!f1])
#     if (nrow(slt2) == nrow(dtf))
#       return(add_col(slt2))
#     # Add dop NA columns, and increase speed
#     slt[c(f1, FALSE)] <- NULL
#     dtf2 <- dtf[, !f1, drop = FALSE]
#     dtf2 <- dtf2[!duplicated(dtf2),, drop = FALSE] 
#   } else dtf2 <- dtf
#   
#   prior <- c('stg', 'trade', 'tech', 'sup', 'group', 'acomm', 'comm', 'commp', 'region',
#     'regionp', 'src', 'dst', 'slice', 'year')
#   prior <- prior[prior %in% colnames(dtf2)]
#   true_prior <- c('stg', 'trade', 'tech', 'sup', 'group', 'acomm', 'comm', 'commp', 'region',
#     'regionp', 'src', 'dst', 'year', 'slice')
#   true_prior <- true_prior[true_prior %in% colnames(dtf2)]
#   dtf2 <- dtf2[, prior, drop = FALSE]
#   slt <- slt[, c(prior, par), drop = FALSE]
#   dtf2[[par]] <- NA
#   
#   for_order <- is.na(slt[, prior, drop = FALSE]) * 1
#   for_order <- rowSums(t(t(for_order) * 2 ^ (seq_len(ncol(for_order)) - 1)))
#   browser()
#   for (i in sort(unique(for_order), decreasing = TRUE)) {
#     tapr <- slt[for_order == i,, drop = FALSE]
#     tapr <- tapr[, c(!is.na(tapr[1, prior]), TRUE), drop = FALSE]
#     nn1 <- dtf2[, c(!is.na(tapr[1, prior]), FALSE), drop = FALSE]
#     nn2 <- nn1[, 1]
#     
#     tapr
#   }
#   
#   
#   
# }
# # # Interpolation
# # 
# # k <- 1 * na_val[, 1]
# # for (i in seq_along(true_prior))
# # 
# # na_val
# 
# # 
# # 
# # dtf[[par]] <- NA
# # 
# # 
# # dd <- interpolation(frm, parameter,
# #   rule       = mtp@interpolation,
# #   defVal    = mtp@defVal,
# #   year_range = range(approxim$year),
# #   approxim   = approxim)
# # 
# # app
# # 
# # 
# # approxim$rys
