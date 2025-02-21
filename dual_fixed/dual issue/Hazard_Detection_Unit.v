module Hazard_Detection_Unit (
input prediction_1,
input prediction_2,
input actual_prediction_1,
input actual_prediction_2,
input BranchExecute_1,
input BranchExecute_2,
input PcSource_inst1,
input PcSource_inst2,
input nullifyJump,
input Jump_D1_inst1,
input Jump_D1_inst2,
input Jump_D2_inst1,
input Jump_D2_inst2,
output reg flush1_B,
output reg flush2_B,
output reg flush1_J,
output reg flush2_J,
output reg flush1_JR,
output reg flush2_JR,
output reg flush_JB,
output reg wrongPrediction_1,
output reg wrongPrediction_2,
output reg NewpcSource_inst2,
output reg NewJump_inst2
);

//b--> 1 & 2
//jb
// j --> 1 & 2
//jr--> 1 & 2
reg RightPrediction_1;
	always @(*)
	begin
	  flush1_B = 0;
	  flush2_B = 0;
	  flush1_J = 0;
	  flush2_J = 0;
	  flush1_JR = 0;
	  flush2_JR = 0;
	  flush_JB = 0;
	  NewpcSource_inst2 = 0;
	  NewJump_inst2 = 0;
	//flushes
		 // Branch caused flush
					wrongPrediction_1 = ((prediction_1!=actual_prediction_1)& BranchExecute_1);
						 flush1_B=wrongPrediction_1;
					wrongPrediction_2 = ((prediction_2!=actual_prediction_2)& BranchExecute_2);
						 flush2_B=wrongPrediction_2;

    //jump after branch caused flush
        // this is @ execute stage 
        //actual_prediction_1 = 0, not taken prediction
            // -> i do wanna execute the jump aka flush
            // (DO I WANT TO JUMP)
            flush_JB= ~actual_prediction_1 && nullifyJump; 
        //fix jump signals aka , do the jump 
        if (flush_JB)
        begin 
           // these new cntrl signals ar inputs for EX/MEM pipe for inst 1 
           //????????????????????????????????????????// maybe input for everyting in inst 2 instead ???
            NewpcSource_inst2=1; 
            NewJump_inst2=1; 
           
        end
    // jump alone caused flush
        // if jump inst occurs ---> flush 
        // if in future that changes , just modify this condition
            flush1_J= PcSource_inst1 && Jump_D1_inst1; 
            flush2_J= PcSource_inst2 && Jump_D1_inst2;
    //jump register caused flush 
            flush1_JR= PcSource_inst1 && ~Jump_D2_inst1; 
            flush2_JR= PcSource_inst2 && ~Jump_D2_inst2;     
//stalls
 // stalls for pipe d1/d2 and pipe if/d1 are direct inpus from outputsof inner and outer dep checks    
    end
endmodule 


//for jr jump = 0 
//pc source for all jumps=1