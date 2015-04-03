library(RUnit)
library(BrowserVizDemo)
#--------------------------------------------------------------------------------
runTests <- function()
{
  testConstructor();
  testWindowTitle()
  testPlot()
  
} # runTests
#--------------------------------------------------------------------------------
testConstructor <- function()
{
   print("--- testConstructor")
   app <- BrowserVizDemo(quiet=FALSE, port=8000);
   checkTrue(ready(app))
   checkEquals(port(app), 8000)
   closeWebSocket(app)
   checkTrue(!ready(app))
   
} # testConstructor
#--------------------------------------------------------------------------------
testWindowTitle <- function()
{
   print("--- testWindowTitle")
   app <- BrowserVizDemo(8000)
   checkTrue(ready(app))
   checkEquals(getBrowserWindowTitle(app), "BrowserVizDemo")
   setBrowserWindowTitle(app, "new title");
   checkEquals(getBrowserWindowTitle(app), "new title")
   closeWebSocket(app)

} # testWindowTitle
#--------------------------------------------------------------------------------
testPlot <- function()
{
   print("--- testPlot")
   app <- BrowserVizDemo(port=8000);
   checkTrue(ready(app))

   title <- "simple xy plot test";
   setBrowserWindowTitle(app, title)
   checkEquals(getBrowserWindowTitle(app), title)

   checkEquals(getSelection(app), list())

   plot(app, 1:10, (1:10)^2)
     # without direct manipulation of the plotted surface, there will still
     # be no selections

   checkEquals(getSelection(app), list())
   closeWebSocket(app)

} # testPlot
#--------------------------------------------------------------------------------
