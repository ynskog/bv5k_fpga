history clear
run_tcl -fg Top_syn.tcl
impl -active synthesis_bk
impl -active synthesis
set_option -frequency 36.000000
edit_instr
text_select 5 2 6 1
project -save C:/Users/yngve/Dropbox/projects/bilradar/fpga/bv5000/synthesis/Top_syn.prj 
project -run  
project -run  
project -run  
project -run  
project -run  
project -run  
project_file -remove C:/Users/yngve/Dropbox/projects/bilradar/fpga/bv5000/synthesis/synthesis_identify/identify.idc
edit_instr
text_select 4 37 4 39
text_select 4 36 4 39
project -save C:/Users/yngve/Dropbox/projects/bilradar/fpga/bv5000/synthesis/Top_syn.prj 
project -run  
text_select 4 36 4 37
project -run  
project -close C:/Users/yngve/Dropbox/projects/bilradar/fpga/bv5000/synthesis/Top_syn.prj
