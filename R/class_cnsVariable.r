#---------------------------------------------------------------------------------------------------------
# cnsVariable
#---------------------------------------------------------------------------------------------------------
setClass('cnsVariable', 
      representation(
          parameter     = "character",
          set_name      = "character",
          #use_set       = "list", # set that initialize by parent class
          set           = "list",  # other set, creat by function create_set
          ext_set       = "list",  # External set, that know use in constrains
          default       = "numeric", 
          value         = "data.frame",
          misc = "list"
          # parameter= list() # For the future
      ),
      prototype(
          parameter     = "",
          set_name      = NULL,
          #use_set       = list(), 
          set           = list(), 
          ext_set       = list(),  # External set, that know use in constrains
          default       = 1, 
          value         = NULL,#data.frame(value = numeric(), stringsAsFactors = FALSE),
          # parameter= list() # For the future
      #! Misc
      misc = list(
        GUID = "a7c5f404-7107-405e-9aec-8684118f23ba"
      )),
      S3methods = TRUE
);

# add set to constrain
add_set.cnsVariable <- function(vrb, ...) {
  vrb@set[[length(cns@set) + 1]] <- create_set(...)
  vrb
}

# Test
##print(create_cnsVariable('vTecInp'))
##technology <- c('TEC1', 'TEC2', 'TEC3')
### supply <- 'MINCOA'
### group <- as.character(1:3)
##comm <- c('COA', 'GAS')
### region <- 'RUS'
### year <- as.character(2005:2050)
### slice <- 'ANNUAL'
##level <- list(comm = comm, technology = technology)
##print(create_cnsVariable('vTecInp', set = list(create_set('technology', c('TEC1', 'TEC2')))))
##print(create_cnsVariable('vTecInp', set = list(create_set('technology', c('TEC1', 'TEC2')),
##        create_set('comm', c('COA', 'GAS'))), default = 5))
##print(create_cnsVariable('vTecInp', ext_set = list(create_set('technology', c('TEC1', 'TEC2')),
##        create_set('comm', c('COA', 'GAS'))), default = 5))
##
##vrb <- create_cnsVariable('vTecInp', set = list(create_set('technology', c('TEC1', 'TEC2')),
##        create_set('comm', c('COA', 'GAS'))), default = 5)
##        
##
##prepare(vrb, level)

# cns@name <- 'constr1'
# cns <- add_set(cns, 'group')
# cns <- add_set(cns, 'comm', alias = c('hgj'))
# cns <- add_set(cns, 'region', set = c('RUS'))
# cns <- add_set(cns, 'technology', set = c('TEC1', 'TEC2'))
# cns <- create_data_frame(cns)
# 
