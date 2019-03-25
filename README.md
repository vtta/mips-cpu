# mips-cpu
Verilog implementation of a MIPS-R2000 CPU, based on the concept in [this book](<https://www.elsevier.com/books/computer-organization-and-design-mips-edition/patterson/978-0-12-407726-3>)

Currently supported instructions:

​	``` lw sw addu subu ori beq lui sll srl bne j slt slti and or ```



## Usage

- Compile & Simulate

  ``` make clean && make ```

- Analyse Data

  ``` make scansion``` or ``` make gtkwave ```

  Or using other tool to view the ```vcd``` file

  Log can be find in ```MIPS_R2000_tb_log.txt```

  [MIPS instructions simulator can be download from here](<http://courses.missouristate.edu/KenVollmar/mars/>)

