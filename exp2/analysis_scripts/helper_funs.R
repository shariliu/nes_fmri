# Custom Functions

## Retrieved from : http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/#error-bars-for-within-subjects-variables
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <-
  function(data = NULL,
           measurevar,
           groupvars = NULL,
           na.rm = FALSE,
           conf.interval = .95,
           .drop = TRUE) {
    library(plyr)
    
    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm = FALSE) {
      if (na.rm)
        sum(!is.na(x))
      else
        length(x)
    }
    
    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(
      data,
      groupvars,
      .drop = .drop,
      .fun = function(xx, col) {
        c(
          N    = length2(xx[[col]], na.rm = na.rm),
          mean = mean   (xx[[col]], na.rm = na.rm),
          sd   = sd     (xx[[col]], na.rm = na.rm)
        )
      },
      measurevar
    )
    
    # Rename the "mean" column
    datac <- plyr::rename(datac, c("mean" = measurevar))
    
    datac$se <-
      datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
    
    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval:
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval / 2 + .5, datac$N - 1)
    datac$ci <- datac$se * ciMult
    
    return(datac)
  }
## Norms the data within specified groups in a data frame; it normalizes each
## subject (identified by idvar) so that they have the same mean, within each group
## specified by betweenvars.
##   data: a data frame.
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   na.rm: a boolean that indicates whether to ignore NA's
normDataWithin <-
  function(data = NULL,
           idvar,
           measurevar,
           betweenvars = NULL,
           na.rm = FALSE,
           .drop = TRUE) {
    library(plyr)
    
    # Measure var on left, idvar + between vars on right of formula.
    data.subjMean <- ddply(
      data,
      c(idvar, betweenvars),
      .drop = .drop,
      .fun = function(xx, col, na.rm) {
        c(subjMean = mean(xx[, col], na.rm = na.rm))
      },
      measurevar,
      na.rm
    )
    
    # Put the subject means with original data
    data <- merge(data, data.subjMean)
    
    # Get the normalized data in a new column
    measureNormedVar <- paste(measurevar, "_norm", sep = "")
    data[, measureNormedVar] <-
      data[, measurevar] - data[, "subjMean"] +
      mean(data[, measurevar], na.rm = na.rm)
    
    # Remove this subject mean column
    data$subjMean <- NULL
    
    return(data)
  }

## Summarizes data, handling within-subjects variables by removing inter-subject variability.
## It will still work if there are no within-S variables.
## Gives count, un-normed mean, normed mean (with same between-group mean),
##   standard deviation, standard error of the mean, and confidence interval.
## If there are within-subject variables, calculate adjusted values using method from Morey (2008).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   withinvars: a vector containing names of columns that are within-subjects variables
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySEwithin <-
  function(data = NULL,
           measurevar,
           betweenvars = NULL,
           withinvars = NULL,
           idvar = NULL,
           na.rm = FALSE,
           conf.interval = .95,
           .drop = TRUE) {
    # Ensure that the betweenvars and withinvars are factors
    factorvars <-
      vapply(data[, c(betweenvars, withinvars), drop = FALSE],
             FUN = is.factor, FUN.VALUE = logical(1))
    
    if (!all(factorvars)) {
      nonfactorvars <- names(factorvars)[!factorvars]
      message(
        "Automatically converting the following non-factors to factors: ",
        paste(nonfactorvars, collapse = ", ")
      )
      data[nonfactorvars] <- lapply(data[nonfactorvars], factor)
    }
    
    # Get the means from the un-normed data
    datac <-
      summarySE(
        data,
        measurevar,
        groupvars = c(betweenvars, withinvars),
        na.rm = na.rm,
        conf.interval = conf.interval,
        .drop = .drop
      )
    
    # Drop all the unused columns (these will be calculated with normed data)
    datac$sd <- NULL
    datac$se <- NULL
    datac$ci <- NULL
    
    # Norm each subject's data
    ndata <-
      normDataWithin(data, idvar, measurevar, betweenvars, na.rm, .drop = .drop)
    
    # This is the name of the new column
    measurevar_n <- paste(measurevar, "_norm", sep = "")
    
    # Collapse the normed data - now we can treat between and within vars the same
    ndatac <-
      summarySE(
        ndata,
        measurevar_n,
        groupvars = c(betweenvars, withinvars),
        na.rm = na.rm,
        conf.interval = conf.interval,
        .drop = .drop
      )
    
    # Apply correction from Morey (2008) to the standard error and confidence interval
    #  Get the product of the number of conditions of within-S variables
    nWithinGroups    <-
      prod(vapply(ndatac[, withinvars, drop = FALSE], FUN = nlevels,
                  FUN.VALUE = numeric(1)))
    correctionFactor <- sqrt(nWithinGroups / (nWithinGroups - 1))
    
    # Apply the correction factor
    ndatac$sd <- ndatac$sd * correctionFactor
    ndatac$se <- ndatac$se * correctionFactor
    ndatac$ci <- ndatac$ci * correctionFactor
    
    # Combine the un-normed means with the normed results
    merge(datac, ndatac)
  }


