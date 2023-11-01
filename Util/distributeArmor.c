#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct armor
{
	int maxArmor;
	int HD;
	int CT, LT, RT;
	int LA, RA;
	int LL, RL;
} Armor;

/*
CT = 100% > 0.2105x

LT, RT = 90% > 0.15x
LA, RA = 50% > 0.1026x
LL, RL = 66% > 0.1381x
*/

int moveArmor(int* to, int* from, int base, double mod)
{
	*to = round(base * mod);
	*from -= *to;
}

int main(int argc, char** argv)
{
	if(argc < 2)
	{
		printf("Usage: %s (int)<amount>\n", argv[0]);
		return 0;
	}

	char* amt = argv[1];
	int curArmor = atoi(amt);

	Armor ar;
	ar.HD = 12;
	ar.maxArmor = curArmor - 12;
	curArmor -= ar.HD;

	moveArmor(&ar.CT, &curArmor, ar.maxArmor, 0.2105);
	moveArmor(&ar.LT, &curArmor, ar.maxArmor, 0.15);
	moveArmor(&ar.RT, &curArmor, ar.maxArmor, 0.15);
	moveArmor(&ar.LA, &curArmor, ar.maxArmor, 0.1026);
	moveArmor(&ar.RA, &curArmor, ar.maxArmor, 0.1026);
	moveArmor(&ar.LL, &curArmor, ar.maxArmor, 0.1381);
	moveArmor(&ar.RL, &curArmor, ar.maxArmor, 0.1381);

	printf("[HD] - %d\n", ar.HD);
	printf("[CT] - %d\n", ar.CT);
	printf("[LT] - %d\n", ar.LT);
	printf("[RT] - %d\n", ar.RT);
	printf("[LA] - %d\n", ar.LA);
	printf("[RA] - %d\n", ar.RA);
	printf("[LL] - %d\n", ar.LL);
	printf("[RL] - %d\n", ar.RL);
	printf("Wildcard points %d\n", curArmor);

	return 0;
}

