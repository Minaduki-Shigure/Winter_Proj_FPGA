-makelib ies_lib/xil_defaultlib -sv \
  "D:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/Xilinx/Vivado/2018.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../Winter_Proj.srcs/sources_1/ip/clk_pll/clk_pll_clk_wiz.v" \
  "../../../../Winter_Proj.srcs/sources_1/ip/clk_pll/clk_pll.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

