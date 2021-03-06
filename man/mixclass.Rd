\name{mixclass}
\alias{mixclass}

\title{An example function from the book Cichosz, P. (2015): Data Mining Algorithms: Explained Using R}

\description{An example function from Chapter 7 of the book Cichosz, P. (2015): Data Mining Algorithms: Explained Using R. See Appendix B or http://www.wiley.com/go/data_mining_algorithms for more details.}

\usage{See Section 7.2, Example 7.2.13.}

\arguments{See Section 7.2, Example 7.2.13.}

\details{See Section 7.2, Example 7.2.13.}

\value{See Section 7.2, Example 7.2.13.}

\references{Cichosz, P. (2015): Data Mining Algorithms: Explained Using R. Wiley.}

\author{
Pawel Cichosz <p.cichosz@elka.pw.edu.pl>
}

\note{
}


\seealso{
\code{\link{cutclass}}
\code{\link{roc}}
}

\examples{
library(rpart)
library(dmr.util)
data(Soybean, package="mlbench")

s01.labels <- c("other", "brown-spot")
Soybean01 <- Soybean
Soybean01$Class <- factor(ifelse(Soybean$Class=="brown-spot", "brown-spot", "other"),
                          levels=s01.labels)
set.seed(12)
rs <- runif(nrow(Soybean))
s01.train <- Soybean01[rs>=0.33,]
s01.test <- Soybean01[rs<0.33,]
s01.tree <- rpart(Class~., s01.train)

s01.roc <- roc(predict(s01.tree, s01.test)[,2], s01.test$Class)
s01.cm <- confmat(predict(s01.tree, s01.test, type="c"), s01.test$Class)

  # shift to achieve tpr>0.85 at minimum fpr
s01.t085 <- roc.shift(s01.roc, min.tpr=0.85)
s01.cm.t085 <- confmat(cutclass(predict(s01.tree, s01.test)[,2], s01.t085, s01.labels),
                         s01.test$Class)
  # shift to achieve maximum tpr at fpr<0.5
s01.f05 <- roc.shift(s01.roc, max.fpr=0.5)
s01.cm.f05 <- confmat(cutclass(predict(s01.tree, s01.test)[,2], s01.f05, s01.labels),
                        s01.test$Class)

  # interpolate between the two shifted operating points
s01.mix <- mixclass(cutclass(predict(s01.tree, s01.test)[,2], s01.t085, s01.labels),
                    cutclass(predict(s01.tree, s01.test)[,2], s01.f05, s01.labels),
                    0.75)
s01.cmi <- confmat(s01.mix, s01.test$Class)

  # the ROC curve
plot(s01.roc$fpr, s01.roc$tpr, type="l", col="blue", xlab="FP rate", ylab="TP rate")
  # the default operating point
points(fpr(s01.cm), tpr(s01.cm), col="red")
  # the 1st shifted operating point
points(fpr(s01.cm.t085), tpr(s01.cm.t085), col="green1")
  # the 2nd shifted operating point
points(fpr(s01.cm.f05), tpr(s01.cm.f05), col="green1")
  # the interpolated operating point
points(fpr(s01.cmi), tpr(s01.cmi), col="green3")
}

\keyword{arith}
\keyword{models}
