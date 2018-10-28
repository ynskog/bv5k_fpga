project -load C:/Users/yngve/Dropbox/projects/bilradar/fpga/bv5000/synthesis/Top_syn.prj
puts "Generating SRS instrumentation file: C:\Users\yngve\Dropbox\projects\bilradar\fpga\bv5000\synthesis\synthesis\instr_sources\syn_dics.v"
 if { [catch {write instrumentation} err] } {
    puts stderr "write instrumentation failed $err"
    exit 9
}
