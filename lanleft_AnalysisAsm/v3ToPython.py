

def changeArr(arr, intVal):
    for i in range(intVal):
        for j in range(intVal -1):
            if arr[j+1] < arr[j]:
                arr[j+1], arr[j] = arr[j], arr[j+1]

val1, val2, val3, val4, val5, val6 = 3, 2, 777, 4, 1, 0 
arr = [3, 2, 777, 4, 1, 0]
# for i in range(6):
#     print ( arr[i] )
# print ("\n\n")
print (arr)
changeArr(arr, 6)
# for i in range(6):
#     print (arr[i])
print (arr)