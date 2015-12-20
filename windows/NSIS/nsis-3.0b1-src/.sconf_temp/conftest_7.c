
		int __main() {
			
char c[128] = "test";
c[0] = '6'; // avoid c being optimized out
return c[1]; // avoid c being optimized out

			return 0;
		}
	