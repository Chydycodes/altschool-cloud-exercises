# Exercise 9

## Task:

193.16.20.35/29

What is the Network IP, number of hosts, range of IP addresses and broadcast IP from this subnet?

## Instruction:

Submit all your answer as a markdown file in the folder for this exercise.

## Solution

### 1. NETWORK IP 

To caculate the network Ip, all hosts bits are 0's. 

Firstly, we convert the Ip addresses to a binaary form 

193.16.20.35/29 => 11000001 00010000 00010100 00100011

Since all host bits are 0, we have => 11000001 00010000 00010100 00100000

Then, we covert back to it's decimal value => 193.16.20.32

Therefore the Network IP of 193.16.20.35/29 is `193.16.20.32`



### 2. NUMBER OF HOSTS

To  calculate the number of hosts => 2^h - 2

2^ (32 -29) -2

2^3 - 2 = 6

`Therfore, number of hosts available on the network is 6`



### 3. RANGE 

Range lies between the network IP and the brroadcast IP

`193.16.20.33

193.16.20.34

193.16.20.35

193.16.20.36

193.16.20.37

193.16.20.38`




### 4. BROADCAST IP 

To caculate the broadcast Ip, all hosts bits are 1's. 

Firstly, we convert the Ip addresses to a binary form 

193.16.20.35/29 => 11000001 00010000 00010100 00100011

Since all host bits are 1, we have => 11000001 00010000 00010100 00100111

Then, we covert back to it's decimal value => 193.16.20.39

Therefore the Broadcast IP of 193.16.20.35/29 is `193.16.20.39`
