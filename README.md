# mips-cpu
Verilog implementation of a MIPS-R2000 CPU, based on the concept in [this book](<https://www.elsevier.com/books/computer-organization-and-design-mips-edition/patterson/978-0-12-407726-3>)

# Currently supported instructions:

``` lw sw lui  ``` 

 ```add addu addiu ```

 ```sub subu ```

 ```and or ori ```

 ```beq bne j  ```

 ```sll srl ```

 ```slt slti ```

# Features

- Implemented in the 5-stage pipeline scheme.

- Branch or jump instructions are handled in ID stage. 
- Full data forwarding, include forwarding to ID stage for branch instructions. 
- Hazard detection and stall. 

## Usage

- Compile & Simulate

  ``` make clean && make ```

- Analyse Data

  ``` make scansion``` or ``` make gtkwave ```

  Or using other tool to view the ```vcd``` file

  Log can be find in ```MIPS_R2000_tb_log.txt```

  [MIPS instructions simulator can be download from here](<http://courses.missouristate.edu/KenVollmar/mars/>)

