onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate /testbench/pcFetch
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/reset
add wave -noupdate -radix decimal /testbench/pcFetch
add wave -noupdate -divider instuctions
add wave -noupdate -radix unsigned -childformat {{{/testbench/uut/bpu/bht[255]} -radix unsigned} {{/testbench/uut/bpu/bht[254]} -radix unsigned} {{/testbench/uut/bpu/bht[253]} -radix unsigned} {{/testbench/uut/bpu/bht[252]} -radix unsigned} {{/testbench/uut/bpu/bht[251]} -radix unsigned} {{/testbench/uut/bpu/bht[250]} -radix unsigned} {{/testbench/uut/bpu/bht[249]} -radix unsigned} {{/testbench/uut/bpu/bht[248]} -radix unsigned} {{/testbench/uut/bpu/bht[247]} -radix unsigned} {{/testbench/uut/bpu/bht[246]} -radix unsigned} {{/testbench/uut/bpu/bht[245]} -radix unsigned} {{/testbench/uut/bpu/bht[244]} -radix unsigned} {{/testbench/uut/bpu/bht[243]} -radix unsigned} {{/testbench/uut/bpu/bht[242]} -radix unsigned} {{/testbench/uut/bpu/bht[241]} -radix unsigned} {{/testbench/uut/bpu/bht[240]} -radix unsigned} {{/testbench/uut/bpu/bht[239]} -radix unsigned} {{/testbench/uut/bpu/bht[238]} -radix unsigned} {{/testbench/uut/bpu/bht[237]} -radix unsigned} {{/testbench/uut/bpu/bht[236]} -radix unsigned} {{/testbench/uut/bpu/bht[235]} -radix unsigned} {{/testbench/uut/bpu/bht[234]} -radix unsigned} {{/testbench/uut/bpu/bht[233]} -radix unsigned} {{/testbench/uut/bpu/bht[232]} -radix unsigned} {{/testbench/uut/bpu/bht[231]} -radix unsigned} {{/testbench/uut/bpu/bht[230]} -radix unsigned} {{/testbench/uut/bpu/bht[229]} -radix unsigned} {{/testbench/uut/bpu/bht[228]} -radix unsigned} {{/testbench/uut/bpu/bht[227]} -radix unsigned} {{/testbench/uut/bpu/bht[226]} -radix unsigned} {{/testbench/uut/bpu/bht[225]} -radix unsigned} {{/testbench/uut/bpu/bht[224]} -radix unsigned} {{/testbench/uut/bpu/bht[223]} -radix unsigned} {{/testbench/uut/bpu/bht[222]} -radix unsigned} {{/testbench/uut/bpu/bht[221]} -radix unsigned} {{/testbench/uut/bpu/bht[220]} -radix unsigned} {{/testbench/uut/bpu/bht[219]} -radix unsigned} {{/testbench/uut/bpu/bht[218]} -radix unsigned} {{/testbench/uut/bpu/bht[217]} -radix unsigned} {{/testbench/uut/bpu/bht[216]} -radix unsigned} {{/testbench/uut/bpu/bht[215]} -radix unsigned} {{/testbench/uut/bpu/bht[214]} -radix unsigned} {{/testbench/uut/bpu/bht[213]} -radix unsigned} {{/testbench/uut/bpu/bht[212]} -radix unsigned} {{/testbench/uut/bpu/bht[211]} -radix unsigned} {{/testbench/uut/bpu/bht[210]} -radix unsigned} {{/testbench/uut/bpu/bht[209]} -radix unsigned} {{/testbench/uut/bpu/bht[208]} -radix unsigned} {{/testbench/uut/bpu/bht[207]} -radix unsigned} {{/testbench/uut/bpu/bht[206]} -radix unsigned} {{/testbench/uut/bpu/bht[205]} -radix unsigned} {{/testbench/uut/bpu/bht[204]} -radix unsigned} {{/testbench/uut/bpu/bht[203]} -radix unsigned} {{/testbench/uut/bpu/bht[202]} -radix unsigned} {{/testbench/uut/bpu/bht[201]} -radix unsigned} {{/testbench/uut/bpu/bht[200]} -radix unsigned} {{/testbench/uut/bpu/bht[199]} -radix unsigned} {{/testbench/uut/bpu/bht[198]} -radix unsigned} {{/testbench/uut/bpu/bht[197]} -radix unsigned} {{/testbench/uut/bpu/bht[196]} -radix unsigned} {{/testbench/uut/bpu/bht[195]} -radix unsigned} {{/testbench/uut/bpu/bht[194]} -radix unsigned} {{/testbench/uut/bpu/bht[193]} -radix unsigned} {{/testbench/uut/bpu/bht[192]} -radix unsigned} {{/testbench/uut/bpu/bht[191]} -radix unsigned} {{/testbench/uut/bpu/bht[190]} -radix unsigned} {{/testbench/uut/bpu/bht[189]} -radix unsigned} {{/testbench/uut/bpu/bht[188]} -radix unsigned} {{/testbench/uut/bpu/bht[187]} -radix unsigned} {{/testbench/uut/bpu/bht[186]} -radix unsigned} {{/testbench/uut/bpu/bht[185]} -radix unsigned} {{/testbench/uut/bpu/bht[184]} -radix unsigned} {{/testbench/uut/bpu/bht[183]} -radix unsigned} {{/testbench/uut/bpu/bht[182]} -radix unsigned} {{/testbench/uut/bpu/bht[181]} -radix unsigned} {{/testbench/uut/bpu/bht[180]} -radix unsigned} {{/testbench/uut/bpu/bht[179]} -radix unsigned} {{/testbench/uut/bpu/bht[178]} -radix unsigned} {{/testbench/uut/bpu/bht[177]} -radix unsigned} {{/testbench/uut/bpu/bht[176]} -radix unsigned} {{/testbench/uut/bpu/bht[175]} -radix unsigned} {{/testbench/uut/bpu/bht[174]} -radix unsigned} {{/testbench/uut/bpu/bht[173]} -radix unsigned} {{/testbench/uut/bpu/bht[172]} -radix unsigned} {{/testbench/uut/bpu/bht[171]} -radix unsigned} {{/testbench/uut/bpu/bht[170]} -radix unsigned} {{/testbench/uut/bpu/bht[169]} -radix unsigned} {{/testbench/uut/bpu/bht[168]} -radix unsigned} {{/testbench/uut/bpu/bht[167]} -radix unsigned} {{/testbench/uut/bpu/bht[166]} -radix unsigned} {{/testbench/uut/bpu/bht[165]} -radix unsigned} {{/testbench/uut/bpu/bht[164]} -radix unsigned} {{/testbench/uut/bpu/bht[163]} -radix unsigned} {{/testbench/uut/bpu/bht[162]} -radix unsigned} {{/testbench/uut/bpu/bht[161]} -radix unsigned} {{/testbench/uut/bpu/bht[160]} -radix unsigned} {{/testbench/uut/bpu/bht[159]} -radix unsigned} {{/testbench/uut/bpu/bht[158]} -radix unsigned} {{/testbench/uut/bpu/bht[157]} -radix unsigned} {{/testbench/uut/bpu/bht[156]} -radix unsigned} {{/testbench/uut/bpu/bht[155]} -radix unsigned} {{/testbench/uut/bpu/bht[154]} -radix unsigned} {{/testbench/uut/bpu/bht[153]} -radix unsigned} {{/testbench/uut/bpu/bht[152]} -radix unsigned} {{/testbench/uut/bpu/bht[151]} -radix unsigned} {{/testbench/uut/bpu/bht[150]} -radix unsigned} {{/testbench/uut/bpu/bht[149]} -radix unsigned} {{/testbench/uut/bpu/bht[148]} -radix unsigned} {{/testbench/uut/bpu/bht[147]} -radix unsigned} {{/testbench/uut/bpu/bht[146]} -radix unsigned} {{/testbench/uut/bpu/bht[145]} -radix unsigned} {{/testbench/uut/bpu/bht[144]} -radix unsigned} {{/testbench/uut/bpu/bht[143]} -radix unsigned} {{/testbench/uut/bpu/bht[142]} -radix unsigned} {{/testbench/uut/bpu/bht[141]} -radix unsigned} {{/testbench/uut/bpu/bht[140]} -radix unsigned} {{/testbench/uut/bpu/bht[139]} -radix unsigned} {{/testbench/uut/bpu/bht[138]} -radix unsigned} {{/testbench/uut/bpu/bht[137]} -radix unsigned} {{/testbench/uut/bpu/bht[136]} -radix unsigned} {{/testbench/uut/bpu/bht[135]} -radix unsigned} {{/testbench/uut/bpu/bht[134]} -radix unsigned} {{/testbench/uut/bpu/bht[133]} -radix unsigned} {{/testbench/uut/bpu/bht[132]} -radix unsigned} {{/testbench/uut/bpu/bht[131]} -radix unsigned} {{/testbench/uut/bpu/bht[130]} -radix unsigned} {{/testbench/uut/bpu/bht[129]} -radix unsigned} {{/testbench/uut/bpu/bht[128]} -radix unsigned} {{/testbench/uut/bpu/bht[127]} -radix unsigned} {{/testbench/uut/bpu/bht[126]} -radix unsigned} {{/testbench/uut/bpu/bht[125]} -radix unsigned} {{/testbench/uut/bpu/bht[124]} -radix unsigned} {{/testbench/uut/bpu/bht[123]} -radix unsigned} {{/testbench/uut/bpu/bht[122]} -radix unsigned} {{/testbench/uut/bpu/bht[121]} -radix unsigned} {{/testbench/uut/bpu/bht[120]} -radix unsigned} {{/testbench/uut/bpu/bht[119]} -radix unsigned} {{/testbench/uut/bpu/bht[118]} -radix unsigned} {{/testbench/uut/bpu/bht[117]} -radix unsigned} {{/testbench/uut/bpu/bht[116]} -radix unsigned} {{/testbench/uut/bpu/bht[115]} -radix unsigned} {{/testbench/uut/bpu/bht[114]} -radix unsigned} {{/testbench/uut/bpu/bht[113]} -radix unsigned} {{/testbench/uut/bpu/bht[112]} -radix unsigned} {{/testbench/uut/bpu/bht[111]} -radix unsigned} {{/testbench/uut/bpu/bht[110]} -radix unsigned} {{/testbench/uut/bpu/bht[109]} -radix unsigned} {{/testbench/uut/bpu/bht[108]} -radix unsigned} {{/testbench/uut/bpu/bht[107]} -radix unsigned} {{/testbench/uut/bpu/bht[106]} -radix unsigned} {{/testbench/uut/bpu/bht[105]} -radix unsigned} {{/testbench/uut/bpu/bht[104]} -radix unsigned} {{/testbench/uut/bpu/bht[103]} -radix unsigned} {{/testbench/uut/bpu/bht[102]} -radix unsigned} {{/testbench/uut/bpu/bht[101]} -radix unsigned} {{/testbench/uut/bpu/bht[100]} -radix unsigned} {{/testbench/uut/bpu/bht[99]} -radix unsigned} {{/testbench/uut/bpu/bht[98]} -radix unsigned} {{/testbench/uut/bpu/bht[97]} -radix unsigned} {{/testbench/uut/bpu/bht[96]} -radix unsigned} {{/testbench/uut/bpu/bht[95]} -radix unsigned} {{/testbench/uut/bpu/bht[94]} -radix unsigned} {{/testbench/uut/bpu/bht[93]} -radix unsigned} {{/testbench/uut/bpu/bht[92]} -radix unsigned} {{/testbench/uut/bpu/bht[91]} -radix unsigned} {{/testbench/uut/bpu/bht[90]} -radix unsigned} {{/testbench/uut/bpu/bht[89]} -radix unsigned} {{/testbench/uut/bpu/bht[88]} -radix unsigned} {{/testbench/uut/bpu/bht[87]} -radix unsigned} {{/testbench/uut/bpu/bht[86]} -radix unsigned} {{/testbench/uut/bpu/bht[85]} -radix unsigned} {{/testbench/uut/bpu/bht[84]} -radix unsigned} {{/testbench/uut/bpu/bht[83]} -radix unsigned} {{/testbench/uut/bpu/bht[82]} -radix unsigned} {{/testbench/uut/bpu/bht[81]} -radix unsigned} {{/testbench/uut/bpu/bht[80]} -radix unsigned} {{/testbench/uut/bpu/bht[79]} -radix unsigned} {{/testbench/uut/bpu/bht[78]} -radix unsigned} {{/testbench/uut/bpu/bht[77]} -radix unsigned} {{/testbench/uut/bpu/bht[76]} -radix unsigned} {{/testbench/uut/bpu/bht[75]} -radix unsigned} {{/testbench/uut/bpu/bht[74]} -radix unsigned} {{/testbench/uut/bpu/bht[73]} -radix unsigned} {{/testbench/uut/bpu/bht[72]} -radix unsigned} {{/testbench/uut/bpu/bht[71]} -radix unsigned} {{/testbench/uut/bpu/bht[70]} -radix unsigned} {{/testbench/uut/bpu/bht[69]} -radix unsigned} {{/testbench/uut/bpu/bht[68]} -radix unsigned} {{/testbench/uut/bpu/bht[67]} -radix unsigned} {{/testbench/uut/bpu/bht[66]} -radix unsigned} {{/testbench/uut/bpu/bht[65]} -radix unsigned} {{/testbench/uut/bpu/bht[64]} -radix unsigned} {{/testbench/uut/bpu/bht[63]} -radix unsigned} {{/testbench/uut/bpu/bht[62]} -radix unsigned} {{/testbench/uut/bpu/bht[61]} -radix unsigned} {{/testbench/uut/bpu/bht[60]} -radix unsigned} {{/testbench/uut/bpu/bht[59]} -radix unsigned} {{/testbench/uut/bpu/bht[58]} -radix unsigned} {{/testbench/uut/bpu/bht[57]} -radix unsigned} {{/testbench/uut/bpu/bht[56]} -radix unsigned} {{/testbench/uut/bpu/bht[55]} -radix unsigned} {{/testbench/uut/bpu/bht[54]} -radix unsigned} {{/testbench/uut/bpu/bht[53]} -radix unsigned} {{/testbench/uut/bpu/bht[52]} -radix unsigned} {{/testbench/uut/bpu/bht[51]} -radix unsigned} {{/testbench/uut/bpu/bht[50]} -radix unsigned} {{/testbench/uut/bpu/bht[49]} -radix unsigned} {{/testbench/uut/bpu/bht[48]} -radix unsigned} {{/testbench/uut/bpu/bht[47]} -radix unsigned} {{/testbench/uut/bpu/bht[46]} -radix unsigned} {{/testbench/uut/bpu/bht[45]} -radix unsigned} {{/testbench/uut/bpu/bht[44]} -radix unsigned} {{/testbench/uut/bpu/bht[43]} -radix unsigned} {{/testbench/uut/bpu/bht[42]} -radix unsigned} {{/testbench/uut/bpu/bht[41]} -radix unsigned} {{/testbench/uut/bpu/bht[40]} -radix unsigned} {{/testbench/uut/bpu/bht[39]} -radix unsigned} {{/testbench/uut/bpu/bht[38]} -radix unsigned} {{/testbench/uut/bpu/bht[37]} -radix unsigned} {{/testbench/uut/bpu/bht[36]} -radix unsigned} {{/testbench/uut/bpu/bht[35]} -radix unsigned} {{/testbench/uut/bpu/bht[34]} -radix unsigned} {{/testbench/uut/bpu/bht[33]} -radix unsigned} {{/testbench/uut/bpu/bht[32]} -radix unsigned} {{/testbench/uut/bpu/bht[31]} -radix unsigned} {{/testbench/uut/bpu/bht[30]} -radix unsigned} {{/testbench/uut/bpu/bht[29]} -radix unsigned} {{/testbench/uut/bpu/bht[28]} -radix unsigned} {{/testbench/uut/bpu/bht[27]} -radix unsigned} {{/testbench/uut/bpu/bht[26]} -radix unsigned} {{/testbench/uut/bpu/bht[25]} -radix unsigned} {{/testbench/uut/bpu/bht[24]} -radix unsigned} {{/testbench/uut/bpu/bht[23]} -radix unsigned} {{/testbench/uut/bpu/bht[22]} -radix unsigned} {{/testbench/uut/bpu/bht[21]} -radix unsigned} {{/testbench/uut/bpu/bht[20]} -radix unsigned} {{/testbench/uut/bpu/bht[19]} -radix unsigned} {{/testbench/uut/bpu/bht[18]} -radix unsigned} {{/testbench/uut/bpu/bht[17]} -radix unsigned} {{/testbench/uut/bpu/bht[16]} -radix unsigned} {{/testbench/uut/bpu/bht[15]} -radix unsigned} {{/testbench/uut/bpu/bht[14]} -radix unsigned} {{/testbench/uut/bpu/bht[13]} -radix unsigned} {{/testbench/uut/bpu/bht[12]} -radix unsigned} {{/testbench/uut/bpu/bht[11]} -radix unsigned} {{/testbench/uut/bpu/bht[10]} -radix unsigned} {{/testbench/uut/bpu/bht[9]} -radix unsigned} {{/testbench/uut/bpu/bht[8]} -radix unsigned} {{/testbench/uut/bpu/bht[7]} -radix unsigned} {{/testbench/uut/bpu/bht[6]} -radix unsigned} {{/testbench/uut/bpu/bht[5]} -radix unsigned} {{/testbench/uut/bpu/bht[4]} -radix unsigned} {{/testbench/uut/bpu/bht[3]} -radix unsigned} {{/testbench/uut/bpu/bht[2]} -radix unsigned} {{/testbench/uut/bpu/bht[1]} -radix unsigned} {{/testbench/uut/bpu/bht[0]} -radix unsigned}} -expand -subitemconfig {{/testbench/uut/bpu/bht[255]} {-radix unsigned} {/testbench/uut/bpu/bht[254]} {-radix unsigned} {/testbench/uut/bpu/bht[253]} {-radix unsigned} {/testbench/uut/bpu/bht[252]} {-radix unsigned} {/testbench/uut/bpu/bht[251]} {-radix unsigned} {/testbench/uut/bpu/bht[250]} {-radix unsigned} {/testbench/uut/bpu/bht[249]} {-radix unsigned} {/testbench/uut/bpu/bht[248]} {-radix unsigned} {/testbench/uut/bpu/bht[247]} {-radix unsigned} {/testbench/uut/bpu/bht[246]} {-radix unsigned} {/testbench/uut/bpu/bht[245]} {-radix unsigned} {/testbench/uut/bpu/bht[244]} {-radix unsigned} {/testbench/uut/bpu/bht[243]} {-radix unsigned} {/testbench/uut/bpu/bht[242]} {-radix unsigned} {/testbench/uut/bpu/bht[241]} {-radix unsigned} {/testbench/uut/bpu/bht[240]} {-radix unsigned} {/testbench/uut/bpu/bht[239]} {-radix unsigned} {/testbench/uut/bpu/bht[238]} {-radix unsigned} {/testbench/uut/bpu/bht[237]} {-radix unsigned} {/testbench/uut/bpu/bht[236]} {-radix unsigned} {/testbench/uut/bpu/bht[235]} {-radix unsigned} {/testbench/uut/bpu/bht[234]} {-radix unsigned} {/testbench/uut/bpu/bht[233]} {-radix unsigned} {/testbench/uut/bpu/bht[232]} {-radix unsigned} {/testbench/uut/bpu/bht[231]} {-radix unsigned} {/testbench/uut/bpu/bht[230]} {-radix unsigned} {/testbench/uut/bpu/bht[229]} {-radix unsigned} {/testbench/uut/bpu/bht[228]} {-radix unsigned} {/testbench/uut/bpu/bht[227]} {-radix unsigned} {/testbench/uut/bpu/bht[226]} {-radix unsigned} {/testbench/uut/bpu/bht[225]} {-radix unsigned} {/testbench/uut/bpu/bht[224]} {-radix unsigned} {/testbench/uut/bpu/bht[223]} {-radix unsigned} {/testbench/uut/bpu/bht[222]} {-radix unsigned} {/testbench/uut/bpu/bht[221]} {-radix unsigned} {/testbench/uut/bpu/bht[220]} {-radix unsigned} {/testbench/uut/bpu/bht[219]} {-radix unsigned} {/testbench/uut/bpu/bht[218]} {-radix unsigned} {/testbench/uut/bpu/bht[217]} {-radix unsigned} {/testbench/uut/bpu/bht[216]} {-radix unsigned} {/testbench/uut/bpu/bht[215]} {-radix unsigned} {/testbench/uut/bpu/bht[214]} {-radix unsigned} {/testbench/uut/bpu/bht[213]} {-radix unsigned} {/testbench/uut/bpu/bht[212]} {-radix unsigned} {/testbench/uut/bpu/bht[211]} {-radix unsigned} {/testbench/uut/bpu/bht[210]} {-radix unsigned} {/testbench/uut/bpu/bht[209]} {-radix unsigned} {/testbench/uut/bpu/bht[208]} {-radix unsigned} {/testbench/uut/bpu/bht[207]} {-radix unsigned} {/testbench/uut/bpu/bht[206]} {-radix unsigned} {/testbench/uut/bpu/bht[205]} {-radix unsigned} {/testbench/uut/bpu/bht[204]} {-radix unsigned} {/testbench/uut/bpu/bht[203]} {-radix unsigned} {/testbench/uut/bpu/bht[202]} {-radix unsigned} {/testbench/uut/bpu/bht[201]} {-radix unsigned} {/testbench/uut/bpu/bht[200]} {-radix unsigned} {/testbench/uut/bpu/bht[199]} {-radix unsigned} {/testbench/uut/bpu/bht[198]} {-radix unsigned} {/testbench/uut/bpu/bht[197]} {-radix unsigned} {/testbench/uut/bpu/bht[196]} {-radix unsigned} {/testbench/uut/bpu/bht[195]} {-radix unsigned} {/testbench/uut/bpu/bht[194]} {-radix unsigned} {/testbench/uut/bpu/bht[193]} {-radix unsigned} {/testbench/uut/bpu/bht[192]} {-radix unsigned} {/testbench/uut/bpu/bht[191]} {-radix unsigned} {/testbench/uut/bpu/bht[190]} {-radix unsigned} {/testbench/uut/bpu/bht[189]} {-radix unsigned} {/testbench/uut/bpu/bht[188]} {-radix unsigned} {/testbench/uut/bpu/bht[187]} {-radix unsigned} {/testbench/uut/bpu/bht[186]} {-radix unsigned} {/testbench/uut/bpu/bht[185]} {-radix unsigned} {/testbench/uut/bpu/bht[184]} {-radix unsigned} {/testbench/uut/bpu/bht[183]} {-radix unsigned} {/testbench/uut/bpu/bht[182]} {-radix unsigned} {/testbench/uut/bpu/bht[181]} {-radix unsigned} {/testbench/uut/bpu/bht[180]} {-radix unsigned} {/testbench/uut/bpu/bht[179]} {-radix unsigned} {/testbench/uut/bpu/bht[178]} {-radix unsigned} {/testbench/uut/bpu/bht[177]} {-radix unsigned} {/testbench/uut/bpu/bht[176]} {-radix unsigned} {/testbench/uut/bpu/bht[175]} {-radix unsigned} {/testbench/uut/bpu/bht[174]} {-radix unsigned} {/testbench/uut/bpu/bht[173]} {-radix unsigned} {/testbench/uut/bpu/bht[172]} {-radix unsigned} {/testbench/uut/bpu/bht[171]} {-radix unsigned} {/testbench/uut/bpu/bht[170]} {-radix unsigned} {/testbench/uut/bpu/bht[169]} {-radix unsigned} {/testbench/uut/bpu/bht[168]} {-radix unsigned} {/testbench/uut/bpu/bht[167]} {-radix unsigned} {/testbench/uut/bpu/bht[166]} {-radix unsigned} {/testbench/uut/bpu/bht[165]} {-radix unsigned} {/testbench/uut/bpu/bht[164]} {-radix unsigned} {/testbench/uut/bpu/bht[163]} {-radix unsigned} {/testbench/uut/bpu/bht[162]} {-radix unsigned} {/testbench/uut/bpu/bht[161]} {-radix unsigned} {/testbench/uut/bpu/bht[160]} {-radix unsigned} {/testbench/uut/bpu/bht[159]} {-radix unsigned} {/testbench/uut/bpu/bht[158]} {-radix unsigned} {/testbench/uut/bpu/bht[157]} {-radix unsigned} {/testbench/uut/bpu/bht[156]} {-radix unsigned} {/testbench/uut/bpu/bht[155]} {-radix unsigned} {/testbench/uut/bpu/bht[154]} {-radix unsigned} {/testbench/uut/bpu/bht[153]} {-radix unsigned} {/testbench/uut/bpu/bht[152]} {-radix unsigned} {/testbench/uut/bpu/bht[151]} {-radix unsigned} {/testbench/uut/bpu/bht[150]} {-radix unsigned} {/testbench/uut/bpu/bht[149]} {-radix unsigned} {/testbench/uut/bpu/bht[148]} {-radix unsigned} {/testbench/uut/bpu/bht[147]} {-radix unsigned} {/testbench/uut/bpu/bht[146]} {-radix unsigned} {/testbench/uut/bpu/bht[145]} {-radix unsigned} {/testbench/uut/bpu/bht[144]} {-radix unsigned} {/testbench/uut/bpu/bht[143]} {-radix unsigned} {/testbench/uut/bpu/bht[142]} {-radix unsigned} {/testbench/uut/bpu/bht[141]} {-radix unsigned} {/testbench/uut/bpu/bht[140]} {-radix unsigned} {/testbench/uut/bpu/bht[139]} {-radix unsigned} {/testbench/uut/bpu/bht[138]} {-radix unsigned} {/testbench/uut/bpu/bht[137]} {-radix unsigned} {/testbench/uut/bpu/bht[136]} {-radix unsigned} {/testbench/uut/bpu/bht[135]} {-radix unsigned} {/testbench/uut/bpu/bht[134]} {-radix unsigned} {/testbench/uut/bpu/bht[133]} {-radix unsigned} {/testbench/uut/bpu/bht[132]} {-radix unsigned} {/testbench/uut/bpu/bht[131]} {-radix unsigned} {/testbench/uut/bpu/bht[130]} {-radix unsigned} {/testbench/uut/bpu/bht[129]} {-radix unsigned} {/testbench/uut/bpu/bht[128]} {-radix unsigned} {/testbench/uut/bpu/bht[127]} {-radix unsigned} {/testbench/uut/bpu/bht[126]} {-radix unsigned} {/testbench/uut/bpu/bht[125]} {-radix unsigned} {/testbench/uut/bpu/bht[124]} {-radix unsigned} {/testbench/uut/bpu/bht[123]} {-radix unsigned} {/testbench/uut/bpu/bht[122]} {-radix unsigned} {/testbench/uut/bpu/bht[121]} {-radix unsigned} {/testbench/uut/bpu/bht[120]} {-radix unsigned} {/testbench/uut/bpu/bht[119]} {-radix unsigned} {/testbench/uut/bpu/bht[118]} {-radix unsigned} {/testbench/uut/bpu/bht[117]} {-radix unsigned} {/testbench/uut/bpu/bht[116]} {-radix unsigned} {/testbench/uut/bpu/bht[115]} {-radix unsigned} {/testbench/uut/bpu/bht[114]} {-radix unsigned} {/testbench/uut/bpu/bht[113]} {-radix unsigned} {/testbench/uut/bpu/bht[112]} {-radix unsigned} {/testbench/uut/bpu/bht[111]} {-radix unsigned} {/testbench/uut/bpu/bht[110]} {-radix unsigned} {/testbench/uut/bpu/bht[109]} {-radix unsigned} {/testbench/uut/bpu/bht[108]} {-radix unsigned} {/testbench/uut/bpu/bht[107]} {-radix unsigned} {/testbench/uut/bpu/bht[106]} {-radix unsigned} {/testbench/uut/bpu/bht[105]} {-radix unsigned} {/testbench/uut/bpu/bht[104]} {-radix unsigned} {/testbench/uut/bpu/bht[103]} {-radix unsigned} {/testbench/uut/bpu/bht[102]} {-radix unsigned} {/testbench/uut/bpu/bht[101]} {-radix unsigned} {/testbench/uut/bpu/bht[100]} {-radix unsigned} {/testbench/uut/bpu/bht[99]} {-radix unsigned} {/testbench/uut/bpu/bht[98]} {-radix unsigned} {/testbench/uut/bpu/bht[97]} {-radix unsigned} {/testbench/uut/bpu/bht[96]} {-radix unsigned} {/testbench/uut/bpu/bht[95]} {-radix unsigned} {/testbench/uut/bpu/bht[94]} {-radix unsigned} {/testbench/uut/bpu/bht[93]} {-radix unsigned} {/testbench/uut/bpu/bht[92]} {-radix unsigned} {/testbench/uut/bpu/bht[91]} {-radix unsigned} {/testbench/uut/bpu/bht[90]} {-radix unsigned} {/testbench/uut/bpu/bht[89]} {-radix unsigned} {/testbench/uut/bpu/bht[88]} {-radix unsigned} {/testbench/uut/bpu/bht[87]} {-radix unsigned} {/testbench/uut/bpu/bht[86]} {-radix unsigned} {/testbench/uut/bpu/bht[85]} {-radix unsigned} {/testbench/uut/bpu/bht[84]} {-radix unsigned} {/testbench/uut/bpu/bht[83]} {-radix unsigned} {/testbench/uut/bpu/bht[82]} {-radix unsigned} {/testbench/uut/bpu/bht[81]} {-radix unsigned} {/testbench/uut/bpu/bht[80]} {-radix unsigned} {/testbench/uut/bpu/bht[79]} {-radix unsigned} {/testbench/uut/bpu/bht[78]} {-radix unsigned} {/testbench/uut/bpu/bht[77]} {-radix unsigned} {/testbench/uut/bpu/bht[76]} {-radix unsigned} {/testbench/uut/bpu/bht[75]} {-radix unsigned} {/testbench/uut/bpu/bht[74]} {-radix unsigned} {/testbench/uut/bpu/bht[73]} {-radix unsigned} {/testbench/uut/bpu/bht[72]} {-radix unsigned} {/testbench/uut/bpu/bht[71]} {-radix unsigned} {/testbench/uut/bpu/bht[70]} {-radix unsigned} {/testbench/uut/bpu/bht[69]} {-radix unsigned} {/testbench/uut/bpu/bht[68]} {-radix unsigned} {/testbench/uut/bpu/bht[67]} {-radix unsigned} {/testbench/uut/bpu/bht[66]} {-radix unsigned} {/testbench/uut/bpu/bht[65]} {-radix unsigned} {/testbench/uut/bpu/bht[64]} {-radix unsigned} {/testbench/uut/bpu/bht[63]} {-radix unsigned} {/testbench/uut/bpu/bht[62]} {-radix unsigned} {/testbench/uut/bpu/bht[61]} {-radix unsigned} {/testbench/uut/bpu/bht[60]} {-radix unsigned} {/testbench/uut/bpu/bht[59]} {-radix unsigned} {/testbench/uut/bpu/bht[58]} {-radix unsigned} {/testbench/uut/bpu/bht[57]} {-radix unsigned} {/testbench/uut/bpu/bht[56]} {-radix unsigned} {/testbench/uut/bpu/bht[55]} {-radix unsigned} {/testbench/uut/bpu/bht[54]} {-radix unsigned} {/testbench/uut/bpu/bht[53]} {-radix unsigned} {/testbench/uut/bpu/bht[52]} {-radix unsigned} {/testbench/uut/bpu/bht[51]} {-radix unsigned} {/testbench/uut/bpu/bht[50]} {-radix unsigned} {/testbench/uut/bpu/bht[49]} {-radix unsigned} {/testbench/uut/bpu/bht[48]} {-radix unsigned} {/testbench/uut/bpu/bht[47]} {-radix unsigned} {/testbench/uut/bpu/bht[46]} {-radix unsigned} {/testbench/uut/bpu/bht[45]} {-radix unsigned} {/testbench/uut/bpu/bht[44]} {-radix unsigned} {/testbench/uut/bpu/bht[43]} {-radix unsigned} {/testbench/uut/bpu/bht[42]} {-radix unsigned} {/testbench/uut/bpu/bht[41]} {-radix unsigned} {/testbench/uut/bpu/bht[40]} {-radix unsigned} {/testbench/uut/bpu/bht[39]} {-radix unsigned} {/testbench/uut/bpu/bht[38]} {-radix unsigned} {/testbench/uut/bpu/bht[37]} {-radix unsigned} {/testbench/uut/bpu/bht[36]} {-radix unsigned} {/testbench/uut/bpu/bht[35]} {-radix unsigned} {/testbench/uut/bpu/bht[34]} {-radix unsigned} {/testbench/uut/bpu/bht[33]} {-radix unsigned} {/testbench/uut/bpu/bht[32]} {-radix unsigned} {/testbench/uut/bpu/bht[31]} {-radix unsigned} {/testbench/uut/bpu/bht[30]} {-radix unsigned} {/testbench/uut/bpu/bht[29]} {-radix unsigned} {/testbench/uut/bpu/bht[28]} {-radix unsigned} {/testbench/uut/bpu/bht[27]} {-radix unsigned} {/testbench/uut/bpu/bht[26]} {-radix unsigned} {/testbench/uut/bpu/bht[25]} {-radix unsigned} {/testbench/uut/bpu/bht[24]} {-radix unsigned} {/testbench/uut/bpu/bht[23]} {-radix unsigned} {/testbench/uut/bpu/bht[22]} {-radix unsigned} {/testbench/uut/bpu/bht[21]} {-radix unsigned} {/testbench/uut/bpu/bht[20]} {-radix unsigned} {/testbench/uut/bpu/bht[19]} {-radix unsigned} {/testbench/uut/bpu/bht[18]} {-radix unsigned} {/testbench/uut/bpu/bht[17]} {-radix unsigned} {/testbench/uut/bpu/bht[16]} {-radix unsigned} {/testbench/uut/bpu/bht[15]} {-radix unsigned} {/testbench/uut/bpu/bht[14]} {-radix unsigned} {/testbench/uut/bpu/bht[13]} {-radix unsigned} {/testbench/uut/bpu/bht[12]} {-radix unsigned} {/testbench/uut/bpu/bht[11]} {-radix unsigned} {/testbench/uut/bpu/bht[10]} {-radix unsigned} {/testbench/uut/bpu/bht[9]} {-radix unsigned} {/testbench/uut/bpu/bht[8]} {-radix unsigned} {/testbench/uut/bpu/bht[7]} {-radix unsigned} {/testbench/uut/bpu/bht[6]} {-radix unsigned} {/testbench/uut/bpu/bht[5]} {-radix unsigned} {/testbench/uut/bpu/bht[4]} {-radix unsigned} {/testbench/uut/bpu/bht[3]} {-radix unsigned} {/testbench/uut/bpu/bht[2]} {-radix unsigned} {/testbench/uut/bpu/bht[1]} {-radix unsigned} {/testbench/uut/bpu/bht[0]} {-radix unsigned}} /testbench/uut/bpu/bht
add wave -noupdate -radix unsigned /testbench/uut/pcF_inst1
add wave -noupdate -radix unsigned /testbench/uut/pcF_inst2
add wave -noupdate -radix unsigned /testbench/uut/pcD
add wave -noupdate -radix unsigned /testbench/uut/pcD_inst2
add wave -noupdate -radix unsigned /testbench/uut/pc_EX
add wave -noupdate -radix unsigned /testbench/uut/pcE_inst2
add wave -noupdate /testbench/uut/stallFinal
add wave -noupdate -radix unsigned -childformat {{{/testbench/uut/RF/registers[31]} -radix unsigned} {{/testbench/uut/RF/registers[30]} -radix unsigned} {{/testbench/uut/RF/registers[29]} -radix unsigned} {{/testbench/uut/RF/registers[28]} -radix unsigned} {{/testbench/uut/RF/registers[27]} -radix unsigned} {{/testbench/uut/RF/registers[26]} -radix unsigned} {{/testbench/uut/RF/registers[25]} -radix unsigned} {{/testbench/uut/RF/registers[24]} -radix unsigned} {{/testbench/uut/RF/registers[23]} -radix unsigned} {{/testbench/uut/RF/registers[22]} -radix unsigned} {{/testbench/uut/RF/registers[21]} -radix unsigned} {{/testbench/uut/RF/registers[20]} -radix unsigned} {{/testbench/uut/RF/registers[19]} -radix unsigned} {{/testbench/uut/RF/registers[18]} -radix unsigned} {{/testbench/uut/RF/registers[17]} -radix unsigned} {{/testbench/uut/RF/registers[16]} -radix unsigned} {{/testbench/uut/RF/registers[15]} -radix unsigned} {{/testbench/uut/RF/registers[14]} -radix unsigned} {{/testbench/uut/RF/registers[13]} -radix unsigned} {{/testbench/uut/RF/registers[12]} -radix unsigned} {{/testbench/uut/RF/registers[11]} -radix unsigned} {{/testbench/uut/RF/registers[10]} -radix unsigned} {{/testbench/uut/RF/registers[9]} -radix unsigned} {{/testbench/uut/RF/registers[8]} -radix unsigned} {{/testbench/uut/RF/registers[7]} -radix unsigned} {{/testbench/uut/RF/registers[6]} -radix unsigned} {{/testbench/uut/RF/registers[5]} -radix unsigned} {{/testbench/uut/RF/registers[4]} -radix unsigned} {{/testbench/uut/RF/registers[3]} -radix unsigned} {{/testbench/uut/RF/registers[2]} -radix unsigned} {{/testbench/uut/RF/registers[1]} -radix unsigned} {{/testbench/uut/RF/registers[0]} -radix unsigned}} -expand -subitemconfig {{/testbench/uut/RF/registers[31]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[30]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[29]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[28]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[27]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[26]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[25]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[24]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[23]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[22]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[21]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[20]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[19]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[18]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[17]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[16]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[15]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[14]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[13]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[12]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[11]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[10]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[9]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[8]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[7]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[6]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[5]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[4]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[3]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[2]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[1]} {-height 15 -radix unsigned} {/testbench/uut/RF/registers[0]} {-height 15 -radix unsigned}} /testbench/uut/RF/registers
add wave -noupdate /testbench/uut/predictionF_1
add wave -noupdate /testbench/uut/predictionF_2
add wave -noupdate /testbench/uut/branchF1
add wave -noupdate /testbench/uut/branchF2
add wave -noupdate -radix unsigned /testbench/uut/pcBranchF_pipe
add wave -noupdate -radix unsigned /testbench/uut/pcPlus1F
add wave -noupdate -radix unsigned /testbench/uut/pcPlus2F
add wave -noupdate -radix unsigned /testbench/uut/pcBranchF
add wave -noupdate -radix unsigned /testbench/uut/pcBranchF_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Decode
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Decode
add wave -noupdate /testbench/uut/flush_F_1
add wave -noupdate /testbench/uut/flush_F_2
add wave -noupdate /testbench/uut/flush_D_1
add wave -noupdate /testbench/uut/flush_D_2
add wave -noupdate /testbench/uut/flush_E_2
add wave -noupdate -divider RF
add wave -noupdate /testbench/uut/actual_outcome_inst1
add wave -noupdate /testbench/uut/actual_outcome_inst2
add wave -noupdate -radix unsigned /testbench/uut/PC
add wave -noupdate -radix unsigned /testbench/uut/Memory_Read_Data_inst1
add wave -noupdate -radix unsigned /testbench/uut/Memory_Read_Data_inst2
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[24]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[14]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[9]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[16]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[13]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[4]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[5]}
add wave -noupdate -divider PC
add wave -noupdate -radix unsigned /testbench/uut/pcF_inst1_pipe
add wave -noupdate -radix unsigned /testbench/uut/pcF_inst2_pipe
add wave -noupdate /testbench/uut/switchy
add wave -noupdate /testbench/uut/stall_inner
add wave -noupdate /testbench/uut/wrongPrediction_1
add wave -noupdate /testbench/uut/wrongPrediction_2
add wave -noupdate /testbench/uut/predictionF_1_pipe
add wave -noupdate /testbench/uut/predictionF_2_pipe
add wave -noupdate /testbench/uut/predictionD_1
add wave -noupdate /testbench/uut/predictionD_2
add wave -noupdate /testbench/uut/prediction_EX_1
add wave -noupdate /testbench/uut/prediction_EX_2
add wave -noupdate /testbench/uut/equal_inst1
add wave -noupdate /testbench/uut/equal_inst2
add wave -noupdate /testbench/uut/outer_depend
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_WB
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_WB
add wave -noupdate -divider prediction
add wave -noupdate /testbench/uut/predictionF_1
add wave -noupdate /testbench/uut/predictionF_2
add wave -noupdate -divider {FORWARDING UNIT}
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst2
add wave -noupdate /testbench/uut/FU/forwardA_inst1
add wave -noupdate /testbench/uut/FU/forwardB_inst1
add wave -noupdate /testbench/uut/FU/forwardA_inst2
add wave -noupdate /testbench/uut/FU/forwardB_inst2
add wave -noupdate -divider <NULL>
add wave -noupdate -radix unsigned /testbench/uut/ALU_1/op1
add wave -noupdate -radix unsigned /testbench/uut/ALU_1/op2
add wave -noupdate -radix unsigned /testbench/uut/ALU_1/result
add wave -noupdate -divider {ALU 2}
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/result
add wave -noupdate /testbench/uut/RegWriteEn_inst1_WB
add wave -noupdate /testbench/uut/RegWriteEn_inst2_WB
add wave -noupdate /testbench/uut/RegWriteEn_inst1_EX
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1
add wave -noupdate /testbench/uut/MemtoReg_inst1_Mem
add wave -noupdate /testbench/uut/RegWriteEn_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/pcBranch_EX_inst1
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[22]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[1]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[25]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[24]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[23]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[31]}
add wave -noupdate /testbench/uut/opcode_inst2
add wave -noupdate -divider instuctions
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst1_Decode
add wave -noupdate -radix hexadecimal /testbench/uut/FETCH_DECODE1_PIPE/inst2_Decode
add wave -noupdate -divider RF
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[14]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[10]}
add wave -noupdate -radix unsigned {/testbench/uut/RF/registers[9]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[4]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[5]}
add wave -noupdate -divider PC
add wave -noupdate -radix decimal /testbench/uut/PC
add wave -noupdate -radix decimal /testbench/uut/pcD
add wave -noupdate /testbench/uut/switchy
add wave -noupdate -radix unsigned /testbench/uut/pc_EX
add wave -noupdate /testbench/uut/stall_inner
add wave -noupdate /testbench/uut/outer_depend
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst1_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/selected_inst2_Fetch
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutExecute_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst1
add wave -noupdate -radix hexadecimal /testbench/uut/AluOutMem_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_Mem
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst1_WB
add wave -noupdate -radix unsigned /testbench/uut/dest_reg_inst2_WB
add wave -noupdate /testbench/uut/flush_F_1
add wave -noupdate /testbench/uut/flush_F_2
add wave -noupdate /testbench/uut/flush_D_1
add wave -noupdate /testbench/uut/flush_D_2
add wave -noupdate /testbench/uut/flush_E_2
add wave -noupdate -divider prediction
add wave -noupdate /testbench/uut/equal_inst1
add wave -noupdate /testbench/uut/equal_inst2
add wave -noupdate /testbench/uut/xnorOut_1
add wave -noupdate /testbench/uut/xnorOut_2
add wave -noupdate -divider {FORWARDING UNIT}
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rd_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst1
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst1
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_mem_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rd_WB_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rs_EX_inst2
add wave -noupdate -radix unsigned /testbench/uut/FU/Rt_EX_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_mem_inst2
add wave -noupdate /testbench/uut/FU/RegWrite_WB_inst2
add wave -noupdate /testbench/uut/FU/forwardA_inst1
add wave -noupdate /testbench/uut/FU/forwardB_inst1
add wave -noupdate /testbench/uut/FU/forwardA_inst2
add wave -noupdate /testbench/uut/FU/forwardB_inst2
add wave -noupdate -divider <NULL>
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_1/result
add wave -noupdate -divider {ALU 2}
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op1
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/op2
add wave -noupdate -radix hexadecimal /testbench/uut/ALU_2/result
add wave -noupdate /testbench/uut/RegWriteEn_inst1_EX
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/writeData_inst1
add wave -noupdate /testbench/uut/MemtoReg_inst1_Mem
add wave -noupdate /testbench/uut/RegWriteEn_inst1_Mem
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst1
add wave -noupdate /testbench/uut/RF/WriteEnable_inst2
add wave -noupdate -radix hexadecimal /testbench/uut/RF/writeData_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst1
add wave -noupdate -radix unsigned /testbench/uut/Rs_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/Rt_D_inst2
add wave -noupdate -radix unsigned /testbench/uut/pcBranch_EX_inst1
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[22]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[1]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[25]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[23]}
add wave -noupdate -radix hexadecimal {/testbench/uut/RF/registers[31]}
add wave -noupdate /testbench/uut/opcode_inst2
add wave -noupdate /testbench/uut/predictionF_2_pipe
add wave -noupdate /testbench/uut/outer_depend
add wave -noupdate /testbench/uut/Branch_inst2_EX
add wave -noupdate /testbench/uut/Branch_inst1_EX
add wave -noupdate /testbench/uut/PCsrc_inst1_D
add wave -noupdate /testbench/uut/PCsrc_inst2_D
add wave -noupdate /testbench/uut/stallFinal
add wave -noupdate /testbench/uut/FETCH_DECODE1_PIPE/stall_outer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4748340 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 312
configure wave -valuecolwidth 78
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {30890714 ps} {31009962 ps}
