from tkinter import *



def btnClick(numbers):
	global operator
	operator = operator + str(numbers)
	text_Input.set(operator)

def btnClear():
	global operator
	operator = ""
	text_Input.set("")

def btnDel():
	global operator
	operator = operator[0:-1]
	text_Input.set(operator)
def btnEqu():
	global operator
	i = len(operator)
	if operator[i-2] == "/" and operator[i-1] == "0":
		text_Input.set("Cannot divide by zero")
	else: 
		operator = str(eval(operator))
		text_Input.set(operator)

def btnNegative():
	global operator
	operator = "-" + operator
	
	text_Input.set(operator)

cal = Tk()
cal.title("Calculator")
operator = ""
text_Input  = StringVar()

txtDisplay1 = Entry(cal, font=('arial', 20, 'bold'), textvariable=text_Input, bd=40, insertwidth=4,
					bg='powder blue', justify='right').grid( columnspan=4)

btnCE=Button(cal,padx=12, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="CE",bg='powder blue', command=btnClear).grid(row=1, column=0)
btnC=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="C",bg='powder blue', command=btnClear).grid(row=1, column=1)
btnDE=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="DE",bg='powder blue', command = btnDel).grid(row=1, column=2)
btnDiv=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="/",bg='powder blue',  command=lambda:btnClick('/')).grid(row=1, column=3)


btn7=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="7",bg='powder blue',  command=lambda:btnClick(7)).grid(row=2, column=0)

btn8=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="8",bg='powder blue',  command=lambda:btnClick(8)).grid(row=2, column=1)
btn7=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="9",bg='powder blue',  command=lambda:btnClick(9)).grid(row=2, column=2)
btnMul=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="*",bg='powder blue',  command=lambda:btnClick('*')).grid(row=2, column=3)
btn4=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="4",bg='powder blue',  command=lambda:btnClick(4)).grid(row=3, column=0)


btn5=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="5",bg='powder blue',  command=lambda:btnClick(5)).grid(row=3, column=1)

btn6=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="6",bg='powder blue',  command=lambda:btnClick(6)).grid(row=3, column=2)

btnSub=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="-",bg='powder blue',  command=lambda:btnClick('-')).grid(row=3, column=3)


btn1=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="1",bg='powder blue',  command=lambda:btnClick(1)).grid(row=4, column=0)

btn2=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="2",bg='powder blue',  command=lambda:btnClick(2)).grid(row=4, column=1)

btn3=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="3",bg='powder blue',  command=lambda:btnClick(3)).grid(row=4, column=2)

btnAdd=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="+",bg='powder blue',  command=lambda:btnClick('+')).grid(row=4, column=3)


btnNeg=Button(cal,padx=16, bd=4, fg="black", font=('arial', 20, 'bold'),
			text="NEG",bg='powder blue', command = btnNegative).grid(row=5, column=0)

btn0=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="0",bg='powder blue',  command=lambda:btnClick(0)).grid(row=5, column=1)

btnEqu=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text="=",bg='powder blue', command=btnEqu).grid(row=5, column=3)

btnNull=Button(cal,padx=16, bd=8, fg="black", font=('arial', 20, 'bold'),
			text=".",bg='powder blue',  command=lambda:btnClick('.')).grid(row=5, column=2)

cal.mainloop()