repl
====

read eval print loop for R environments

This is an very simple repl (Read-Eval-Print-Loop)
for R-environments and R-datatypes. This repl can
currently not handle expressions, which exceed 1 line.
But it allows to set up commands inside of an
R-environment or inside of an list like R-datatype.
This way the repl can manipulate the environment or
the datatype step by step in the given context.

It also possible, to run the repl inside of an deep
called function for debugging or inspecting purposes.
If it is not really clear, which variables lead to an
specific behaviour, then this ambiguous function can 
be inspected by running repl inside of it.
