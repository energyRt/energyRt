# Generate GPR file for GAMS
.generate_gpr_gams_file <- function(tmp.dir) {
  zz <- file(paste(tmp.dir, '/energyRt_project.gpr', sep = ''), 'w')
  cat(c('[RP:MDL]', '1=', '', '[OPENWINDOW_1]', 
        'FILE0=energyRt.gms',
        'FILE1=energyRt.lst',
        # gsub('[/][/]*', '\\\\', paste('FILE0=', tmp.dir, '/energyRt.gms', sep = '')),
        # gsub('[/][/]*', '\\\\', paste('FILE1=', tmp.dir, '/energyRt.lst', sep = '')), 
        '', 'MAXIM=1', 
        'TOP=50', 'LEFT=50', 'HEIGHT=400', 'WIDTH=400', ''), sep = '\n', file = zz)
  close(zz)
}
