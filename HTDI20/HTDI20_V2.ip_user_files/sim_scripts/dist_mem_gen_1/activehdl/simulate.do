transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+dist_mem_gen_1  -L dist_mem_gen_v8_0_14 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.dist_mem_gen_1 xil_defaultlib.glbl

do {dist_mem_gen_1.udo}

run 1000ns

endsim

quit -force
