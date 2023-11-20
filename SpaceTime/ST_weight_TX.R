library(spdep)
T=25 ## months
N=254 ##49 US states
#V=T*N
SW<-read.gal("Tx_CntyBndry_Jurisdictional_TIGER_sorted.gal",override.id=TRUE) #need to set override.id = True

#Check out the features and parameters of the new read.gal function with
#the help(read.gal) command. You will see that there are three parameters: the name of the input file, a region.id and an override.id. The
#main purpose of these parameters is to avoid having to assume that the data
#set (the data frame) and the weights file have their observations in the same
#order. In GeoDa, the ID variable creates a key that can be matched with
#a corresponding variable in a data set to ensure the correct order. This is
#not an issue when both the data set and the weights are created together by
#GeoDa, as you just did, but it can be a problem when this is not the case.
#For our purposes, it will suffice to set the override.id = TRUE, rather
#than the default FALSE to force spdep to use the new GeoDa GAL weights
#format.

swmat<-nb2mat(SW, glist=NULL, style="W")
swmat[swmat>0]<-1


Cs<-swmat
It<-diag(T)
Is<-diag(N)
Ct<-matrix(1, nrow = T, ncol = T)-It

######Zeroing some entries of matrix parallel to matrix diagonal########
zero.them<-function(x, n){
  x2<-x
  diag(x)<-0
  for(i in 1:n){
    diag(x[,(-1:-i)])<-0
    diag(x[(-1:-i),])<-0
    }
  x2[which(x==x2)] <- 0
  return(x2)
}
Ct<-zero.them(Ct, 1)

##########space-time contemporaneous specification####################
##########based on equation 3.1 Griffth and Paelinck (2018)###########
#########Note that only immediate preceding and succeeding are considered here######
Cst1<-kronecker(It,Cs) + kronecker(Ct,Is)
dim(Cst1)
#Cst1<-mat2listw(Cst1, style="B")
write.table(Cst1, file = "Cstcontem.csv", sep=",",  col.names=FALSE, row.names=FALSE)

##########space-time lagged specification#############################
##########based on equation 3.1 Griffth and Paelinck (2018)###########
#########Note that only immediate preceding and succeeding are considered here######

Cst2<-kronecker(Ct,Cs) + kronecker(Ct,Is)
dim(Cst2)
#Cst2<-mat2listw(Cst2, style="B")
write.table(Cst2, file = "Cstlag.csv", sep=",", col.names=FALSE,row.names=FALSE)


##########space-time lagged and contemporaneous specification#############################
#########Note that only immediate preceding and succeeding cells are considered here######

Cst3<-kronecker(Ct,Cs) + kronecker(Ct,Is)+ kronecker(It,Cs)
dim(Cst3)
#Cst3<-mat2listw(Cst3, style="B")
write.table(Cst3, file = "Cstlag_contemp.csv", sep=",", col.names=FALSE,row.names=FALSE)

############################one-way specification#####################################
#####################space-time lagged and contemporaneous matrix#####################
#################Note that only immediate preceding cells are considered here#########
Ct1<-Ct
Ct1[upper.tri(Ct1)] <- 0
Cst4<-kronecker(Ct1,Cs) + kronecker(Ct1,Is)+ kronecker(It,Cs)
dim(Cst4)
#Cst4<-mat2listw(Cst4, style="B")
write.table(Cst4, file = "Cstlag_contemp_1way_TX.csv", sep=",", col.names=FALSE,row.names=FALSE)

#################################one-way specification#############################
##################################space-time lagged matrix#########################
#################Note that only immediate preceding cells are considered here######

Cst5<-kronecker(Ct1,Cs) + kronecker(Ct1,Is)
dim(Cst5)
#Cst5<-mat2listw(Cst5, style="B")
write.table(Cst5, file = "Cstlag_1way_TX.csv", sep=",", col.names=FALSE,row.names=FALSE)

##########one-way specification###########
##########space-time contemporaneous specification####################
#########Note that only immediate preceding cells are considered here######

Cst6<-kronecker(It,Cs) + kronecker(Ct1,Is)
dim(Cst6)
diag(Cst6) <- 1 #make diagnoal elemts 1
#Cst6<-mat2listw(Cst1, style="B")
write.table(Cst6, file = "Cstcontem_1way_TX_1diag.csv", sep=",",  col.names=FALSE, row.names=FALSE)



##########spatial specification###########

Cst7<-kronecker(It,Cs)
dim(Cst7)
diag(Cst7) <- 1 #make diagnoal elemts 1
#Cst6<-mat2listw(Cst1, style="B")
write.table(Cst7, file = "spatial_TX_1diag.csv", sep=",",  col.names=FALSE, row.names=FALSE)





############################################################
############################################################
#####################Test example###########################
############################################################
############################################################

T=4 ##9 months
N=3 ##49 states
swmat <- sample.int(2, 3*3, TRUE)-1L; dim(swmat) <- c(3,3)
swmat
It<-diag(T)
Is<-diag(N)
Cs<-swmat
Ct<-matrix(1, nrow = T, ncol = T)-It

######Zeroing some entries of matrix parallel to matrix diagonal in R########
zero.them<-function(x, n){
  x2<-x
  diag(x)<-0
  for(i in 1:n){
    diag(x[,(-1:-i)])<-0
    diag(x[(-1:-i),])<-0
    }
  x2[which(x==x2)] <- 0
  return(x2)
}

Ct<-zero.them(Ct, 1)
Ct
Ct[upper.tri(Ct)] <- 0
kronecker(It,Cs)
kronecker(Ct,Is)

Cst<-kronecker(It,Cs)+ kronecker(Ct,Is)
Cst

kronecker(It,Cs)











