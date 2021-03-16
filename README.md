# Fraud detection - credit card transactions

Problem statement /Business problem 
Our objective is to spot possible frauds in credit card operations. 
This identiﬁcation will be based on the client´s proﬁle, the seller´s proﬁle and the data of the transaction itself. 
The objective is to ﬂag transactions with the high possibility of fraud. 
Today frauds spin around 4% of all sales made with credit cards in Brazil. 
Our client already has mechanisms in place that detects potential fraudulent transactions, however, these mechanisms have two problems: 
1) They deploy semi¬static rules that generate a scenario where people in the background have to keep looking for new types of fraud to keep adjusting the current model. 
2) The process suﬀers a paradoxical problem: if it is too stringent it creates problems for the clients blocking legit sales if it is too lose it allows a too high level of fraud. A middle term is diﬃcult to archive – even more so when you have to keep adjusting the rules. 

To address these two issues, the idea would be to create a model that would not only identify (or at least ﬂag) the suspect transactions but also would identify changes in the patterns and adapt automatically to new fraud patterns. 
In order to do that we managed to get a database merging the three data sources (client, seller and transaction) and the idea is to develop a machine learning model which not only assertive (Assertive meaning identify a high percentage of the actual frauds without blocking too many legit ones) but adaptable. 
We were verbally informed that the current mechanism spots around 50% (2% of the total) of potential frauds and ﬂags around 2% of legit ones (false positive). If that is true (We have no way to verify this information), it means that the current process gets it right at around 2% of all transactions and wrong at 2%. In summary, it can stop 50% of all fraudulent transactions and has a false positive rate of 2%. 
It is interesting to notice that although frauds correspond to just 4% of all transactions, they answer for 8% of the total value of the transactions. It means each 1% of fraud elimination corresponds to approximately R$ 16.000.000,00 /month (CAD 5.330.000,00). 

