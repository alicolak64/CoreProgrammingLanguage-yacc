# "Core" Programming Language

*Group Members*:
- [Ali Çolak](https://github.com/alicolak64)
- [İsmail Şengül](https://github.com/ismailsengul)
- [Emre Eldemir](https://github.com/emreeldemir)

---

### Description:

In the world of computer programming, we are a group of brilliant young developers who are frustrated with the limitations of existing programming languages. We long for a language that is simple, elegant, and powerful, one that will allow us to express our ideas in a way that is both efficient and intuitive.

So, we set out to create our own programming language, spending countless hours brainstorming, coding, testing, and refining our creation. We call it **"Core"** with the **".core"** extension.

The name "Core" was not chosen lightly. It is a nod to the heart of computing, the central processing unit (CPU), which is often referred to as the "core" of a computer. The CPU is responsible for executing instructions and performing calculations at the heart of every computer system.

We see our language, Core, as a kind of "core" for programming. It is designed to be the foundation upon which all other software can be built. It is meant to be simple enough for beginners to learn.

As stated in the instruction, we have defined terminal values ​​such as characters, integers, floating point numbers, text, true/false (boolean) operators,  functions and conditional expressions as well as constants and variables, included basic input/output (IO) expressions.

While designing our language, we got help and inspiration from many languages such as C/C++. In Core Language, all programs start with the keyword *"RUN"* and end with the keyword *"FINISH"*. Our language is a procedural language and programs consist of if, while, for etc. similar structures and for this reason, things work in our language by calling the procedures.


We have defined a data type that we will use for numeric data with INT_TYPE and named it **"intel"**. We have carefully and in detail prepared the language syntax definition and the expressions that will appear on the printouts. We created our comment line style inspired by **"SML/NJ"**. (* comment block/line *)

---

First, we test a function that sums the values of two variables of the "float" and "intel" data types. The function returns "float" as its return value.

Our second program checks the numbers from 0 to 10 in a loop and prints the result according to their odd and even condition.

In another program, we check whether the 3 numbers are equal to each other.

In general, we have a ready-made sample program file that contains programs similar to the ones we have written, where you can check many syntax cases.

<br>


### Running Instructions:

> make core

> ./core < example.core

...( some output )...

> make clean

### Syntax in BNF Form:

```

\<program\> : \<startStatement\> <statements> <endStatement>

\<statements\> : \<statement\> <statements> | \<statement\>

\<statement\> : \<printStatement\> SEMICOLON 
                | <assignmentStatement> SEMICOLON
                | <ifStatement> 
                | <whileStatement> 
                | <endStatement> 
                | <startStatement> 
                | <commentStatement>

<term> : NUMBER
        | IDENTIFIER

<stringTerm> : STRING
              | IDENTIFIER

<expression> : <term>
              | <expression> PLUS <expression>
              | <expression> MINUS <expression>
              | <expression> MULTIPLY <expression>              
              | <expression> DIVIDE <expression>
              | <expression> MOD <expression>
              | <expression> EQUAL <expression>
              | <expression> NOTEQUAL <expression>
              | <expression> LESS <expression>
              | <expression> LESSEQUAL <expression>
              | <expression> GREATER <expression>
              | <expression> GREATEREQUAL <expression>
              | <expression> AND <expression>
              | <expression> OR <expression>
              | NOT <expression>
              | LPAREN <expression> RPAREN

<block> : LBRACE <statements> RBRACE

<printStatement> : PRINT LPAREN <stringTerm> RPAREN
                  | PRINT LPAREN <expression> RPAREN

<assignmentStatement> : IDENTIFIER ASSIGN <expression>
                       | IDENTIFIER ASSIGN <stringTerm>

<ifStatement> : IF LPAREN <expression> RPAREN <block>
               | IF LPAREN <expression> RPAREN <block> ELSE <block>
               | IF LPAREN <expression> RPAREN <block> <elseIfStatement> LPAREN <expression> RPAREN <block>
               | IF LPAREN <expression> RPAREN <block> <elseIfStatement> LPAREN <expression> RPAREN <block> ELSE <block>

<elseIfStatement> : ELSEIF LPAREN <expression> RPAREN <block>
                   | ELSEIF LPAREN <expression> RPAREN <block> <elseIfStatement>

<whileStatement> : WHILE LPAREN <expression> RPAREN <block>

<startStatement> : START

<endStatement> : END

<commentStatement> : COMMENT
           
