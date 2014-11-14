library(SPARQL)
library(benford.analysis)
library(ggplot2)

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
  require(grid)
  
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

###################
# 1. Data retrieval
###################
# We retrieve observations from an endpoint that contains RDF Data Cube data

# query parameters
gender <- "F"
years <- c(1830, 1840, 1849, 1859, 1869,  1879, 1889, 1899, 1909, 1920, 1930, 1971)
census <- "VT"

# initialize plot space
dfs <- list(rep(NA, length(years)))

# prepare RDF data query
endpoint <- "http://lod.cedar-project.nl/cedar/sparql"

sparql_prefix <- 
"prefix qb: <http://purl.org/linked-data/cube#>
prefix cedar: <http://lod.cedar-project.nl:8888/cedar/resource/>
prefix maritalstatus: <http://bit.ly/cedar-maritalstatus#>
prefix sdmx-dimension: <http://purl.org/linked-data/sdmx/2009/dimension#>
prefix sdmx-code: <http://purl.org/linked-data/sdmx/2009/code#>
prefix cedarterms: <http://bit.ly/cedar#>"

for (i in 1:length(years)) {
  query <- paste(sparql_prefix, sprintf("select * from <urn:graph:cedar:release> where {
    ?obs a qb:Observation.
    ?obs cedarterms:population ?pop.
    ?obs sdmx-dimension:sex sdmx-code:sex-%s .
    ?obs sdmx-dimension:refArea ?muni .
    ?slice a qb:Slice.
    ?slice qb:observation ?obs.
    ?slice sdmx-dimension:refPeriod \"%s\"^^xsd:integer .
    ?slice cedarterms:censusType \"%s\" .
  } limit 1000", gender, years[i], census))
  res <- SPARQL(endpoint,query)$results
  dfs[[i]] <- res
}

#########
# 3. Plot
#########
plots <- list(rep(NA, length(years)))
for (i in 1:length(years)) {
  plot <- ggplot(dfs[[i]], aes(x=pop))
  plot <- plot + geom_density()
  plot <- plot + ggtitle(years[i])
  plots[[i]] <- plot  
}

multiplot(plotlist=plots, cols=2)
