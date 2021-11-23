using System;
using System.Buffers.Binary;
using System.Collections.Generic;

class Calculator
{
	private readonly static short[] registers = new short[16];
	private readonly static Stack<byte> stack = new();
	static void Main()
	{
		// Input
		registers[1] = 6;
		// Initialize the factorial
		Pushi((sbyte)1);
		Pushi((sbyte)0);
		Pop(2);
		while (true)
		{
			// bz R1, END
			if (registers[1] == 0)
				break;
			Push(0);
			Pop(13);
			Push(2);
			Pop(14);
			Push(1);
			Pop(15);
			// MULT_LOOP
			while (true)
			{
				// bz R15, MULT_LOOP_DONE
				if (registers[15] == 0)
					break;
				Push(13);
				Push(14);
				Add();
				Pop(13);
				// Now decrease the loop counter
				Pushi((sbyte)-1);
				Pushi((sbyte)-1);
				Push(15);
				Add();
				Pop(15); // R15--
			}
			// We have answer in R13
			Push(13);
			Pop(2);
			Pushi((sbyte)-1);
			Pushi((sbyte)-1);
			Push(1);
			Add();
			Pop(1);
		}
		Console.WriteLine(registers[2]);
	}
	private static void Push(int index)
	{
		Pushi(registers[index]);
	}

	private static void Pushi(sbyte value)
	{
		byte x = unchecked((byte)value);
		stack.Push(x);
	}

	private static void Pushi(short value)
	{
		Span<byte> bytes = stackalloc byte[2];
		BinaryPrimitives.WriteInt16BigEndian(bytes, value);
		stack.Push(bytes[1]);
		stack.Push(bytes[0]);
	}

	private static void Pop(int index)
	{
		registers[index] = Popi();
	}

	private static void Add()
	{
		Pushi(unchecked((short)(Popi() + Popi())));
	}
	
	private static void Sub()
	{
		Pushi(unchecked((short)(-Popi() + Popi())));
	}

	private static short Popi()
	{
		Span<byte> bytes = stackalloc byte[2];
		bytes[0] = stack.Pop();
		bytes[1] = stack.Pop();
		return BinaryPrimitives.ReadInt16BigEndian(bytes);
	}
}