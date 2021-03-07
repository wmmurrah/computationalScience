#Callixte Nahimana
#R Tutorial 4 Answers
cat("R Tutorial 4 Answers\n")
#------------QRQ1a
#a.
runif(1,min=10,max=100)
#b
runif(5,min=-3,max=3)
#c
matrix(runif(8,min=8 ,max=12 ),nrow=2)
#------------QRQ2
#a
floor(runif(6,min=1,max=6))
#b
floor(runif(20,min=18,max=22))
#------------QRQ3
#a
matrix(runif(100,10,100),ncol=10)
matrix(runif(100,10,100),ncol=10)
matrix(runif(100,10,100),ncol=10)
#b
set.seed(1234)
matrix(runif(100,10,100),ncol=10)
set.seed(1234)
matrix(runif(100,10,100),ncol=10)
set.seed(1234)
matrix(runif(100,10,100),ncol=10)
matrix(runif(100,10,100),ncol=10)

#------------QRQ4
r=10
r = (7*r)%%11
#------------QRQ5

if(runif(1)<0.3)
{
1
}else{
0
      }

#------------QRQ6
r=runif(1)
if(r<0.2)
{
cat("Low\n")      
}else{
if(r<0.5){
cat("Medium Low\n")
         }else{
if(r<0.8){cat("Medium High\n")

	  }   else{
	cat("High\n")
	
	          }
	      }
      }
#------------QRQ7
lst=runif(20)
#//lst
lest4=sum(lst<0.4)
lest4
gret6=sum(lst>=0.6)
gret6
#------------QRQ8
floor(runif(20,min=0,max=5))
lstt =floor(runif(20,min=0,max=5))
lstt
sum(floor(runif(20,min=0,max=5))==3)
#-------------------QRQ9
normalNums = rnorm(10000)
mean(normalNums)
sd(normalNums)
cat("They don't really match but they are close enough\n")
#cat("The function std says that is not working\n")
#-------------------QRQ9
sinTbl=sin(rnorm(1000,0,pi))
hist(sinTbl)
hist(sinTbl,breaks=10)
cat("The interval for last category is: [0.90,1)\n")
cat("The estimate is: [0.90,0.91,0.92,0.93,0.94,0.95,0.96,0.97,0.98,0.99,1)\n")
