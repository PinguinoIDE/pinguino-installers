
		int __main() {
			
struct s // gcc 3
{
  char c[128];
} t = { "test" };
char a[] = // gcc 4
  {'/', 'F', 'I' ,'L', 'L', 'S', 'C', 'R', 'E', 'E', 'N', 0};
int i;
for (i = 0; i < 100; i++) // avoid a and t being optimized out
{
  i += a[i] ^ t.c[i];
}
return i;

			return 0;
		}
	