library(ggplot2)

## Simulate exponential distribution
simulation <- function(number, lambda, times) {
        mean.s <- NULL
        var.s <- NULL
        for (i in 1:times) {
                value.s <- rexp(number, lambda)
                mean.s <- c(mean.s, mean(value.s)) 
                var.s <- c(var.s, var(value.s))
        }
        df <- data.frame(mean.s, var.s)
        df
}

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
        library(grid)
        
        # Make a list from the ... arguments and plotlist
        plots <- c(list(...), plotlist)
        
        numPlots = length(plots)
        
        # If layout is NULL, then use 'cols' to determine layout
        if (is.null(layout)) {
                # Make the panel
                # ncol: Number of columns of plots
                # nrow: Number of rows needed, calculated from # of cols
                layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                                 ncol = cols, nrow = ceiling(numPlots/cols))
        }
        
        if (numPlots==1) {
                print(plots[[1]])
                
        } else {
                # Set up the page
                grid.newpage()
                pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
                
                # Make each plot, in the correct location
                for (i in 1:numPlots) {
                        # Get the i,j matrix positions of the regions that contain this subplot
                        matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
                        
                        print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                                        layout.pos.col = matchidx$col))
                }
        }
}
shinyServer (
        function(input, output) { 
                result <- eventReactive(input$startButton, {
                        simulation(input$in.number, input$in.lambda, input$in.times)
                })
                output$out.parameters <- eventReactive(input$startButton, {
                        paste('n = ', isolate(input$in.number), ', lambda = ', isolate(input$in.lambda), ' and t = ', isolate(input$in.times), sep = '')
                })
                
                output$out.th.mean <- eventReactive(input$startButton, {
                        paste('Theoretical Mean: E[X] = ', 1/isolate(input$in.lambda), sep='')
                })
                
                output$out.th.var <- eventReactive(input$startButton, {
                        paste('Theoretical Variance: Var[X] = ', 1/isolate(input$in.lambda)^2, sep='')
                })
                
                output$out.lambda <- renderText({
                        input$startButton
                        isolate(input$in.lambda)
                })
                
                output$out.times <- renderText({
                        input$startButton
                        isolate(input$in.times)
                })
                
                output$plot <- renderPlot({
                        mean.g <- ggplot(result(), aes(x=mean.s)) +
                                geom_histogram(alpha = .20, binwidth=0.2, color = "black", fill = "blue", aes(y = ..density..)) +
                                geom_vline(aes(xintercept=mean(mean.s, na.rm=T)),color="red", linetype="dashed", size=1) + 
                                labs(x = "X") + 
                                labs(title = "Distribution of Mean of n exponential numbers") + 
                                theme(text = element_text(size=9))
                        
                        var.g <- ggplot(result(), aes(x=var.s)) +
                                geom_histogram(alpha = .20, binwidth=2, colour = "black", fill = "green", aes(y = ..density..)) +
                                geom_vline(aes(xintercept=mean(var.s, na.rm=T)),color="red", linetype="dashed", size=1) +
                                labs(x = "X") + 
                                labs(title = "Distribution of Variance of n exponential numbers") + 
                                theme(text = element_text(size=9))                        
                        multiplot(mean.g, var.g, cols = 2)     
                })
                
        })