## load required packages
ipak <- function (pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg))
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

rotate <- function(x)
  t(apply(x, 2, rev))
relev <- function(f)
  relevel(factor(f), ref = "within")

# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor = (cormat)[ut]
  )
}

# function that returns column of standardized betas from lmer model
gen.beta <- function(model) {
  df <- data.frame(fixef(model))
  names(df) <- c("beta")
  return(df)
}

# function that computes CIs and returns them in df
gen.ci <- function(model) {
  df <- data.frame(confint.merMod(model))
  names(df) <- c("CI_95_lower", "CI_95_upper")
  return(df)
}

# function that converts model summary (lmer) to df
gen.m <- function(model) {
  df <- data.frame(coef(summary(model)))
  names(df) <- c("B", "SE", "df", "t", "p")
  return(df)
}

# function that converts model summary (lm) to df
gen.lm <- function(model) {
  df <- data.frame(coef(summary(model)))
  names(df) <- c("b", "se", "t", "p")
  return(df)
}

# function that returns formatted result from lme4/lmerTest table
report <- function(table, places, tails, flip) {
  if (tails == "1") {
    p <- round(table$p, places) / 2
    howmanytails <- "one-tailed"
  } else {
    p <- round(table$p, places)
    howmanytails <- "two-tailed"
  }
  if (p < .001) {
    p <- "<.001"
  } else {
    p <- paste("=", round(p, places), sep = "")
  }
  if (missing(flip)) {
    result <-
      paste(
        "[",
        round(table$CI_95_lower, places),
        ",",
        round(table$CI_95_upper, places),
        "], B=",
        round(table$B, places),
        ", p",
        p,
        ", ",
        howmanytails,
        ", d = ",
        round(table$d, places),
        ", BF = ",
        round(table$BF, places),
        sep = ""
      )
  } else {
    result <-
      paste(
        "[",
        -round(table$CI_95_upper, places),
        ",",
        -round(table$CI_95_lower, places),
        "], B=",
        -round(table$B, places),
        ", p",
        p,
        ", ",
        howmanytails,
        ", d = ",
        round(table$d, places),
        ", BF = ",
        round(table$BF, places),
        sep = ""
      )
  }
  return(result)
}

# function that returns formatted result from lsmeans (e.g. breaking down an interaction)
report_contrasts <- function(table, places, tails, flip) {
  if (tails == "1") {
    p <- round(table$p.value, places) / 2
    howmanytails <- "one-tailed"
  } else {
    p <- round(table$p.value, places)
    howmanytails <- "two-tailed"
  }
  if (p < .001) {
    p <- "<.001"
  } else {
    p <- paste(round(p, places), sep = "")
  }
  if (missing(flip)) {
    result <-
      paste("B = ",
            round(table$estimate, places),
            ", p = ",
            p,
            ", ",
            howmanytails,
            sep = "")
  }
  return(result)
}

# function that returns formatted result from lsmeans (e.g. breaking down an interaction)
report_MVPA <- function(table, places) {
  p <- round(table$p, places)
  howmanytails <- "one-tailed"
  if (p < .001) {
    p <- "<.001"
  } else {
    p <- paste("= ", round(p, places), sep = "")
  }
  result <-
    paste("V = ",
          round(table$V, places),
          ", p ",
          p,
          ", ",
          howmanytails,
          ", r = ",
          round(table$r, places),
          sep = "")
  return(result)
}

report_manyregions <- function(observed, effect, places) {
  if (effect == "event_within_domain") {
    cor <- observed %>% select(cor_event_within_domain) %>% as.numeric()
    p <- observed %>% select(p_event_within_domain) %>% as.numeric()
  } else if (effect == "domain_within_event") {
    cor <- observed %>% select(cor_domain_within_event) %>% as.numeric()
    p <-
      observed %>% select(p_domain_within_event) %>% as.numeric()
  }
  
  if (p < .001) {
    p <- "< .001"
  } else {
    p <- paste("= ", round(p, places), sep = "")
  }
  
  result <- paste("r = ",
                  round(cor, places),
                  ", p ",
                  p,
                  sep = "")
  
  return(result)
  
}

se <- function(x, na.rm = FALSE) {
  if (na.rm)
    x <- na.omit(x)
  return(sd(x) / sqrt(length(x)))
}