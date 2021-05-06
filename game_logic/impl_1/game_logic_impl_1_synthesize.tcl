if {[catch {

# define run engine funtion
source [file join {/home/es4user/tools/radiant/2.2} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) 1
set para(prj_dir) "/home/es4user/getBricked/game_logic"
# synthesize IPs
# synthesize VMs
# synthesize top design
run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o game_logic_impl_1_syn.udb game_logic_impl_1.vm] "/home/es4user/getBricked/game_logic/impl_1/game_logic_impl_1.ldc"

} out]} {
   runtime_log $out
   exit 1
}
