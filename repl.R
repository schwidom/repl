# Author: Frank Schwidom, 
# Version: 2012_10_09
# LICENSE: GPLv3

# an read-eval-print-loop, which can be applied to an environment

repl= function(
 replEnvir= parent.frame(),
 replPrompt= "repl > ",
 replEnd="EOF",
 replHelp="HELP",
 replAway="AWAY",
 replNoHelp=FALSE,
 replUseWithin=FALSE,
 replRollback="ROLLBACK",
 replCommit="COMMIT",
 replHistory=FALSE,
 replDummy=NULL # syntax-dummy
 )
{

 if( replHistory)
 {
  histFileOld= tempfile()
  histFileNew= tempfile()
  savehistory( histFileOld)

 }

 retEnvir= NULL

 rollback= function() retEnvir <<- replEnvir
 commit= function() replEnvir <<- retEnvir

 rollback() # Ausgangssituation

 if( replNoHelp){ away= 0;}
 else away=NULL;

 fHelp= function()
 {
  cat( paste( 'type', replEnd, 'for repl-end\n'))
  cat( paste( 'type', replHelp, 'for this\n'))
  cat( paste( 'type', replAway, '<number> for supressing the help for a number of inputlines ( <=0 forever)\n'))
  cat( paste( 'type', replRollback, 'in replUseWithin=TRUE mode, if you want to set to an old rollback point\n'))
  cat( paste( 'type', replCommit, 'in replUseWithin=TRUE mode, if you want to set an new rollback point\n'))
 }

 fHelp()

 while( TRUE)
 {
  
  if( is.null( away))
   prm= replPrompt
  else
   prm= paste( away, replPrompt)

  rodline <- readline( prompt= prm)

  if( replHistory)
  {
   histFileNewCon= file( histFileNew, "a")
   writeLines( rodline, histFileNewCon)
   close( histFileNewCon)
   loadhistory( histFileNew)
  }

  grogoxpr= gregexpr( '^\\w+', rodline)
  

  if( is.null( away) && 'list' == typeof( grogoxpr))
  {
   cmd= substring( rodline, grogoxpr[[1]][[1]], grogoxpr[[1]][[1]]- 1+ attr( grogoxpr[[1]], 'match.length')[[1]])

   #print( paste( 'cmd', cmd))
   
   cmds= c( replEnd, replHelp, replAway, replRollback, replCommit) == cmd

   isCommand= any( cmds)

   if( cmds[[1]])
   {
    cat( paste( 'exiting repl with prompt:', paste( '"', replPrompt, '"', sep=''), '\n'))
    break; # while
   }

   if( cmds[[2]]) fHelp();

   if( cmds[[3]])
   {
    grogoxpr2= gregexpr( '\\w+', rodline)
    #print( grogoxpr2)
    #print( grogoxpr2[[1]])
    if( length( grogoxpr2[[1]]) != 2)
    {
     cat( paste( 'error: Argument', replAway, 'needs 1 number'))
    }
    else
    {
     num= substring( rodline, grogoxpr2[[1]][[2]], grogoxpr2[[1]][[2]]- 1+ attr( grogoxpr2[[1]], 'match.length')[[2]])
     #print( num)
     away= as.numeric( num)
    }
   }

   if( cmds[[4]]) rollback()
   if( cmds[[5]]) commit()

  }
  else
   isCommand= FALSE


  if( isCommand)
  {
   
  }
  else
  {
   #res= try( eval( parse( text=rodline), envir=replEnvir), silent=TRUE)
   if( replUseWithin)
   {
    res= try(
    {
     callStr= parse( text= rodline)
     retEnvir= within( retEnvir, eval( callStr))
    })
    rm( callStr)
   }
   else
    res= try( eval( parse( text= rodline), envir=retEnvir), silent=TRUE)

   print( res)
   cat( '\n')
  }

  if( !is.null( away))
  {
   if( away > 1)
    away= away - 1
   else if( away > 0)
    away= NULL
  }
  
 }

 if( replHistory)
  loadhistory( histFileOld)

 retEnvir
}


