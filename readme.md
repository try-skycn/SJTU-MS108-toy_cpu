# MIPS CPU

This repository is a five-stage pipelined CPU based on MIPS instruction set (without implementation of exception reducing and coprocessors, see [this page](https://www.d.umn.edu/~gshute/mips/instruction-coding.xhtml)) written in Verilog HDL.

## Automatic top-level file generator

为了连线时的避免麻烦，我设计了一个利用注释自动生成顶层文件的编译器。

创建对应的顶层文件`toplevel-source.v`，在需要写入module的实例的位置，添加注释`compile module modulename`，例如

```
module toplevel(
	input	wire	clk,
	input	wire	rst
);

/*
	compile module bottom_level_0
	compile module bottom_level_1
*/

endmodule
```

并在Verilog源代码文件的input/output行后，写上相应注释

```
module bottom_level_0(
	input	wire	clk,		//= clk
	input	wire	rst,		//= rst
	input	wire	stall,	//= bottom_level_1::stall
	output	wire	result	//= final_result
);

/*
	Explanation:
		Comment '//=' after 'input' will be interpreted
			as input to that data port.
		Example:
				input	wire	clk //= clk
		will be interpreted as
				.clk(clk)
			
		Comment '//=' after 'output' will be interpreted
			as output from that data port, and the compiler
			would automatically create a 'wire' on the
			top-level module with the same name.
		Example:
				output	wire	result	//= finalresult
			will be interpreted as
				wire	top_level_result
			and
				.result(final_result)
		
		Words with double colon 'ModuleName::portName' will be
			interpreted as the top-level wire connected with the
			output port 'portName' of 'ModuleName'.
		Example:
				input	wire	data_input	//= bottom_level_0::result
			will be interpreted as
				.data_input(final_result)
				
*/

endmodule
```
运行

	python3 ./autowire/comp.py toplevel-source.v DIR > toplevel.v

即可获得编译后的文件，其中`DIR`为`module`所在的文件夹。

## Test

Test files and simulation (functional) results are under folder `./benchmark`.


