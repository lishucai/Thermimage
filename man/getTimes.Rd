\name{getTimes}
\alias{getTimes}
\title{
Extracts time values as POSIX from binary imported thermal video file
}
\description{
Extracts time values for each image frame from a thermal camera video file (.seq or .fcf).  For time lapse or video capture, computer time is stored for each image frame in 3 byte chunks, denoting msec, sec, and date information.  
}
\usage{
getTimes(vidfile, headstarts, timestart = 448, byte.length = 2)
}
\arguments{
  \item{vidfile}{
Filename or filepath (as character) of the thermal video.  Should end in .seq or .fcf.  Not tested comprehensively so it may only work for certain camera models and software packages.
}
\item{headstarts}{
A vector of integers corresponding to the header read byte start positions in the thermal video file.  Acquired using the getFrames function.  The header information is where the (width, height) image information, as well as information on the camera, calibration, time of image capture, etc...are stored.  
}
  \item{timestart}{
Set to 448 by default.  Once the header start location has been determined with the frameLocates function, the frame times were stored in 448 bytes into the header.  The user does not need to set this.
}
  \item{byte.length}{
Set to 2 by default.  Each pixel information is encoded in two bytes (i.e. 16 bit), leading to an integer value ranging from 1 to 2^16. Pixel data are read in order in the file and converted to integer using the readBin function. User does not need to set this.
}

}
\details{
Somewhat empirically determined, but also information provided on the exiftool website below describes where time stamp information is stored in each file.  This function concatentates the 3 time stamps corresponding to msec, sec, and date into one POSIX variable that gives the actual time each image was captured.

As written, this is a vectorised function, so to extract multiple frames of data (i.e. length(headstarts)>1), use a loop or the apply function as shown in the example below. 

Extracted times are used in sumamrising information about the temperature profiles of the thermal videos and can be passed to the cumulDiff function.  

Extracted times can also be used to verify the frame rate of the image capture in the video.  

Has not been fully tested on file types from all cameras or thermal imaging software.

}
\value{
Returns a vector of times (POSIXct) corresponding to the frame capture times as extracted from the thermal video file.
}
\references{
1. http://www.sno.phy.queensu.ca/~phil/exiftool/

2. http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/FLIR.html

3. http://www.silisoftware.com/tools/date.php

4. http://www.sandersonforensics.com/forum/content.php?131-A-brief-history-of-time-stamps
}
\author{
Glenn J Tattersall
}

\seealso{
\code{\link{getFrames}},
\code{\link{frameLocates}},
\code{\link{cumulDiff}}
}
\examples{

f<-system.file("extdata", "SampleSEQ.seq", package = "Thermimage")
x<-frameLocates(f)
getTimes(f, x$h.start)

# only returns the first frame of data, must use lapply to get all frames
# POSIX type data do not play well with lists, so try the following:

# Using lapply
extract.times<-do.call("c", lapply(x$h.start, getTimes, vidfile=f))
extract.times

# Using parallel lapply:
library(parallel)
# set mc.cores to higher number to use parallel processing:
extract.times<-do.call("c", mclapply(x$h.start, getTimes, vidfile=f, byte.length=2,
timestart=448, mc.cores=1))
extract.times

}
