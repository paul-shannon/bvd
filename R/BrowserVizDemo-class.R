library (httpuv)
library (methods)
#----------------------------------------------------------------------------------------------------
browserVizDemoBrowserFile <- system.file(package="BrowserVizDemo", "scripts", "browserVizDemo.html")
#----------------------------------------------------------------------------------------------------
.BrowserVizDemo <- setClass ("BrowserVizDemoClass", 
                            representation = representation (),
                            contains = "BrowserVizClass",
                            prototype = prototype (uri="http://localhost", 9000)
                            )

#----------------------------------------------------------------------------------------------------
setGeneric ('plot',  signature='obj', function (obj, x, y) standardGeneric ('plot'))
setGeneric ('getSelection',  signature='obj', function (obj) standardGeneric ('getSelection'))
#----------------------------------------------------------------------------------------------------
setupMessageHandlers <- function()
{
   addRMessageHandler("handleResponse", "handleResponse")

} # setupMessageHandlers
#----------------------------------------------------------------------------------------------------
# constructor
BrowserVizDemo = function(portRange, host="localhost", title="BrowserVizDemo", quiet=TRUE)
{
  .BrowserVizDemo(BrowserViz(portRange, host, title, quiet, browserFile=browserVizDemoBrowserFile))

} # BrowserVizDemo: constructor
#----------------------------------------------------------------------------------------------------
setMethod('plot', 'BrowserVizDemoClass',

  function (obj, x, y) {
     xMin <- min(x)
     xMax <- max(x)
     yMin <- min(y)
     yMax <- max(y)
     send(obj, list(cmd="plotxy", callback="handleResponse", status="request",
                    payload=list(x=x, y=y, xMin=xMin, xMax=xMax, yMin=yMin, yMax=yMax)))
     while (!browserResponseReady(obj)){
        if(!obj@quiet) message(sprintf("plot waiting for browser response"));
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
setMethod('getSelection', 'BrowserVizDemoClass',

  function (obj) {
     send(obj, list(cmd="getSelection", callback="handleResponse", status="request", payload=""))
     while (!browserResponseReady(obj)){
        if(!obj@quiet) message(sprintf("getSelection waiting for browser response"));
        Sys.sleep(.1)
        }
     getBrowserResponse(obj)
     })

#----------------------------------------------------------------------------------------------------
