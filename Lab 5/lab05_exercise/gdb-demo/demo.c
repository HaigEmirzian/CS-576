#include <stdio.h>
#include <string.h>

void copy(const char *str)
{
	char buf[16];

	strcpy(buf, str);

	puts(buf);
}

int main(int argc, char **argv)
{
	if (argc < 2)
		return 1;
	copy(argv[1]);
	return 0;
}
