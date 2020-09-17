import random 

# class NotSoRandom(object):
#     def seed(self, a = 3):
#         self.seedval = a 
#     def random(self):
#         self.seedval = (self.seedval * 3) % 6 
#         return self.seedval

# _inst = NotSoRandom()
# seed = _inst.seed 
# random = _inst.random
# seed(1234)
# print ([random() for _ in range(20)])
val = 0
# case = random()
case = random.randint(0, 5)
if case == 0:
    val = 18
elif case == 1:
    val = 2
elif case == 2:
    val = 80
elif case == 3:
    val = 777
elif case == 4:
    val = 7
elif case == 5:
    val = 31
else:
    print ("no value")

print (val)