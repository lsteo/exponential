shinyUI (
        pageWithSidebar (
                headerPanel("Exponential Distribution"),
                
                sidebarPanel (
                        sliderInput("in.number", "Number of Exponential number (n)",
                                    min=1, max=100, value=10),
                        sliderInput("in.lambda", "Lambda value:", 
                                    min=0.1, max=1, value=0.2, step = 0.1),
                        sliderInput("in.times", "Number of simulations (t):", 
                                    min = 1, max = 1000, value = 100),
                        actionButton("startButton", "Start!"),
                        
                        HTML('<br/><br/>This application shows the exponential
                             distribution by simulating <i><b>n</b></i> exponential number 
                             over <i><b>t</b></i> number of simulations using lambda value. 
                             The results will show the distribution of the mean 
                             and variance value. For more details, please refer to the <a href=" http://lsteo.github.io/exponential">slides</a>.')
                ),
                mainPanel (
                        h3('Results:'),
                        textOutput("out.parameters"),
                        HTML('<br/>'),
                        textOutput("out.th.mean"),
                        HTML('<br/>'),
                        textOutput("out.th.var"),
                        plotOutput("plot")
                        
                )
        )
)